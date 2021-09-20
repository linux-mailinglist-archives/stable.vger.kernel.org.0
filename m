Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBF5412483
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348981AbhITSfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380080AbhITSc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E27B7632F6;
        Mon, 20 Sep 2021 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158856;
        bh=6dgPeGQpOP/EK4d94LMo37AvooaegR2+endVg9hne9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLXFukd8/WEYyTbyBtqjqxH+ffB5N7IGT6CpDh6S630WMO3SrZDHGFD7P6/7Aw35t
         1v1W2zs8hD3jvnVL08RRQr125SL10rURoRO83CFOP6b2487qo9t37jsZLtlKZGSyjN
         8h9kYXqSwsPxXNJ5gO1hCU38TbPIEyiGB8Hv3k48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/122] PCI: Fix pci_dev_str_match_path() alloc while atomic bug
Date:   Mon, 20 Sep 2021 18:44:19 +0200
Message-Id: <20210920163918.639766985@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7eb6ea4148579b85540a41d57bcec315b8af8ff8 ]

pci_dev_str_match_path() is often called with a spinlock held so the
allocation has to be atomic.  The call tree is:

  pci_specified_resource_alignment() <-- takes spin_lock();
    pci_dev_str_match()
      pci_dev_str_match_path()

Fixes: 45db33709ccc ("PCI: Allow specifying devices using a base bus and path of devfns")
Link: https://lore.kernel.org/r/20210812070004.GC31863@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index eae6a9fdd33d..0d7109018a91 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -265,7 +265,7 @@ static int pci_dev_str_match_path(struct pci_dev *dev, const char *path,
 
 	*endptr = strchrnul(path, ';');
 
-	wpath = kmemdup_nul(path, *endptr - path, GFP_KERNEL);
+	wpath = kmemdup_nul(path, *endptr - path, GFP_ATOMIC);
 	if (!wpath)
 		return -ENOMEM;
 
-- 
2.30.2



