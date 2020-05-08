Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC3E1CAF00
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgEHNNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729618AbgEHMsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2F732145D;
        Fri,  8 May 2020 12:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942081;
        bh=WnmcXTXsiT6QBqU7y2rKUaAHDFDo3K4E7Fg5YW5WJIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klN4SmQZnuJF3Gt5pkp9YxGUUArkVF3UM1+cHskDD7LbetphspmN0x4E+choELnTd
         EyyDpkbnGG5kYdBqGSmv4Jo71gGSBy1VIrx0sJw9KD+LJ4JK8Pb00UDe+/2oYyhBG0
         v043nZOD0jpcBUIkhz596/HuldcuX6bMRfAoCxTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 290/312] mvpp2: use correct size for memset
Date:   Fri,  8 May 2020 14:34:41 +0200
Message-Id: <20200508123144.777181962@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit e8f967c3d88489fc1562a31d4e44d905ac1d3aff upstream.

gcc-7 detects a short memset in mvpp2, introduced in the original
merge of the driver:

drivers/net/ethernet/marvell/mvpp2.c: In function 'mvpp2_cls_init':
drivers/net/ethernet/marvell/mvpp2.c:3296:2: error: 'memset' used with length equal to number of elements without multiplication by element size [-Werror=memset-elt-size]

The result seems to be that we write uninitialized data into the
flow table registers, although we did not get any warning about
that uninitialized data usage.

Using sizeof() lets us initialize then entire array instead.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mvpp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvpp2.c
+++ b/drivers/net/ethernet/marvell/mvpp2.c
@@ -3305,7 +3305,7 @@ static void mvpp2_cls_init(struct mvpp2
 	mvpp2_write(priv, MVPP2_CLS_MODE_REG, MVPP2_CLS_MODE_ACTIVE_MASK);
 
 	/* Clear classifier flow table */
-	memset(&fe.data, 0, MVPP2_CLS_FLOWS_TBL_DATA_WORDS);
+	memset(&fe.data, 0, sizeof(fe.data));
 	for (index = 0; index < MVPP2_CLS_FLOWS_TBL_SIZE; index++) {
 		fe.index = index;
 		mvpp2_cls_flow_write(priv, &fe);


