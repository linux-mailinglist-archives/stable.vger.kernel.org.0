Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B756ECDBA
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjDXN0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjDXN0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:26:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C745FF4
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4306622B7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8D4C433D2;
        Mon, 24 Apr 2023 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342767;
        bh=7KbfGjzNmIWFk+zUV9wIBx5xikRJeYuYoog1CMAXKsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0u/cRP96rumvyWh+NUkWvTDKrt4fa5ZbbXtdplvxhS2M5LDZkUYxHl73bzeONdq8
         bVmWBmdBxlY1fVllwoUrRS2/i6JSurzw0EaRuw66bSemPW5EpQjqyL0ztodgDxG5wz
         uZie3hR2dngIFk9KvqoIGrNDkPGFU7JTZsM6BA0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.1 20/98] i40e: fix accessing vsi->active_filters without holding lock
Date:   Mon, 24 Apr 2023 15:16:43 +0200
Message-Id: <20230424131134.687832973@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit 8485d093b076e59baff424552e8aecfc5bd2d261 ]

Fix accessing vsi->active_filters without holding the mac_filter_hash_lock.
Move vsi->active_filters = 0 inside critical section and
move clear_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state) after the critical
section to ensure the new filters from other threads can be added only after
filters cleaning in the critical section is finished.

Fixes: 278e7d0b9d68 ("i40e: store MAC/VLAN filters in a hash with the MAC Address as key")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index da0cf87d3a1ca..a3119a180a346 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14098,15 +14098,15 @@ static int i40e_add_vsi(struct i40e_vsi *vsi)
 		vsi->id = ctxt.vsi_number;
 	}
 
-	vsi->active_filters = 0;
-	clear_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state);
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
+	vsi->active_filters = 0;
 	/* If macvlan filters already exist, force them to get loaded */
 	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
 		f->state = I40E_FILTER_NEW;
 		f_count++;
 	}
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+	clear_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state);
 
 	if (f_count) {
 		vsi->flags |= I40E_VSI_FLAG_FILTER_CHANGED;
-- 
2.39.2



