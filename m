Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B4D64A1C4
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiLLNp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiLLNo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:44:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA0FCCC
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2D48B80D2C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9034EC433F0;
        Mon, 12 Dec 2022 13:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852664;
        bh=lL6YemiGUiftkkkTYrulfsEj13wC2NwS2HMH4LhlvTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHjyIE1JPlp/AbjpZdwS5gaaoXD1vQ3Yd97eDskMeiI+J+Q2Pki5EeyRzRY2qqSoj
         /1LIahP/geFkHbx4bdI9SdJ3gX0O7ko7jUN5tGrBnkprUedDe/qOWRyiWdPmuU+PD3
         KYjSnrXCHPEgxi9YrKHOu7qzonXcs1dQky+gUrqs=
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
Subject: [PATCH 6.0 127/157] i40e: Disallow ip4 and ip6 l4_4_bytes
Date:   Mon, 12 Dec 2022 14:17:55 +0100
Message-Id: <20221212130939.967662929@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 6f0d4160ff82..d9368f7669aa 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4464,11 +4464,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
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
@@ -4507,11 +4503,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 		else
 			return -EOPNOTSUPP;
 
-		if (usr_ip6_spec->l4_4_bytes == htonl(0xFFFFFFFF))
-			new_mask |= I40E_L4_SRC_MASK | I40E_L4_DST_MASK;
-		else if (!usr_ip6_spec->l4_4_bytes)
-			new_mask &= ~(I40E_L4_SRC_MASK | I40E_L4_DST_MASK);
-		else
+		if (usr_ip6_spec->l4_4_bytes)
 			return -EOPNOTSUPP;
 
 		/* Filtering on Traffic class is not supported. */
-- 
2.35.1



