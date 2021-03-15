Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB93933B771
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCOOAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhCON7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 980DE64E4D;
        Mon, 15 Mar 2021 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816723;
        bh=NDPQ7FYGS8yZ1oCfwTxWbaEhC+/5hAfhGVa8tPwknQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhISo5JW18V2CBhyLRzH0ChISpNNpejsy6FuFJSzQgnYO4rXwFV984C8CFLCYypm1
         52fp2wtUjDk+maeHlMW3MkJbyGiAv17y5t9lpIWYzaqAUzCyxN8ZwImXeMYpiu8ays
         e3t/JtGLaeh/1DAmtzYItIXc8zQlyGwpwaAF8tPQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 076/290] net: hns3: fix bug when calculating the TCAM table info
Date:   Mon, 15 Mar 2021 14:52:49 +0100
Message-Id: <20210315135544.480234037@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jian Shen <shenjian15@huawei.com>

commit b36fc875bcdee56865c444a2cdae17d354a6d5f5 upstream.

The function hclge_fd_convert_tuple() is used to convert tuples
and tuples mask to TCAM x and y.  But it misuses the source mac
as source mac mask when convert INNER_SRC_MAC, which may cause
the flow director rule works unexpectedly. So fix it.

Fixes: 117328680288 ("net: hns3: Add input key and action config support for flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5115,9 +5115,9 @@ static bool hclge_fd_convert_tuple(u32 t
 	case BIT(INNER_SRC_MAC):
 		for (i = 0; i < ETH_ALEN; i++) {
 			calc_x(key_x[ETH_ALEN - 1 - i], rule->tuples.src_mac[i],
-			       rule->tuples.src_mac[i]);
+			       rule->tuples_mask.src_mac[i]);
 			calc_y(key_y[ETH_ALEN - 1 - i], rule->tuples.src_mac[i],
-			       rule->tuples.src_mac[i]);
+			       rule->tuples_mask.src_mac[i]);
 		}
 
 		return true;


