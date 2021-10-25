Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85D9439FB1
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhJYTXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234842AbhJYTWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C03C960EBC;
        Mon, 25 Oct 2021 19:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189586;
        bh=ZrsSBy57D8kFBiyUQ0yK6wBXOGDqNSH03H8z0Pjfs1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwWiMbdN971HgmQRoFeQZK9aFUxa21f86IX4uTyWQGD6DajC9NKgufxISChN9wShB
         rviBMJ+2USZbF+nfqKwTunu0PJIT+5eOLyIoaRRBm6yb2zM/FVekPrFUjcsdINENaC
         lGhoEbsLaDeXY4IGizmTnrVcjw8lvUZfszEzW+jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 40/50] nfc: nci: fix the UAF of rf_conn_info object
Date:   Mon, 25 Oct 2021 21:14:27 +0200
Message-Id: <20211025190940.041027108@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
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


