Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63970469DE7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376954AbhLFPeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47600 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387271AbhLFPa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:30:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E96561319;
        Mon,  6 Dec 2021 15:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83477C34901;
        Mon,  6 Dec 2021 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804448;
        bh=rAaja8OqKShVk0JRcifhjGZBXNwsWvpxrp6Ha6XRalY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VA6DOk4TRJTdm1yB2/3ud/X8f+kxbRRsmkV5KJ4jBX/hoJgdU9a34oQVdVr+8Il89
         yOiXzPM8WVAzi47iWv65XasbqzUu7REwkd7qKQaA8uAMDV9NlHlGy0MAlM62gUpkrm
         bzjdgQraTb0xwIiWAxzHwMiQNHusOyE+4u5LCIQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Saurabh <ssaurabh@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 151/207] atlantic: Remove warn trace message.
Date:   Mon,  6 Dec 2021 15:56:45 +0100
Message-Id: <20211206145615.466097886@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Saurabh <ssaurabh@marvell.com>

commit 060a0fb721ec5bbe02ae322e434ec87dc25ed6e9 upstream.

Remove the warn trace message - it's not a correct check here, because
the function can still be called on the device in DOWN state

Fixes: 508f2e3dce454 ("net: atlantic: split rx and tx per-queue stats")
Signed-off-by: Sameer Saurabh <ssaurabh@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -362,9 +362,6 @@ unsigned int aq_vec_get_sw_stats(struct
 {
 	unsigned int count;
 
-	WARN_ONCE(!aq_vec_is_valid_tc(self, tc),
-		  "Invalid tc %u (#rx=%u, #tx=%u)\n",
-		  tc, self->rx_rings, self->tx_rings);
 	if (!aq_vec_is_valid_tc(self, tc))
 		return 0;
 


