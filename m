Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7C1594626
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbiHOW2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351129AbiHOW1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90ED6E2D1;
        Mon, 15 Aug 2022 12:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB79061233;
        Mon, 15 Aug 2022 19:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC73C433C1;
        Mon, 15 Aug 2022 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592845;
        bh=TxIdxAULtQl4TEOplGI6YrvA/gSOQygjmNf5HVhevT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8DPly8/UaNRpbW4/P6EkPDGT06uSfcoC5c1U/IXid4O0ZDMKfad12gCKYat7hnz3
         SBqkVMDDkP5yWAF4os3FsPwp/z7pkU0vcxBgU6YPz9z/Az5I1tmz/hCW2xge62VYq4
         pK9kDRP6ByHccKPypweo9fne2NJ7CkDDXXy/tsIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0853/1095] net/ice: fix initializing the bitmap in the switch code
Date:   Mon, 15 Aug 2022 20:04:12 +0200
Message-Id: <20220815180504.612499136@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 25b8f6f726eb..73960c8f9dba 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4874,7 +4874,7 @@ ice_find_free_recp_res_idx(struct ice_hw *hw, const unsigned long *profiles,
 	bitmap_zero(recipes, ICE_MAX_NUM_RECIPES);
 	bitmap_zero(used_idx, ICE_MAX_FV_WORDS);
 
-	bitmap_set(possible_idx, 0, ICE_MAX_FV_WORDS);
+	bitmap_fill(possible_idx, ICE_MAX_FV_WORDS);
 
 	/* For each profile we are going to associate the recipe with, add the
 	 * recipes that are associated with that profile. This will give us
-- 
2.35.1



