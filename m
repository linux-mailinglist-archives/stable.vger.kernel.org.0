Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1486948E4
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjBMOyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjBMOyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB8611E97
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBEF8B81257
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA32C433D2;
        Mon, 13 Feb 2023 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300044;
        bh=Aa87QOCEVQyGu9ULvRSOCTUeB1XZjsoZhqgUtes0NCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajzkQPT2hsAX7yXLgrBT/bNxvGQ/NmSoZLeBPLNp7IOfw9xGIvkEBiHyPmclhR/P2
         +It2SPae7QeeaChQ633ovk5POQt9178Ej1fjW2jNWy0SM7NM3ysjHNbQ+ZrwL3cLQG
         grQBiKUNPsxCle9ZbOg93X3sy97q5bhPwS45A6kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/114] ice: switch: fix potential memleak in ice_add_adv_recipe()
Date:   Mon, 13 Feb 2023 15:47:57 +0100
Message-Id: <20230213144744.314696886@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 4a606ce68426c88ff2563382b33cc34f3485fe57 ]

When ice_add_special_words() fails, the 'rm' is not released, which will
lead to a memory leak. Fix this up by going to 'err_unroll' label.

Compile tested only.

Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 9b762f7972ce5..61f844d225123 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5420,7 +5420,7 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	 */
 	status = ice_add_special_words(rinfo, lkup_exts, ice_is_dvm_ena(hw));
 	if (status)
-		goto err_free_lkup_exts;
+		goto err_unroll;
 
 	/* Group match words into recipes using preferred recipe grouping
 	 * criteria.
-- 
2.39.0



