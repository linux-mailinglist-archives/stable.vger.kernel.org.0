Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8829329B98E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802602AbgJ0Pu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801358AbgJ0Pkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:40:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE4D82231B;
        Tue, 27 Oct 2020 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813253;
        bh=8dtgKogo8sCLLubRF6IHm0HSCAMlafsAbfMOo/6TtuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkx4M7UXUFq7KVWIwxR038yyTFxkF6gh1gP9dQm7cI7Wd6gcEqwuTMMzFaFxDTlAa
         d/DFcNGHzieAF78lR5mWgBfhu/udEsO3+zkQrV07/jh5cs+5UZZBY8+iXTVDOjlYbN
         dtwawZf95Kf/D+J2TvzLHNX1CEq0JhZf7pMmdgVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 490/757] powerpc/papr_scm: Add PAPR command family to pass-through command-set
Date:   Tue, 27 Oct 2020 14:52:20 +0100
Message-Id: <20201027135513.464811431@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 13135b461cf205941308984bd3271ec7d403dc40 ]

Add NVDIMM_FAMILY_PAPR to the list of valid 'dimm_family_mask'
acceptable by papr_scm. This is needed as since commit
92fe2aa859f5 ("libnvdimm: Validate command family indices") libnvdimm
performs a validation of 'nd_cmd_pkg.nd_family' received as part of
ND_CMD_CALL processing to ensure only known command families can use
the general ND_CMD_CALL pass-through functionality.

Without this change the ND_CMD_CALL pass-through targeting
NVDIMM_FAMILY_PAPR error out with -EINVAL.

Fixes: 92fe2aa859f5 ("libnvdimm: Validate command family indices")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200913211904.24472-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 5493bc847bd08..27268370dee00 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -898,6 +898,9 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
 	p->bus_desc.of_node = p->pdev->dev.of_node;
 	p->bus_desc.provider_name = kstrdup(p->pdev->name, GFP_KERNEL);
 
+	/* Set the dimm command family mask to accept PDSMs */
+	set_bit(NVDIMM_FAMILY_PAPR, &p->bus_desc.dimm_family_mask);
+
 	if (!p->bus_desc.provider_name)
 		return -ENOMEM;
 
-- 
2.25.1



