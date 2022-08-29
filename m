Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768115A49D6
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiH2LaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiH2L3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D86173923;
        Mon, 29 Aug 2022 04:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66493B80F98;
        Mon, 29 Aug 2022 11:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE5CC433D6;
        Mon, 29 Aug 2022 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771848;
        bh=9k3Ex5qoa8TFnbbDZOJm1dqnsTP5F6Ia2Cp29JH5/mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8oLrNoJsKVv31BmPlDqqcBTLvOVZY6jK69PQyTbFc+Jv3czY7iHxWNpDS8uSjIWL
         ctWMqdVNdTqHEfntzd2CmvycIj5jgGEP+drO6c4gMs9ms0XeS1NRhcVrX6F4M8HvWQ
         G0HPyGzHMGvmOWZ6bf6AvZ6R+ONHTeUcknaC+vJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.19 083/158] i40e: Fix incorrect address type for IPv6 flow rules
Date:   Mon, 29 Aug 2022 12:58:53 +0200
Message-Id: <20220829105812.527847841@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

[ Upstream commit bcf3a156429306070afbfda5544f2b492d25e75b ]

It was not possible to create 1-tuple flow director
rule for IPv6 flow type. It was caused by incorrectly
checking for source IP address when validating user provided
destination IP address.

Fix this by changing ip6src to correct ip6dst address
in destination IP address validation for IPv6 flow type.

Fixes: efca91e89b67 ("i40e: Add flow director support for IPv6")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 19704f5c8291c..22a61802a4027 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4395,7 +4395,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 				    (struct in6_addr *)&ipv6_full_mask))
 			new_mask |= I40E_L3_V6_DST_MASK;
 		else if (ipv6_addr_any((struct in6_addr *)
-				       &usr_ip6_spec->ip6src))
+				       &usr_ip6_spec->ip6dst))
 			new_mask &= ~I40E_L3_V6_DST_MASK;
 		else
 			return -EOPNOTSUPP;
-- 
2.35.1



