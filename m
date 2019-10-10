Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97378D232F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733187AbfJJIkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733089AbfJJIj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF3E520B7C;
        Thu, 10 Oct 2019 08:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696797;
        bh=ZJWDCC2fU/a/3yXYhKk3XyY44xVH0QvR1aJCNfPUzJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAOSjTg0LNYa9RG+++67/I9oojVCtNLnNMURXR581PwutS2Kz+kjUmWxA6F0RfaUO
         nE4WtACxJ1wusOiCedru/+nBNQBomPOLNL1sccGDUt5zuVQh/sWlzTAB/5F1XFmS9I
         HT0NIxoBiHeXeA2bNq7zKC8tbOs69ZvFvWrAAO88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.3 056/148] PCI: Restore Resizable BAR size bits correctly for 1MB BARs
Date:   Thu, 10 Oct 2019 10:35:17 +0200
Message-Id: <20191010083614.542332247@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Saxena <sumit.saxena@broadcom.com>

commit d2182b2d4b71ff0549a07f414d921525fade707b upstream.

In a Resizable BAR Control Register, bits 13:8 control the size of the BAR.
The encoded values of these bits are as follows (see PCIe r5.0, sec
7.8.6.3):

  Value    BAR size
     0     1 MB (2^20 bytes)
     1     2 MB (2^21 bytes)
     2     4 MB (2^22 bytes)
   ...
    43     8 EB (2^63 bytes)

Previously we incorrectly set the BAR size bits for a 1 MB BAR to 0x1f
instead of 0, so devices that support that size, e.g., new megaraid_sas and
mpt3sas adapters, fail to initialize during resume from S3 sleep.

Correctly calculate the BAR size bits for Resizable BAR control registers.

Link: https://lore.kernel.org/r/20190725192552.24295-1-sumit.saxena@broadcom.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203939
Fixes: d3252ace0bc6 ("PCI: Restore resized BAR state on resume")
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: stable@vger.kernel.org	# v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1443,7 +1443,7 @@ static void pci_restore_rebar_state(stru
 		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
 		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
 		res = pdev->resource + bar_idx;
-		size = order_base_2((resource_size(res) >> 20) | 1) - 1;
+		size = ilog2(resource_size(res)) - 20;
 		ctrl &= ~PCI_REBAR_CTRL_BAR_SIZE;
 		ctrl |= size << PCI_REBAR_CTRL_BAR_SHIFT;
 		pci_write_config_dword(pdev, pos + PCI_REBAR_CTRL, ctrl);


