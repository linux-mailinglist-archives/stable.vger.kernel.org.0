Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C49750F8ED
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbiDZJDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346714AbiDZJBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:01:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFABF7DAAF;
        Tue, 26 Apr 2022 01:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D3FC60A56;
        Tue, 26 Apr 2022 08:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7411FC385AC;
        Tue, 26 Apr 2022 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962605;
        bh=dMzO9NbcYCk4F9iz1CCQtjpG4YJv/4z7OV6cEnqqQAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZE8chdlzUcDBA5OxvaLbVZNLJ8yaKoXSRF7Vs267gZpFDl+m37RgVvsV5+LHx6kF0
         nT3MO8L4azSoy5ao0q7CwKP9t1xVRctHMXs1wIa4YY5WPxAwIQZzmwLv440vYnv0XP
         tdpBlvOHMOeranW3WSZRe9Ymiyu1rIFiqRxmAM7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.17 029/146] ice: Fix memory leak in ice_get_orom_civd_data()
Date:   Tue, 26 Apr 2022 10:20:24 +0200
Message-Id: <20220426081750.886273697@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 7c8881b77908a51814a050da408c89f1a25b7fb7 ]

A memory chunk was allocated for orom_data in ice_get_orom_civd_data()
by vzmalloc(). But when ice_read_flash_module() fails, the allocated
memory is not freed, which will lead to a memory leak.

We can fix it by freeing the orom_data when ce_read_flash_module() fails.

Fixes: af18d8866c80 ("ice: reduce time to read Option ROM CIVD data")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 4eb0599714f4..13cdb5ea594d 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -641,6 +641,7 @@ ice_get_orom_civd_data(struct ice_hw *hw, enum ice_bank_select bank,
 	status = ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR, 0,
 				       orom_data, hw->flash.banks.orom_size);
 	if (status) {
+		vfree(orom_data);
 		ice_debug(hw, ICE_DBG_NVM, "Unable to read Option ROM data\n");
 		return status;
 	}
-- 
2.35.1



