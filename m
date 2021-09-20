Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CC54125D5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354825AbhITSsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384092AbhITSqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 579ED63362;
        Mon, 20 Sep 2021 17:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159215;
        bh=oUTH+wojMVJzqtmwNww4RdHNRycr2YogW+WBYDYXTz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrUjOv9sEsf+y4eU3PEUUrdRzSBeCyc68qE+8unDxEeyQls7H5nJasf3gL1P2O2h6
         TqPJLbysTQevtpv3MXao8VbVwdtFM0ec40eBc+dV95QcqVE39ApYHgTf6oVYJGE5TY
         nDdXg6Lbhidd7svyyi1gZpgA8xx9uQivsrrhmS3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 128/168] PCI: Fix pci_dev_str_match_path() alloc while atomic bug
Date:   Mon, 20 Sep 2021 18:44:26 +0200
Message-Id: <20210920163925.873874930@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
index a5e6759c407b..a4eb0c042ca3 100644
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



