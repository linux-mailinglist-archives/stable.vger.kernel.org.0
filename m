Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C0D6AB07F
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCEN4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjCEN4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:56:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1561A4A8;
        Sun,  5 Mar 2023 05:55:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7130D60AD7;
        Sun,  5 Mar 2023 13:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183CFC433EF;
        Sun,  5 Mar 2023 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024451;
        bh=RUtrwhkGxrU/WjppTacDxsQStzEre83Pl93QLDKDXBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpAJ14tlji7Cd8mPm/MITjR5QjtNxC7H1y0yo13nkYxtezlcGUTjWpXSMW+es8rsb
         Kufl4HEFrIpZQTIbqkIDMfEMxoTOTFifbYHQa3830iNG4kx7y40jBbM6vJektQ2DEE
         JY0UYwlL8AAia1Es6ENIjQgeXoNV64+EqJGu1n3498ROa8ZEIoRsXVeHVUMAe0iYqS
         Ud8XGk+47J9FTSz3gIex5DFLko0foqTVe1LSY9ontmz8sewg6Agq2z7fcUSDJJ20hN
         yRuFwQ3pVJZIs7G0vKtTJZIJxppeKvTIBItReMcwScJwnjC01tkqaIsMOXpy5yj4/J
         IPjY12BMBLXdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aik@ozlabs.ru,
        christophe.leroy@csgroup.eu, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 4/9] powerpc/iommu: fix memory leak with using debugfs_lookup()
Date:   Sun,  5 Mar 2023 08:53:54 -0500
Message-Id: <20230305135359.1793830-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135359.1793830-1-sashal@kernel.org>
References: <20230305135359.1793830-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit b505063910c134778202dfad9332dfcecb76bab3 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230202141919.2298821-1-gregkh@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/iommu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index a67fd54ccc573..8bea336fa5b70 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -68,11 +68,9 @@ static void iommu_debugfs_add(struct iommu_table *tbl)
 static void iommu_debugfs_del(struct iommu_table *tbl)
 {
 	char name[10];
-	struct dentry *liobn_entry;
 
 	sprintf(name, "%08lx", tbl->it_index);
-	liobn_entry = debugfs_lookup(name, iommu_debugfs_dir);
-	debugfs_remove(liobn_entry);
+	debugfs_lookup_and_remove(name, iommu_debugfs_dir);
 }
 #else
 static void iommu_debugfs_add(struct iommu_table *tbl){}
-- 
2.39.2

