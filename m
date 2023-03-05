Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD096AB01D
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjCENxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCENxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:53:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814CB16AE7;
        Sun,  5 Mar 2023 05:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B3B260B04;
        Sun,  5 Mar 2023 13:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016A3C433D2;
        Sun,  5 Mar 2023 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024352;
        bh=SIweHOSwLFh5mHa7adC3YqQ38yalzSuKcdxd8dSPmss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNl4igqD4DIStFs/ybQiQ+XF8t9GYl97Krya2q/1lQIQupSjZjb1TIHYzWdalFLh6
         wIYNWbkMhvLchq4J2PGpwN9jhCFxORgjb/zHjvVWdfQurvzRgX5viVNsj2NuOjbjJu
         FsDniBIcHBtFuFXe3nkWIz5lOrjrsQWuYx5izmRG/1AAEWu+7jTXdDzxEtICFL/1O/
         mB+8DQWlPQNybu1LnaOOgcImCswNDai7gxyoJQX8d2uiW44QlkuGRYbz8gwyhC1dIz
         NUKyUXgnyPinE4UMBUCpgfPFECtCsSOpvwFHTN/11ySNrSbWF4ta3CIDsP20Xns4f5
         av7vAp0kHbfsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aik@ozlabs.ru,
        christophe.leroy@csgroup.eu, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.2 06/16] powerpc/iommu: fix memory leak with using debugfs_lookup()
Date:   Sun,  5 Mar 2023 08:51:57 -0500
Message-Id: <20230305135207.1793266-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135207.1793266-1-sashal@kernel.org>
References: <20230305135207.1793266-1-sashal@kernel.org>
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
index caebe1431596e..ee95937bdaf14 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -67,11 +67,9 @@ static void iommu_debugfs_add(struct iommu_table *tbl)
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

