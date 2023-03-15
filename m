Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF5F6BB1EA
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjCOMbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbjCOMbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B87125A2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F5A761D69
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72235C433EF;
        Wed, 15 Mar 2023 12:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883423;
        bh=RUtrwhkGxrU/WjppTacDxsQStzEre83Pl93QLDKDXBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeW2df+dutV2sNIcxebTRzGBirBVcyFAR0Auc/Etg1ifo9Ls8013fsO736qbnlCUR
         Fc+O7czdtST3cpM9FEADSROYmB08eixOnjY9o/S7oPoLtOaliPgHO6FiqW0NBk40Ph
         zxU0LB3pK1aU8lp+vSKloYDmfz7RVAZ6CiYPuBdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/145] powerpc/iommu: fix memory leak with using debugfs_lookup()
Date:   Wed, 15 Mar 2023 13:12:54 +0100
Message-Id: <20230315115742.539337464@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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



