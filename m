Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E96943A013
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhJYT1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235110AbhJYTZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0B5B60FDC;
        Mon, 25 Oct 2021 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189750;
        bh=ZrsSBy57D8kFBiyUQ0yK6wBXOGDqNSH03H8z0Pjfs1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvSaS118kcwdse+zP0BHBIZUTHZ3w4aXqPq37RrXNhUdmt70qk4GC50m7mWk1BLgU
         EY2QfKj6EbOmgDrhy5ZX+5QYYq6fzpAH1bfQRfNFhd+x/pbf/Vo8LAK0nkE+2AE71V
         raGoVmSS2YndxcQd0dvmpQpwFVUED2dT3nfeVcsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 17/30] nfc: nci: fix the UAF of rf_conn_info object
Date:   Mon, 25 Oct 2021 21:14:37 +0200
Message-Id: <20211025190927.150505682@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 1b1499a817c90fd1ce9453a2c98d2a01cca0e775 upstream.

The nci_core_conn_close_rsp_packet() function will release the conn_info
with given conn_id. However, it needs to set the rf_conn_info to NULL to
prevent other routines like nci_rf_intf_activated_ntf_packet() to trigger
the UAF.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/rsp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -289,6 +289,8 @@ static void nci_core_conn_close_rsp_pack
 							 ndev->cur_conn_id);
 		if (conn_info) {
 			list_del(&conn_info->list);
+			if (conn_info == ndev->rf_conn_info)
+				ndev->rf_conn_info = NULL;
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}


