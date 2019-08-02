Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730FC7F28C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392061AbfHBJqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405599AbfHBJql (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60CEE2086A;
        Fri,  2 Aug 2019 09:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739200;
        bh=NZBYPz9/upGof+pf+7aPQwh2oUQ15oTbaqLDqA5xc1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRQOhlXoNdQIRTUzn/zfkE3k7dYCGQz0hfzCJh0zxPW8FrBGzkbd26zOiKLzXAMpd
         UzSp06/hae9/sWjqUxBt/qdoTx8BUlXtgN+DmuwBWo3/P5gQYZpNf8b0FS58pxTLLH
         iCx+YaP51l/dYk9u52nC0Pvmg1E3Q0kCFTWd6TmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Wei <albin_yang@163.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 138/223] nfc: fix potential illegal memory access
Date:   Fri,  2 Aug 2019 11:36:03 +0200
Message-Id: <20190802092247.734370576@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Wei <albin_yang@163.com>

[ Upstream commit dd006fc434e107ef90f7de0db9907cbc1c521645 ]

The frags_q is not properly initialized, it may result in illegal memory
access when conn_info is NULL.
The "goto free_exit" should be replaced by "goto exit".

Signed-off-by: Yang Wei <albin_yang@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -119,7 +119,7 @@ static int nci_queue_tx_data_frags(struc
 	conn_info = nci_get_conn_info_by_conn_id(ndev, conn_id);
 	if (!conn_info) {
 		rc = -EPROTO;
-		goto free_exit;
+		goto exit;
 	}
 
 	__skb_queue_head_init(&frags_q);


