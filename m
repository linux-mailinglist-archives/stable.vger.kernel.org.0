Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2B3330E7E
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhCHMh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhCHMgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F09B665204;
        Mon,  8 Mar 2021 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615207014;
        bh=Wv4/03X15HlKNLENnxna3Z3qt0gJ5QsD6agr04+iws4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUtHPLBbU4PrQ8ZyyI7N3pc3HvD0JQhU+LxxiXIm8x9OisjLSW+EPovhbvoKS+YNy
         TjM+7eiiroZwomnYRPiY4BiNRGSt1hx9gJvDdAgZc+TdLBbq4NGri5j4P52VbeAy7U
         T24svc+ZK3AI02yOpY62B1r0ksy4hdlprhwvDdlw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 41/44] iommu/vt-d: Fix status code for Allocate/Free PASID command
Date:   Mon,  8 Mar 2021 13:35:19 +0100
Message-Id: <20210308122720.557865666@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit 444d66a23c1f1e4c4d12aed4812681d0ad835d60 ]

As per Intel vt-d spec, Rev 3.0 (section 10.4.45 "Virtual Command Response
Register"), the status code of "No PASID available" error in response to
the Allocate PASID command is 2, not 1. The same for "Invalid PASID" error
in response to the Free PASID command.

We will otherwise see confusing kernel log under the command failure from
guest side. Fix it.

Fixes: 24f27d32ab6b ("iommu/vt-d: Enlightened PASID allocation")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210227073909.432-1-yuzenghui@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 97dfcffbf495..444c0bec221a 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -30,8 +30,8 @@
 #define VCMD_VRSP_IP			0x1
 #define VCMD_VRSP_SC(e)			(((e) >> 1) & 0x3)
 #define VCMD_VRSP_SC_SUCCESS		0
-#define VCMD_VRSP_SC_NO_PASID_AVAIL	1
-#define VCMD_VRSP_SC_INVALID_PASID	1
+#define VCMD_VRSP_SC_NO_PASID_AVAIL	2
+#define VCMD_VRSP_SC_INVALID_PASID	2
 #define VCMD_VRSP_RESULT_PASID(e)	(((e) >> 8) & 0xfffff)
 #define VCMD_CMD_OPERAND(e)		((e) << 8)
 /*
-- 
2.30.1



