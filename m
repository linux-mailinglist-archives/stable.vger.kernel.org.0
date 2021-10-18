Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20810431DDE
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhJRNzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234326AbhJRNxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F666619E9;
        Mon, 18 Oct 2021 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564351;
        bh=e8qQFMpLhHNOyVhKGd/xjg6BC5ZtnpHOFVL2vcM3arY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyOdohwWvd9KmXNtjfsjEg0sd3sTq9iiZ7WGE1cIrqOcfCNlTKHjifkVHKLZGgaUY
         elp7l/Oo2nC75PAtaXCSpPB9tKt+Ojmd7jllFQ2YtkxKbeW8gwNO6obzKjXPRTbBif
         jlDoF/o3laQPhm6W/3cCxPaYqauZms4Vb7CMWDeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Potsch <hans.potsch@nokia.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.14 056/151] EDAC/armada-xp: Fix output of uncorrectable error counter
Date:   Mon, 18 Oct 2021 15:23:55 +0200
Message-Id: <20211018132342.519237962@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Potsch <hans.potsch@nokia.com>

commit d9b7748ffc45250b4d7bcf22404383229bc495f5 upstream.

The number of correctable errors is displayed as uncorrectable
errors because the "SBE" error count is passed to both calls of
edac_mc_handle_error().

Pass the correct uncorrectable error count to the second
edac_mc_handle_error() call when logging uncorrectable errors.

 [ bp: Massage commit message. ]

Fixes: 7f6998a41257 ("ARM: 8888/1: EDAC: Add driver for the Marvell Armada XP SDRAM and L2 cache ECC")
Signed-off-by: Hans Potsch <hans.potsch@nokia.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20211006121332.58788-1-hans.potsch@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/armada_xp_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/armada_xp_edac.c
+++ b/drivers/edac/armada_xp_edac.c
@@ -178,7 +178,7 @@ static void axp_mc_check(struct mem_ctl_
 				     "details unavailable (multiple errors)");
 	if (cnt_dbe)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
-				     cnt_sbe, /* error count */
+				     cnt_dbe, /* error count */
 				     0, 0, 0, /* pfn, offset, syndrome */
 				     -1, -1, -1, /* top, mid, low layer */
 				     mci->ctl_name,


