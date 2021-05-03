Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E333714F1
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhECMDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234103AbhECMCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:02:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E23261221;
        Mon,  3 May 2021 12:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043282;
        bh=hrHYuoQG/ES9lfigairRLe7dmuVCWKqJF81IJz0071w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFvngqLYw0bZDhB9D0bYhBAJY8Gn67Wv/KUC/rCKVSzqsbf0bNqNOTjMcbYSj/PqE
         +No1LnCiHDZOdQpfUt7q6SvNpRxLp7uYW/7J0Si8prkiqu4Z6kYSH56nSMTq8J+VYQ
         Pbc0YtvAkPTtnEb3uHhxc1gU6qM2eLtIDSH0re28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Aditya Pakki <pakki001@umn.edu>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 38/69] Revert "video: hgafb: fix potential NULL pointer dereference"
Date:   Mon,  3 May 2021 13:57:05 +0200
Message-Id: <20210503115736.2104747-39-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit ec7f6aad57ad29e4e66cc2e18e1e1599ddb02542.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

This patch "looks" correct, but the driver keeps on running and will
fail horribly right afterward if this error condition ever trips.

So points for trying to resolve an issue, but a huge NEGATIVE value for
providing a "fake" fix for the problem as nothing actually got resolved
at all.  I'll go fix this up properly...

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Ferenc Bakonyi <fero@drama.obuda.kando.hu>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Fixes: ec7f6aad57ad ("video: hgafb: fix potential NULL pointer dereference")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hgafb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index 8bbac7182ad3..fca29f219f8b 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -285,8 +285,6 @@ static int hga_card_detect(void)
 	hga_vram_len  = 0x08000;
 
 	hga_vram = ioremap(0xb0000, hga_vram_len);
-	if (!hga_vram)
-		goto error;
 
 	if (request_region(0x3b0, 12, "hgafb"))
 		release_io_ports = 1;
-- 
2.31.1

