Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFC065801A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiL1QNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbiL1QNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:13:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5082619C13
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:11:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D97C361576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4FFC433D2;
        Wed, 28 Dec 2022 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243888;
        bh=fE3QMOo2s3TQgHsLdMZsi7UgSOkYnFXOB8fBJmKgvsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0CDKpWotqh3cfxsDtLuD5Uk+TDKHHh848wq9u5tNYq+OClc6Fcdc6Nx6bl0MS+Ox
         kKYZDILe9kdiIbPgkBuILGas+pxHyYEXelCtCO5LBTporrNchQbRm29C1/yAR+9WVO
         JD+wnKJMYO4ZAHYkOUHiI9zd1H9gaZlIAVLYmPNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0605/1073] PCI: Check for alloc failure in pci_request_irq()
Date:   Wed, 28 Dec 2022 15:36:33 +0100
Message-Id: <20221228144344.479779542@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 2d9cd957d40c3ac491b358e7cff0515bb07a3a9c ]

When kvasprintf() fails to allocate memory, it returns a NULL pointer.
Return error from pci_request_irq() so we don't dereference it.

[bhelgaas: commit log]
Fixes: 704e8953d3e9 ("PCI/irq: Add pci_request_irq() and pci_free_irq() helpers")
Link: https://lore.kernel.org/r/20221121020029.3759444-1-zengheng4@huawei.com
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/irq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/irq.c b/drivers/pci/irq.c
index 12ecd0aaa28d..0050e8f6814e 100644
--- a/drivers/pci/irq.c
+++ b/drivers/pci/irq.c
@@ -44,6 +44,8 @@ int pci_request_irq(struct pci_dev *dev, unsigned int nr, irq_handler_t handler,
 	va_start(ap, fmt);
 	devname = kvasprintf(GFP_KERNEL, fmt, ap);
 	va_end(ap);
+	if (!devname)
+		return -ENOMEM;
 
 	ret = request_threaded_irq(pci_irq_vector(dev, nr), handler, thread_fn,
 				   irqflags, devname, dev_id);
-- 
2.35.1



