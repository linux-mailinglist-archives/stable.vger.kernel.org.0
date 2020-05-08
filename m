Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41A21CAB6D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgEHMnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729090AbgEHMna (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA85324973;
        Fri,  8 May 2020 12:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941810;
        bh=roUaHz8MHMjmDB9ObLTQQ6lZmhETEMG/5A079nKtApI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdWsxKupw5ZJdVEkFUg19w60ZUJ/aN4UySMcHKlnHJqAB7YUwJz6HBkTVjYgCaHxi
         l2+tk4lwzyfpyCMa8vcwR6c2DP3joyCKCEPGyhfJKkFUVi/kyXf9IPkYDOZHQL0hjr
         Fm0X2hPv89dXCfwE/hV07xhFyxTTWmgS11ONCU4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 180/312] qede: uninitialized variable in qede_start_xmit()
Date:   Fri,  8 May 2020 14:32:51 +0200
Message-Id: <20200508123137.148201955@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 810810ffb2f6d46365d0790bbe77698a5534393a upstream.

"data_split" was never set to false.  It's just uninitialized.

Fixes: 2950219d87b0 ('qede: Add basic network device support')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/qlogic/qede/qede_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -400,7 +400,7 @@ netdev_tx_t qede_start_xmit(struct sk_bu
 	u8 xmit_type;
 	u16 idx;
 	u16 hlen;
-	bool data_split;
+	bool data_split = false;
 
 	/* Get tx-queue context and netdev index */
 	txq_index = skb_get_queue_mapping(skb);


