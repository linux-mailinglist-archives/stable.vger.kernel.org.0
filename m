Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7041C20DF31
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389167AbgF2UdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732396AbgF2TZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97230253FF;
        Mon, 29 Jun 2020 15:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445348;
        bh=Mej9ssHFMj3X60ejOpk7m0olOfhDlfijdDv4Gmjkx4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrANEctbxL1F8r8e7XcHQzv+x+7wyEy6sAUzRDitduZ+wclvmpKs6n4DJ/rOEbR+W
         cilG/pczqaidrR9bzzmWoaoGnj80Ne9m5LRHntU7FsgtCadNst62VNhGgcA5Hbvn4X
         36FQdI7nRCztoBgr9y3Lc9DRIrlPCycA/y1jJ2Lc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 106/191] media: dvb_frontend: get rid of set_property() callback
Date:   Mon, 29 Jun 2020 11:38:42 -0400
Message-Id: <20200629154007.2495120-107-sashal@kernel.org>
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

commit 6680e73b5226114992acfc11f9cf5730f706fb01 upstream

Now that all clients of set_property() were removed, get rid
of this callback.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 7 -------
 drivers/media/dvb-core/dvb_frontend.h | 5 -----
 2 files changed, 12 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 97c825f97b15e..2bf55a786e297 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1751,13 +1751,6 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	int r = 0;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.set_property) {
-		r = fe->ops.set_property(fe, tvp);
-		if (r < 0)
-			return r;
-	}
-
 	dtv_property_dump(fe, true, tvp);
 
 	switch(tvp->cmd) {
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 57cedbe5c2c79..f852f0a49f422 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -397,11 +397,8 @@ struct dtv_frontend_properties;
  * @search:		callback function used on some custom algo search algos.
  * @tuner_ops:		pointer to struct dvb_tuner_ops
  * @analog_ops:		pointer to struct analog_demod_ops
- * @set_property:	callback function to allow the frontend to validade
- *			incoming properties. Should not be used on new drivers.
  */
 struct dvb_frontend_ops {
-
 	struct dvb_frontend_info info;
 
 	u8 delsys[MAX_DELSYS];
@@ -459,8 +456,6 @@ struct dvb_frontend_ops {
 
 	struct dvb_tuner_ops tuner_ops;
 	struct analog_demod_ops analog_ops;
-
-	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
 };
 
 #ifdef __DVB_CORE__
-- 
2.25.1

