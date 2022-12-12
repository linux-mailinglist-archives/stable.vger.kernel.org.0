Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1764A012
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiLLNTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiLLNTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:19:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF191C8
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC95F61049
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4593C433EF;
        Mon, 12 Dec 2022 13:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851109;
        bh=jLLu+HvUGKH8JjpE5OIVNgs/SfKhiOQ1BQqCSJwcSVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhJQ9b4kXpcv3BVxXXwDsEsgB0eSsWPINgiyZoWrdAKD7T9mOSOU97WUyO4Hy77rB
         58rOgOo3gXEkyA6opqeMFZMHqDWykKErRFxCyFV8FI2Pw48SdRVhqCnNHSJgptFnQy
         qr2nXM5vMlV28s1RX7qlsFPe+olsyglQ/Y38yHe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 5.10 087/106] i40e: Disallow ip4 and ip6 l4_4_bytes
Date:   Mon, 12 Dec 2022 14:10:30 +0100
Message-Id: <20221212130928.667227407@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit d64aaf3f7869f915fd120763d75f11d6b116424d ]

Return -EOPNOTSUPP, when user requests l4_4_bytes for raw IP4 or
IP6 flow director filters. Flow director does not support filtering
on l4 bytes for PCTYPEs used by IP4 and IP6 filters.
Without this patch, user could create filters with l4_4_bytes fields,
which did not do any filtering on L4, but only on L3 fields.

Fixes: 36777d9fa24c ("i40e: check current configured input set when adding ntuple filters")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Kamil Maziarz  <kamil.maziarz@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 144c4824b5e8..520929f4d535 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4234,11 +4234,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 			return -EOPNOTSUPP;
 
 		/* First 4 bytes of L4 header */
-		if (usr_ip4_spec->l4_4_bytes == htonl(0xFFFFFFFF))
-			new_mask |= I40E_L4_SRC_MASK | I40E_L4_DST_MASK;
-		else if (!usr_ip4_spec->l4_4_bytes)
-			new_mask &= ~(I40E_L4_SRC_MASK | I40E_L4_DST_MASK);
-		else
+		if (usr_ip4_spec->l4_4_bytes)
 			return -EOPNOTSUPP;
 
 		/* Filtering on Type of Service is not supported. */
-- 
2.35.1



