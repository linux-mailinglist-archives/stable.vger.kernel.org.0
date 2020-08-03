Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA7323A589
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgHCMd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729500AbgHCMd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:33:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F148204EC;
        Mon,  3 Aug 2020 12:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458035;
        bh=QGJLI3lpn7Q5Cm0/qHWjOxdlhi69SOT6w8GCqm/H52E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiDt6fEFlJwaxy0NlpbOmkolliLATNOWHxG+KANIFGZfNiXdjK0/ucpMJ9Lgos1Sz
         cvDY8NlAYJIMYOF+2WryCQOhYtRNAVm++m3XMDyyYc0urs25aE9FzodqDTWR3J/icj
         xvQHqPKLFRcNkZMOflPadW7ktOe+aDoXUPPIBLtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 04/51] media: rc: prevent memory leak in cx23888_ir_probe
Date:   Mon,  3 Aug 2020 14:19:49 +0200
Message-Id: <20200803121849.702208862@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit a7b2df76b42bdd026e3106cf2ba97db41345a177 ]

In cx23888_ir_probe if kfifo_alloc fails the allocated memory for state
should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23888-ir.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index 040323b0f9455..f63a7e6f272c2 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -1178,8 +1178,11 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
 		return -ENOMEM;
 
 	spin_lock_init(&state->rx_kfifo_lock);
-	if (kfifo_alloc(&state->rx_kfifo, CX23888_IR_RX_KFIFO_SIZE, GFP_KERNEL))
+	if (kfifo_alloc(&state->rx_kfifo, CX23888_IR_RX_KFIFO_SIZE,
+			GFP_KERNEL)) {
+		kfree(state);
 		return -ENOMEM;
+	}
 
 	state->dev = dev;
 	sd = &state->sd;
-- 
2.25.1



