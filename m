Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A834412357
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378105AbhITSX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377865AbhITSV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9055A632B3;
        Mon, 20 Sep 2021 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158639;
        bh=4yDISMmyrm+cG+A5+reyGD82tQKcWXQHwS2eIO1obUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrTXB50AwG2Bl9KfUle5ZXjPlyHzZ/2wOPm1ZqeYZ8GjhAheloQuldIFzu5ZTlzk/
         haB/g69agTZr22UqeyRV+Mg+iGfGmHL8SQmEO7DIW5gVefIAaaLkwWwqX73rS1/9eu
         K71xaSXhyYErVQjP0N2oXQCXs1iJacyuUgrYP/DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 248/260] PCI: Fix pci_dev_str_match_path() alloc while atomic bug
Date:   Mon, 20 Sep 2021 18:44:26 +0200
Message-Id: <20210920163939.541069072@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index 91b2733ded17..b9550cd4280c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -224,7 +224,7 @@ static int pci_dev_str_match_path(struct pci_dev *dev, const char *path,
 
 	*endptr = strchrnul(path, ';');
 
-	wpath = kmemdup_nul(path, *endptr - path, GFP_KERNEL);
+	wpath = kmemdup_nul(path, *endptr - path, GFP_ATOMIC);
 	if (!wpath)
 		return -ENOMEM;
 
-- 
2.30.2



