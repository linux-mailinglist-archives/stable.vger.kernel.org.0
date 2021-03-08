Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211B9330E0A
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhCHMew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:34:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhCHMem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EEC8651C9;
        Mon,  8 Mar 2021 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206881;
        bh=iHS1uGsJ9PogdqEJ7G0jS2z2i+YhY334y2LSP7Uj2hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZugKfn1rJpeWNelNQ9qFrP1+pUCZ9jEVD6ab9SpyblhoR4DCZAcQyCZbvOVSjUKN
         qzReDquXlDGPXFc2L2Qhbibvf/dbBf2T3bzHIMCVidb77ZWt4ln1PC4tSC2Td1+0KA
         sDn+BJBXi7dD2l7qRNIWva0qFDnj1rP027JgqpPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/42] iommu/vt-d: Fix status code for Allocate/Free PASID command
Date:   Mon,  8 Mar 2021 13:31:04 +0100
Message-Id: <20210308122719.977647609@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
 drivers/iommu/intel/pasid.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


