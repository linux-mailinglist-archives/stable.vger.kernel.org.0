Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2D435BF3F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbhDLJDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239905AbhDLJBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AD3C61379;
        Mon, 12 Apr 2021 09:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218001;
        bh=HrXDfkWLAHgBhHLX7G021lONn/NQRWIvuhj/m7t7rMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P21mu7hYVvdKoJo8XULr/67sMBemqdOoXyURmrKUpaLxdfXT260H5PovSy9o/CzP5
         PAVXJKGUF3HicOEGkjuAb/K8HrIH+Q1zjI2rvfUOnN2lxNFxUCj+/ZqcR07fL7KTn8
         NgfB2H3veB5XfZFgjljbmQ3ErC+yZ8BgsFjB8Ycs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 034/210] ethtool: fix incorrect datatype in set_eee ops
Date:   Mon, 12 Apr 2021 10:38:59 +0200
Message-Id: <20210412084017.147653974@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

commit 63cf32389925e234d166fb1a336b46de7f846003 upstream.

The member 'tx_lpi_timer' is defined with __u32 datatype in the ethtool
header file. Hence, we should use ethnl_update_u32() in set_eee ops.

Fixes: fd77be7bd43c ("ethtool: set EEE settings with EEE_SET request")
Cc: <stable@vger.kernel.org> # 5.10.x
Cc: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/eee.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -169,8 +169,8 @@ int ethnl_set_eee(struct sk_buff *skb, s
 	ethnl_update_bool32(&eee.eee_enabled, tb[ETHTOOL_A_EEE_ENABLED], &mod);
 	ethnl_update_bool32(&eee.tx_lpi_enabled,
 			    tb[ETHTOOL_A_EEE_TX_LPI_ENABLED], &mod);
-	ethnl_update_bool32(&eee.tx_lpi_timer, tb[ETHTOOL_A_EEE_TX_LPI_TIMER],
-			    &mod);
+	ethnl_update_u32(&eee.tx_lpi_timer, tb[ETHTOOL_A_EEE_TX_LPI_TIMER],
+			 &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;


