Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C6E59D537
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347692AbiHWJGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348073AbiHWJFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D8284EF1;
        Tue, 23 Aug 2022 01:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 497E561490;
        Tue, 23 Aug 2022 08:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F635C433C1;
        Tue, 23 Aug 2022 08:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243276;
        bh=1c39BiNd7SQ5EjNVpwpii3C/c76JTx3O9Q0M7TYzoc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBaFj+cIXSDkWNHY/2k9Ymlg4+jyIAv65YkKRg8ByyV2EMD+PT2/CrGAjg2q8fjUz
         M4Qra9vUFkhmExxdZ2ZvvpR8ZrZv74QnJU7J4piSRxJt1Upx1t3slXzNsK0M69pGcn
         YsDHzNBMlxdmJhFnJZWRwDNxJ7AUxG1J/gCippVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Igor Raits <igor@gooddata.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.19 225/365] ice: Ignore EEXIST when setting promisc mode
Date:   Tue, 23 Aug 2022 10:02:06 +0200
Message-Id: <20220823080127.610838708@linuxfoundation.org>
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

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

commit 11e551a2efa4481bd4f616ab75374a2710b480e9 upstream.

Ignore EEXIST error when setting promiscuous mode.
This fix is needed because the driver could set promiscuous mode
when it still has not cleared properly.
Promiscuous mode could be set only once, so setting it second
time will be rejected.

Fixes: 5eda8afd6bcc ("ice: Add support for PF/VF promiscuous mode")
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Link: https://lore.kernel.org/all/CAK8fFZ7m-KR57M_rYX6xZN39K89O=LGooYkKsu6HKt0Bs+x6xQ@mail.gmail.com/
Tested-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Tested-by: Igor Raits <igor@gooddata.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4428,7 +4428,7 @@ ice_set_vlan_vsi_promisc(struct ice_hw *
 		else
 			status = ice_set_vsi_promisc(hw, vsi_handle,
 						     promisc_mask, vlan_id);
-		if (status)
+		if (status && status != -EEXIST)
 			break;
 	}
 


