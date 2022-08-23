Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7203159D57C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347526AbiHWJCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347260AbiHWJBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:01:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B393865D5;
        Tue, 23 Aug 2022 01:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91242B81C50;
        Tue, 23 Aug 2022 08:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DA8C433D6;
        Tue, 23 Aug 2022 08:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243264;
        bh=eva9J/HnGNK4Hs9Yy6N/uH0vPgm9Li4iFFPXZNd2K3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxkypWfcISAjEuJ8j+HQmQ515vKXvdwTCuMThdRs/jON7hIo7cH7J8hqAdE+Opd6S
         Eq9kCB6MUmy3abWgPywD37kvDadrYVTAgRlHpY3lSKAC9Q/pB5RmmttQNUQogHiSF6
         WYFl0jaioAr/l+FHpCaxiTSpb31V1J6nWzjQgyIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Mikailenko <benjamin.mikailenko@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.19 221/365] ice: Fix VSI rebuild WARN_ON check for VF
Date:   Tue, 23 Aug 2022 10:02:02 +0200
Message-Id: <20220823080127.431744065@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Benjamin Mikailenko <benjamin.mikailenko@intel.com>

commit 7fe05e125d5f730bd2d0fc53985bee77b6c762f0 upstream.

In commit b03d519d3460 ("ice: store VF pointer instead of VF ID")
WARN_ON checks were added to validate the vsi->vf pointer and
catch programming errors. However, one check to vsi->vf was missed.
This caused a call trace when resetting VFs.

Fix ice_vsi_rebuild by encompassing VF pointer in WARN_ON check.

Fixes: b03d519d3460 ("ice: store VF pointer instead of VF ID")
Signed-off-by: Benjamin Mikailenko <benjamin.mikailenko@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3178,7 +3178,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi,
 
 	pf = vsi->back;
 	vtype = vsi->type;
-	if (WARN_ON(vtype == ICE_VSI_VF) && !vsi->vf)
+	if (WARN_ON(vtype == ICE_VSI_VF && !vsi->vf))
 		return -EINVAL;
 
 	ice_vsi_init_vlan_ops(vsi);


