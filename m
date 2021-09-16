Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0071140DF6E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhIPQJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhIPQIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:08:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8E2F61241;
        Thu, 16 Sep 2021 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808434;
        bh=ODfC5cu1o0iQv3QAYJGyXeX/iLMHG3K0L77eLf7t8js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIcn5udK7URA54LsZzupzCI3Pr97erQWPRF36cZJtSi/MejKbDVY33nGW4vR68GUF
         lPu6y5PQSTYErRWrM4mRdQZK5L35joLfYIoONLBM7pJ1f63gKGKXveVcwXLo15WpVr
         r3+rLmih+OwJobVfEG5RhAo6JK31k59e4sqqZEbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/306] iommu/vt-d: Update the virtual command related registers
Date:   Thu, 16 Sep 2021 17:57:14 +0200
Message-Id: <20210916155757.096699921@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 4d99efb229e63928c6b03a756a2e38cd4777fbe8 ]

The VT-d spec Revision 3.3 updated the virtual command registers, virtual
command opcode B register, virtual command response register and virtual
command capability register (Section 10.4.43, 10.4.44, 10.4.45, 10.4.46).
This updates the virtual command interface implementation in the Intel
IOMMU driver accordingly.

Fixes: 24f27d32ab6b7 ("iommu/vt-d: Enlightened PASID allocation")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Sanjay Kumar <sanjay.k.kumar@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20210713042649.3547403-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20210818134852.1847070-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.h | 10 +++++-----
 include/linux/intel-iommu.h |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 30cb30046b15..35963e6bf9fa 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -28,12 +28,12 @@
 #define VCMD_CMD_ALLOC			0x1
 #define VCMD_CMD_FREE			0x2
 #define VCMD_VRSP_IP			0x1
-#define VCMD_VRSP_SC(e)			(((e) >> 1) & 0x3)
+#define VCMD_VRSP_SC(e)			(((e) & 0xff) >> 1)
 #define VCMD_VRSP_SC_SUCCESS		0
-#define VCMD_VRSP_SC_NO_PASID_AVAIL	2
-#define VCMD_VRSP_SC_INVALID_PASID	2
-#define VCMD_VRSP_RESULT_PASID(e)	(((e) >> 8) & 0xfffff)
-#define VCMD_CMD_OPERAND(e)		((e) << 8)
+#define VCMD_VRSP_SC_NO_PASID_AVAIL	16
+#define VCMD_VRSP_SC_INVALID_PASID	16
+#define VCMD_VRSP_RESULT_PASID(e)	(((e) >> 16) & 0xfffff)
+#define VCMD_CMD_OPERAND(e)		((e) << 16)
 /*
  * Domain ID reserved for pasid entries programmed for first-level
  * only and pass-through transfer modes.
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index c00ee3458a91..142ec79cda84 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -122,9 +122,9 @@
 #define DMAR_MTRR_PHYSMASK8_REG 0x208
 #define DMAR_MTRR_PHYSBASE9_REG 0x210
 #define DMAR_MTRR_PHYSMASK9_REG 0x218
-#define DMAR_VCCAP_REG		0xe00 /* Virtual command capability register */
-#define DMAR_VCMD_REG		0xe10 /* Virtual command register */
-#define DMAR_VCRSP_REG		0xe20 /* Virtual command response register */
+#define DMAR_VCCAP_REG		0xe30 /* Virtual command capability register */
+#define DMAR_VCMD_REG		0xe00 /* Virtual command register */
+#define DMAR_VCRSP_REG		0xe10 /* Virtual command response register */
 
 #define OFFSET_STRIDE		(9)
 
-- 
2.30.2



