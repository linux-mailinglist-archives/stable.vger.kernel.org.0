Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB538F016
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhEXQBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235761AbhEXQAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCF146145B;
        Mon, 24 May 2021 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871153;
        bh=4HOjAGHMT/mLxQ+ZWKE9kSuVmLG91trN+tFHhEclEC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTa5qoWtr50P931BSNvzQEd3FCPdJTMSUin9v7pLiH1P/0+6hA2AMYBAwAkXQbiFH
         hjsxk/Su4IMapc8tVPEp6Z3EyVEz1ovARDSrEQdO9KQagx94bi292FYx49KmtO1Lrm
         cCyx+Kjiw9Yg/Qo10QMfaOyjBzggZtMoZRYhJKAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Aditya Pakki <pakki001@umn.edu>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.12 096/127] Revert "video: hgafb: fix potential NULL pointer dereference"
Date:   Mon, 24 May 2021 17:26:53 +0200
Message-Id: <20210524152338.101235855@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 58c0cc2d90f1e37c4eb63ae7f164c83830833f78 upstream.

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
Link: https://lore.kernel.org/r/20210503115736.2104747-39-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hgafb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -285,8 +285,6 @@ static int hga_card_detect(void)
 	hga_vram_len  = 0x08000;
 
 	hga_vram = ioremap(0xb0000, hga_vram_len);
-	if (!hga_vram)
-		goto error;
 
 	if (request_region(0x3b0, 12, "hgafb"))
 		release_io_ports = 1;


