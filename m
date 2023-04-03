Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9656D4A4D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbjDCOqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbjDCOqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77EB16F06
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59C8861F25
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB80C4339B;
        Mon,  3 Apr 2023 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533105;
        bh=9v6fPcXoHqX2UYXzCOsQOtq2Xoz/bLwl3a0T8ElP0JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPTZfL7P6dHCeW3kCMXGjyArc/G2/LhIN8hj/PRUr5Ah6FXpxfVNm56CH5uBXHeb6
         BWVxMGmz2mDo94lx1CtWsH9Cdqjnp4IyWbZWdP6hkxdjFxhZPDJzIXYkOx26XpT3oN
         uAWp3O5U2EQoMhY0CS6olvWXgV5EU2Zf53PLZTyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Irvin Cote <irvincoteg@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 049/187] nvme-pci: fixing memory leak in probe teardown path
Date:   Mon,  3 Apr 2023 16:08:14 +0200
Message-Id: <20230403140417.596536916@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Irvin Cote <irvincoteg@gmail.com>

[ Upstream commit a61d265533b7fe0026a02a49916aa564ffe38e4c ]

In case the nvme_probe teardown path is triggered the ctrl ref count does
not reach 0 thus creating a memory leak upon failure of nvme_probe.

Signed-off-by: Irvin Cote <irvincoteg@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 29c902b9aecbd..c51ebbee8103e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3126,6 +3126,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	nvme_dev_unmap(dev);
 out_uninit_ctrl:
 	nvme_uninit_ctrl(&dev->ctrl);
+	nvme_put_ctrl(&dev->ctrl);
 	return result;
 }
 
-- 
2.39.2



