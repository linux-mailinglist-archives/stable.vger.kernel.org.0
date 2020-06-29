Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B81820DE6A
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbgF2UZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732539AbgF2TZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EE1D253EC;
        Mon, 29 Jun 2020 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445341;
        bh=amQ/88/Q5IEsY7sfSt0vsd5Xmyi5RAeRdY8HvaqsLxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XujWJzuPl2pELlpK1Y85VQQHNgSiMxVp65JyPmgfapf6yEenwlppMsfH+jlaDDCAA
         k9hTNJ5FeDzbsZ8IdQfF71fC8aoG7rjIMRmGOYAlqI8Sltk1P4F6s0H8JIdmAS5IHv
         BO6hdRRX7GsZCpy/bx6gEufuO9zMQ5neDsZ1cvaM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 100/191] media: dvb/frontend.h: move out a private internal structure
Date:   Mon, 29 Jun 2020 11:38:36 -0400
Message-Id: <20200629154007.2495120-101-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit f35afa4f60c868d7c7811ba747133acbf39410ac upstream

struct dtv_cmds_h is just an ancillary struct used by the
dvb_frontend.c to internally store frontend commands.

It doesn't belong to the userspace header, nor it is used anywhere,
except inside the DVB core. So, remove it from the header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 11 +++++++++++
 include/uapi/linux/dvb/frontend.h     | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 3b045298546c7..7eeb5d302c9c5 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -998,6 +998,17 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	.buffer = b \
 }
 
+struct dtv_cmds_h {
+	char	*name;		/* A display name for debugging purposes */
+
+	__u32	cmd;		/* A unique ID */
+
+	/* Flags */
+	__u32	set:1;		/* Either a set or get property */
+	__u32	buffer:1;	/* Does this property use the buffer? */
+	__u32	reserved:30;	/* Align */
+};
+
 static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_TUNE, 1, 0),
 	_DTV_CMD(DTV_CLEAR, 1, 0),
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index afc3972b08795..3a80f3d1da1cd 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -384,17 +384,6 @@ enum atscmh_rs_code_mode {
 #define NO_STREAM_ID_FILTER	(~0U)
 #define LNA_AUTO                (~0U)
 
-struct dtv_cmds_h {
-	char	*name;		/* A display name for debugging purposes */
-
-	__u32	cmd;		/* A unique ID */
-
-	/* Flags */
-	__u32	set:1;		/* Either a set or get property */
-	__u32	buffer:1;	/* Does this property use the buffer? */
-	__u32	reserved:30;	/* Align */
-};
-
 /**
  * Scale types for the quality parameters.
  * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
-- 
2.25.1

