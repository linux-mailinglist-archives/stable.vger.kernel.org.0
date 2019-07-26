Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3819F76865
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfGZNoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbfGZNoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:44:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7416E22CBF;
        Fri, 26 Jul 2019 13:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148660;
        bh=Ucqr2C+XMCRm+Qzt8YSulePDv+pQyMACI3l8ABCE9pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBvJfxxq+7epw8jABRLaZmCDrlwk6uT+0uhq80sFCx2hZ40ytA1wrf494RleKab+n
         eDt9MP99fAByyNu59JSiH1B+2koYGWkQBzcks8EvLAUMi0Voy534vKHnD1QgNOUnxv
         XEsSoaOLovQyYorDB0A6PsMzW3zKzNIlZ3C6mj7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@ispras.ru>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 30/37] floppy: fix div-by-zero in setup_format_params
Date:   Fri, 26 Jul 2019 09:43:25 -0400
Message-Id: <20190726134332.12626-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@ispras.ru>

[ Upstream commit f3554aeb991214cbfafd17d55e2bfddb50282e32 ]

This fixes a divide by zero error in the setup_format_params function of
the floppy driver.

Two consecutive ioctls can trigger the bug: The first one should set the
drive geometry with such .sect and .rate values for the F_SECT_PER_TRACK
to become zero.  Next, the floppy format operation should be called.

A floppy disk is not required to be inserted.  An unprivileged user
could trigger the bug if the device is accessible.

The patch checks F_SECT_PER_TRACK for a non-zero value in the
set_geometry function.  The proper check should involve a reasonable
upper limit for the .sect and .rate fields, but it could change the
UAPI.

The patch also checks F_SECT_PER_TRACK in the setup_format_params, and
cancels the formatting operation in case of zero.

The bug was found by syzkaller.

Signed-off-by: Denis Efremov <efremov@ispras.ru>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3ea9c3e9acb3..4c6c20376a83 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2114,6 +2114,9 @@ static void setup_format_params(int track)
 	raw_cmd->kernel_data = floppy_track_buffer;
 	raw_cmd->length = 4 * F_SECT_PER_TRACK;
 
+	if (!F_SECT_PER_TRACK)
+		return;
+
 	/* allow for about 30ms for data transport per track */
 	head_shift = (F_SECT_PER_TRACK + 5) / 6;
 
@@ -3238,6 +3241,8 @@ static int set_geometry(unsigned int cmd, struct floppy_struct *g,
 	/* sanity checking for parameters. */
 	if (g->sect <= 0 ||
 	    g->head <= 0 ||
+	    /* check for zero in F_SECT_PER_TRACK */
+	    (unsigned char)((g->sect << 2) >> FD_SIZECODE(g)) == 0 ||
 	    g->track <= 0 || g->track > UDP->tracks >> STRETCH(g) ||
 	    /* check if reserved bits are set */
 	    (g->stretch & ~(FD_STRETCH | FD_SWAPSIDES | FD_SECTBASEMASK)) != 0)
-- 
2.20.1

