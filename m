Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DA7594CA1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbiHPAmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbiHPAkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:40:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B54D18E59D;
        Mon, 15 Aug 2022 13:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C029561227;
        Mon, 15 Aug 2022 20:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9072C433C1;
        Mon, 15 Aug 2022 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595945;
        bh=wxMfdwVZvjP6alCHyjMscEaeC6bSmN+uCUqkEQ9aJz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pP7SVzc/ZAN0Id1PuMUVufjRg1HBiLNY4RGA149BvJB7G9Z9Ap3ylDUCNRtDRrhvr
         /ZJyB+snn/kiWVGyqLW4uj1EP+uDN0zQb+MVZBR4rkYRRAf1s31QO85v0p2EHzndrX
         0YVBbaT4fJSAkwSZgykx+9KsaKh5tmVDuqJK0Gq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0924/1157] net/ice: fix initializing the bitmap in the switch code
Date:   Mon, 15 Aug 2022 20:04:40 +0200
Message-Id: <20220815180516.418041560@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit 2f7ee2a72ccec8b85a05c4644d7ec9f40c1c50c8 ]

Kbuild spotted the following bug during the testing of one of
the optimizations:

In file included from include/linux/cpumask.h:12,
[...]
                from drivers/net/ethernet/intel/ice/ice_switch.c:4:
drivers/net/ethernet/intel/ice/ice_switch.c: In function 'ice_find_free_recp_res_idx.constprop':
include/linux/bitmap.h:447:22: warning: 'possible_idx[0]' is used uninitialized [-Wuninitialized]
  447 |                 *map |= GENMASK(start + nbits - 1, start);
      |                      ^~
In file included from drivers/net/ethernet/intel/ice/ice.h:7,
                 from drivers/net/ethernet/intel/ice/ice_lib.h:7,
                 from drivers/net/ethernet/intel/ice/ice_switch.c:4:
drivers/net/ethernet/intel/ice/ice_switch.c:4929:24: note: 'possible_idx[0]' was declared here
 4929 |         DECLARE_BITMAP(possible_idx, ICE_MAX_FV_WORDS);
      |                        ^~~~~~~~~~~~
include/linux/types.h:11:23: note: in definition of macro 'DECLARE_BITMAP'
   11 |         unsigned long name[BITS_TO_LONGS(bits)]
      |                       ^~~~

%ICE_MAX_FV_WORDS is 48, so bitmap_set() here was initializing only
48 bits, leaving a junk in the rest 16.
It was previously hidden due to that filling 48 bits makes
bitmap_set() call external __bitmap_set(), but after making it use
plain bit arithmetics on small bitmaps, compilers started seeing
the issue. It was still working because those 16 weren't used
anywhere anyhow.
bitmap_{clear,set}() are not really intended to initialize bitmaps,
rather to modify already initialized ones, as they don't do anything
past the passed number of bits. The correct function to do this in
that particular case is bitmap_fill(), so use it here. It will do
`*possible_idx = ~0UL` instead of `*possible_idx |= GENMASK(47, 0)`,
not leaving anything in an undefined state.

Fixes: fd2a6b71e300 ("ice: create advanced switch recipe")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 8d8f3eec79ee..9b2872e89151 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4934,7 +4934,7 @@ ice_find_free_recp_res_idx(struct ice_hw *hw, const unsigned long *profiles,
 	bitmap_zero(recipes, ICE_MAX_NUM_RECIPES);
 	bitmap_zero(used_idx, ICE_MAX_FV_WORDS);
 
-	bitmap_set(possible_idx, 0, ICE_MAX_FV_WORDS);
+	bitmap_fill(possible_idx, ICE_MAX_FV_WORDS);
 
 	/* For each profile we are going to associate the recipe with, add the
 	 * recipes that are associated with that profile. This will give us
-- 
2.35.1



