Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D82A15C45C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgBMPqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbgBMP1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:14 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A82D24676;
        Thu, 13 Feb 2020 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607634;
        bh=jQfY7XU1tHvH0sV+8wi4VdPGQNr5e3cMW4fXX/ijlL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPp1XSQlgqE5PxmPB6GXKFyZpMEihQfUKt4mk4GhGrfra607dFHrU2DWVs4rsSlCj
         KKDbHxFZw3JSj7K6soGg1Ye4CC9lv4+c1WOH9PKsG4r60xwOAFxSQOdsvaSKbLGyU3
         +v1EJXuLerK4Y3KYTrQ177niDdTHDM0n3QoYpeeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongdong Liu <liudongdong3@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 19/96] PCI/AER: Initialize aer_fifo
Date:   Thu, 13 Feb 2020 07:20:26 -0800
Message-Id: <20200213151846.722858494@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongdong Liu <liudongdong3@huawei.com>

commit d95f20c4f07020ebc605f3b46af4b6db9eb5fc99 upstream.

Previously we did not call INIT_KFIFO() for aer_fifo.  This leads to
kfifo_put() sometimes returning 0 (queue full) when in fact it is not.

It is easy to reproduce the problem by using aer-inject:

  $ aer-inject -s :82:00.0 multiple-corr-nonfatal

The content of the multiple-corr-nonfatal file is as below:

  AER
  COR RCVR
  HL 0 1 2 3
  AER
  UNCOR POISON_TLP
  HL 4 5 6 7

Fixes: 27c1ce8bbed7 ("PCI/AER: Use kfifo for tracking events instead of reimplementing it")
Link: https://lore.kernel.org/r/1579767991-103898-1-git-send-email-liudongdong3@huawei.com
Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/aer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1387,6 +1387,7 @@ static int aer_probe(struct pcie_device
 		return -ENOMEM;
 
 	rpc->rpd = port;
+	INIT_KFIFO(rpc->aer_fifo);
 	set_service_data(dev, rpc);
 
 	status = devm_request_threaded_irq(device, dev->irq, aer_irq, aer_isr,


