Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F26717FDF3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgCJMtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgCJMte (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:49:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815EC20674;
        Tue, 10 Mar 2020 12:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844574;
        bh=no0GuCpqckWefi6gyJZFiaQKtELfKYDvpEWkHUb1ENc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcC+euPeO5sBEu0k/TDLDkhIDpZgsQLy7Czvaw0H8qdH2AYQCET1E4v1TQ6tVOTT8
         QQ3EEIXpWo+fb4LXil/74C7PklTRTiZfjK73TXyxbY+GRLjVqPJ5zMVWlAzXsLTi5j
         JeMQ1QhkzcetbuIAzDs8QGQE684DkPGRuzXey1Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Shyjumon N <shyjumon.n@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/168] nvme/pci: Add sleep quirk for Samsung and Toshiba drives
Date:   Tue, 10 Mar 2020 13:38:08 +0100
Message-Id: <20200310123639.646314392@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyjumon N <shyjumon.n@intel.com>

[ Upstream commit 1fae37accfc5872af3905d4ba71dc6ab15829be7 ]

The Samsung SSD SM981/PM981 and Toshiba SSD KBG40ZNT256G on the Lenovo
C640 platform experience runtime resume issues when the SSDs are kept in
sleep/suspend mode for long time.

This patch applies the 'Simple Suspend' quirk to these configurations.
With this patch, the issue had not been observed in a 1+ day test.

Reviewed-by: Jon Derrick <jonathan.derrick@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shyjumon N <shyjumon.n@intel.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 570c75c92e293..c8e55674cf937 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2753,6 +2753,18 @@ static unsigned long check_vendor_combination_bug(struct pci_dev *pdev)
 		    (dmi_match(DMI_BOARD_NAME, "PRIME B350M-A") ||
 		     dmi_match(DMI_BOARD_NAME, "PRIME Z370-A")))
 			return NVME_QUIRK_NO_APST;
+	} else if ((pdev->vendor == 0x144d && (pdev->device == 0xa801 ||
+		    pdev->device == 0xa808 || pdev->device == 0xa809)) ||
+		   (pdev->vendor == 0x1e0f && pdev->device == 0x0001)) {
+		/*
+		 * Forcing to use host managed nvme power settings for
+		 * lowest idle power with quick resume latency on
+		 * Samsung and Toshiba SSDs based on suspend behavior
+		 * on Coffee Lake board for LENOVO C640
+		 */
+		if ((dmi_match(DMI_BOARD_VENDOR, "LENOVO")) &&
+		     dmi_match(DMI_BOARD_NAME, "LNVNB161216"))
+			return NVME_QUIRK_SIMPLE_SUSPEND;
 	}
 
 	return 0;
-- 
2.20.1



