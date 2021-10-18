Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7044B431BF9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhJRNg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232474AbhJRNfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C21AF61378;
        Mon, 18 Oct 2021 13:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563832;
        bh=e8qQFMpLhHNOyVhKGd/xjg6BC5ZtnpHOFVL2vcM3arY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0agewiiyo1s6HIdw5MTCcJ7+wUhuHVgIlH4w7hiPyLn/yuXe/+DYsdX6bAvsDV6ap
         dtA7vWayAwswWlZVyIHlpCu0MEmKNYWKXpj3ZCzMU5XGD7YS+Nk3Q+QQ5rIhnaf1wz
         FvzIuZL8LyL6FoMn41Gsn9f3s7tMR3uwzfDtxD/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Potsch <hans.potsch@nokia.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 32/69] EDAC/armada-xp: Fix output of uncorrectable error counter
Date:   Mon, 18 Oct 2021 15:24:30 +0200
Message-Id: <20211018132330.546178128@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
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


