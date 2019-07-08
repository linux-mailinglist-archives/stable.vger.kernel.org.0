Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795306236B
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733247AbfGHPfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390924AbfGHPfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:35:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D069C204EC;
        Mon,  8 Jul 2019 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600117;
        bh=1KK2po7NyTP55ixosEs7UwaF4RaRt3CEIpQlKBVWY3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkr91wV55GBi3f9MdqkULAEhCF5Og4ludnenYjEYObnPFYQn5QIJGKJUS2qcA8BBH
         VJfSw6rT38ENPFjuyyLctsKjznwLuAm5QTg5HCTcmUj9fLelG7Ye7nKg1OS70rabcJ
         JAKj5+I8ZED1H1yFzfzMMB54MH4FeXEkyFOlvxnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.1 94/96] dmaengine: jz4780: Fix an endian bug in IRQ handler
Date:   Mon,  8 Jul 2019 17:14:06 +0200
Message-Id: <20190708150531.511815773@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4c89cc73d1da42ae48b5c5dfbfd12304d0b86786 upstream.

The "pending" variable was a u32 but we cast it to an unsigned long
pointer when we do the for_each_set_bit() loop.  The problem is that on
big endian 64bit systems that results in an out of bounds read.

Fixes: 4e4106f5e942 ("dmaengine: jz4780: Fix transfers being ACKed too soon")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dma-jz4780.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dma/dma-jz4780.c
+++ b/drivers/dma/dma-jz4780.c
@@ -722,12 +722,13 @@ static irqreturn_t jz4780_dma_irq_handle
 {
 	struct jz4780_dma_dev *jzdma = data;
 	unsigned int nb_channels = jzdma->soc_data->nb_channels;
-	uint32_t pending, dmac;
+	unsigned long pending;
+	uint32_t dmac;
 	int i;
 
 	pending = jz4780_dma_ctrl_readl(jzdma, JZ_DMA_REG_DIRQP);
 
-	for_each_set_bit(i, (unsigned long *)&pending, nb_channels) {
+	for_each_set_bit(i, &pending, nb_channels) {
 		if (jz4780_dma_chan_irq(jzdma, &jzdma->chan[i]))
 			pending &= ~BIT(i);
 	}


