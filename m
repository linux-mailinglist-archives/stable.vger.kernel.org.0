Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A714C35BE0C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbhDLI4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238773AbhDLIyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66DBD61262;
        Mon, 12 Apr 2021 08:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217570;
        bh=HrXDfkWLAHgBhHLX7G021lONn/NQRWIvuhj/m7t7rMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iujc37XeOK1SsUOa9mvet3S/dEDBF5ObR3tG1spJBZq8aSOXQN2eS/0OtORZx8A1P
         Hok/HZDXnv7V2N68JLGw+K1B0V9f5yFpcTlSrtiB5SaJSh0t6t0UqQh5jqdQjtrqb0
         67lpvxbVVi9vMhrxoCkOh4h7QmM9dsDLS7EX+eNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 027/188] ethtool: fix incorrect datatype in set_eee ops
Date:   Mon, 12 Apr 2021 10:39:01 +0200
Message-Id: <20210412084014.553443840@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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


