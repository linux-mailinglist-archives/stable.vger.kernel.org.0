Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB03550F6F1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345825AbiDZJCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346666AbiDZJBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:01:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B2440901;
        Tue, 26 Apr 2022 01:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B413B81CED;
        Tue, 26 Apr 2022 08:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0335C385A4;
        Tue, 26 Apr 2022 08:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962600;
        bh=vODgJ8/N38n2QubethSt6gI2SLcVIqnaSD0Dgq0Gjfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6vz74UXmwqhC1whxyDdyd+8PTlSm1wZw4weywrXzh/EixhCcgO1MvtYCu1KGQ4GY
         fR9P1JCiOSQewtnj/8XL/bLZlwi3OA809dNYgGonfxLRFgAEUbr0YqGeKbcJ1c1bve
         AzreD7b2SrvFzdETS2O2aJP+BR4bQDz3fMn18Guc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Nitka <grzegorz.nitka@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 027/146] ice: allow creating VFs for !CONFIG_NET_SWITCHDEV
Date:   Tue, 26 Apr 2022 10:20:22 +0200
Message-Id: <20220426081750.831045448@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit aacca7a83b9753c562395ef328352dfd8c003c59 ]

Currently for !CONFIG_NET_SWITCHDEV kernel builds it is not possible to
create VFs properly as call to ice_eswitch_configure() returns
-EOPNOTSUPP for us. This is because CONFIG_ICE_SWITCHDEV depends on
CONFIG_NET_SWITCHDEV.

Change the ice_eswitch_configure() implementation for
!CONFIG_ICE_SWITCHDEV to return 0 instead -EOPNOTSUPP and let
ice_ena_vfs() finish its work properly.

CC: Grzegorz Nitka <grzegorz.nitka@intel.com>
Fixes: 1a1c40df2e80 ("ice: set and release switchdev environment")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.h b/drivers/net/ethernet/intel/ice/ice_eswitch.h
index bd58d9d2e565..6a413331572b 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.h
@@ -52,7 +52,7 @@ static inline void ice_eswitch_update_repr(struct ice_vsi *vsi) { }
 
 static inline int ice_eswitch_configure(struct ice_pf *pf)
 {
-	return -EOPNOTSUPP;
+	return 0;
 }
 
 static inline int ice_eswitch_rebuild(struct ice_pf *pf)
-- 
2.35.1



