Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5B12C253A
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 13:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733262AbgKXMDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 07:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733259AbgKXMDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 07:03:51 -0500
X-Greylist: delayed 388 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 Nov 2020 04:03:51 PST
Received: from mblankhorst.nl (mblankhorst.nl [IPv6:2a02:2308::216:3eff:fe92:dfa3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8C0C0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 04:03:51 -0800 (PST)
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        stable@vger.kernel.org,
        Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Subject: [PATCH] dma-buf/dma-resv: Respect num_fences when initializing the shared fence list.
Date:   Tue, 24 Nov 2020 12:57:07 +0100
Message-Id: <20201124115707.406917-1-maarten.lankhorst@linux.intel.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We hardcode the maximum number of shared fences to 4, instead of
respecting num_fences. Use a minimum of 4, but more if num_fences
is higher.

This seems to have been an oversight when first implementing the
api.

Fixes: 04a5faa8cbe5 ("reservation: update api and add some helpers")
Cc: <stable@vger.kernel.org> # v3.17+
Reported-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 drivers/dma-buf/dma-resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index bb5a42b10c29..6ddbeb5dfbf6 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -200,7 +200,7 @@ int dma_resv_reserve_shared(struct dma_resv *obj, unsigned int num_fences)
 			max = max(old->shared_count + num_fences,
 				  old->shared_max * 2);
 	} else {
-		max = 4;
+		max = max(4ul, roundup_pow_of_two(num_fences));
 	}
 
 	new = dma_resv_list_alloc(max);

base-commit: d08ea807a6466f311fe921872bc18cfc384ae281
prerequisite-patch-id: 67ededd6181f1f0d00b98376bcacefb776ebfd1b
prerequisite-patch-id: 36ea30085b8b6095303642e82a6d9c2373d331c2
prerequisite-patch-id: 453c3fe559333daea47bc5d24171b32ae8483c2d
prerequisite-patch-id: 3792e6478845da3a19dda5fdca5d094d3847c6e3
prerequisite-patch-id: 7d4e280d1197ead2e3f90d10d0c38c4685bedd86
prerequisite-patch-id: 6db8468aba0d92cd5d67af028caebe4146b9f02e
prerequisite-patch-id: 6550921ad75aaa9ddd30db6a75878d06c13ab6bb
prerequisite-patch-id: 35cfae6d6d6c30453026284fc2b25733f005f950
prerequisite-patch-id: 3bf03aa3ed1532d6c67fa47cec3ba34418ea5a79
prerequisite-patch-id: 580e28da7a0e724c293eb5b36a35be0964554885
prerequisite-patch-id: 61932497d71dc764e040deea7a58286dca51a6e0
prerequisite-patch-id: b3f6ac925fd9f3517e63b0595ce138fdd0196db2
prerequisite-patch-id: 609d83e906e26c4d9c0fb5ba29f66eec0234d11b
prerequisite-patch-id: 88264df437b404b00bba07edb7761762c52daa9d
prerequisite-patch-id: 2d3d4efeb0e32423938d546a683513ee8077143e
prerequisite-patch-id: 675d46b64f98322e8ab90b947598d030f1133120
prerequisite-patch-id: fbd3c4bf0ea604f9ab30aa21f28fb26b953f8889
prerequisite-patch-id: d51e789c6ddc37cb65b6e49aaf567ba2a6168841
prerequisite-patch-id: 1e05b33595d37f01087a82f11344b0e3cca2580a
prerequisite-patch-id: 64151f1e9a5ae900c09322ef2bade0e1dad06568
prerequisite-patch-id: af71a3e75f28e0ee92721491b27f260500567d92
prerequisite-patch-id: 30c6b42d4bd39703a865ee9ebce41d986a803ce4
prerequisite-patch-id: 15a26c36a233ee3f738faa4a666b4f9c8749494d
prerequisite-patch-id: 9733d60910fb3e14ba5caa2eecc97a8c50592d7d
prerequisite-patch-id: b7b484c19e966041b39b7e3f089e9fb407c0b641
prerequisite-patch-id: dd2adee5d7c941363193ad4033f419ca8f535b69
prerequisite-patch-id: 89142874b57f3120e4dcdefd7e40168766fc7f52
prerequisite-patch-id: df6983cc3366963afb6e4229cddd5b1a42406e3c
prerequisite-patch-id: 7d90d37f7e7545c5710ebdbd3db9967c1d1b5b4d
prerequisite-patch-id: 07041f82bdb5a5f886dd13a0a6a27b66d06d17c2
prerequisite-patch-id: 6086254edae9372a2a2a79521a9713c8d30e695c
prerequisite-patch-id: 6ad40b13b98391ed21da873bdf88c04f23ecb6fb
prerequisite-patch-id: 9fbbbc72209b81bc26573427ec70246eb2d04af1
prerequisite-patch-id: 5cc8743cf655d791faca7934683dd0d758151321
prerequisite-patch-id: 5bd8d06716d6cbae7a9fd904ff8713f3a5d0c8a0
prerequisite-patch-id: 2271226e9ac9ab8d8d93c7c3b2384c3c7bd84b87
prerequisite-patch-id: 19497288dc06ceb627a6eab0c75754a945eb1d71
prerequisite-patch-id: 85867a867694055295ce127a7ce1e9818d76801f
prerequisite-patch-id: 1b1d6aa8f4b96f82548917135d7747ed6e250fc7
prerequisite-patch-id: 39838eac42ec51ce7fb0951d4da3c64c801d71cf
prerequisite-patch-id: 846be3c76fbbca1890b3874e1fdb2af846d8f3e2
prerequisite-patch-id: 35af5ef849b3b4e207d9d9385580768c75c0827b
prerequisite-patch-id: b6aa080addba2ac4c851f41a01b72004e14fe7ca
prerequisite-patch-id: c4ba87ce6d1e48bddafb896f3c3d1fe514bf3b5c
prerequisite-patch-id: f8e4fec905fb4d6e000df3f17717f7b47d22ae27
prerequisite-patch-id: 8c0f82cdfb3c0995cdff96f9c6fc2971faf60a1e
prerequisite-patch-id: b89d16d373447225b2821d784b21331fb62e7a7c
prerequisite-patch-id: 1486fef342202199cb746fcf1601621ef07a02c4
prerequisite-patch-id: efad6151fb2cedb2cbe18d3873aa8a9b1ec4ee4f
prerequisite-patch-id: 7993a9682b498599a2fca2b7bc9c871c4bc3a374
prerequisite-patch-id: a4c31ca38e3009e9e0f15ec5531f0fa09d4929b8
prerequisite-patch-id: 3e3b4dccd7abc5c1de05d70aa397221d0a6e9c91
prerequisite-patch-id: 421ba703353af51b801fa948d862e6102b52ea9f
prerequisite-patch-id: c2ad0f1f0b00408b0068c2f8b235910fe19ce430
prerequisite-patch-id: 13a554c8d1b77415d2bf11ff260a8f932902f11c
prerequisite-patch-id: b00e4016272f55195941fedf49de1cb8f0b68dc4
prerequisite-patch-id: f89b24990377441eaf3f45d9b822ff699874af59
prerequisite-patch-id: 97d90df0f9d0499e5d3b4fd5ce37f3bb964c2370
prerequisite-patch-id: 45989d03b7508141fff2b99bee1ed9296841c3dd
prerequisite-patch-id: 77549a6ae8ce281254b876b05727983bb9b7560a
prerequisite-patch-id: 2ceee10179ceeef045bd54f0d0afa57b3e45a18a
prerequisite-patch-id: 28d94479e5cb8294668a6e8f26c1f3abc548fc11
prerequisite-patch-id: c25cb8c4efc803a3103098a043cce9d3db362050
-- 
2.29.2.222.g5d2a92d10f8

