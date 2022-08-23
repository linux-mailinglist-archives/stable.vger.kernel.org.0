Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E945059E0F8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358671AbiHWL46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359039AbiHWL4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:56:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A78F67CB9;
        Tue, 23 Aug 2022 02:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5315761335;
        Tue, 23 Aug 2022 09:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5208FC433C1;
        Tue, 23 Aug 2022 09:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247176;
        bh=BLG1m5ZxveTg+8OAMSqltELUdyCKw/WsOmvoPuaHGb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYXM44HUBZC2PVAD+7geJRGE7UzX1/GwK9oVRPOAnYUedpJ929qVhjZ7n8UG8cpGz
         OPo2Xl1TVCkvFg9IDguErVrvUM/bhD7ZtgyokUHg7Ng3N7BW2aDmz5cBnqOjO1bTeY
         99pgZxV4ZWPofQ4VpvJkD4r4oCm87huEvR2FhAz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Brady <alan.brady@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.4 343/389] i40e: Fix to stop tx_timeout recovery if GLOBR fails
Date:   Tue, 23 Aug 2022 10:27:01 +0200
Message-Id: <20220823080129.863587808@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Brady <alan.brady@intel.com>

commit 57c942bc3bef0970f0b21f8e0998e76a900ea80d upstream.

When a tx_timeout fires, the PF attempts to recover by incrementally
resetting.  First we try a PFR, then CORER and finally a GLOBR.  If the
GLOBR fails, then we keep hitting the tx_timeout and incrementing the
recovery level and issuing dmesgs, which is both annoying to the user
and accomplishes nothing.

If the GLOBR fails, then we're pretty much totally hosed, and there's
not much else we can do to recover, so this makes it such that we just
kill the VSI and stop hitting the tx_timeout in such a case.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -409,7 +409,9 @@ static void i40e_tx_timeout(struct net_d
 		set_bit(__I40E_GLOBAL_RESET_REQUESTED, pf->state);
 		break;
 	default:
-		netdev_err(netdev, "tx_timeout recovery unsuccessful\n");
+		netdev_err(netdev, "tx_timeout recovery unsuccessful, device is in non-recoverable state.\n");
+		set_bit(__I40E_DOWN_REQUESTED, pf->state);
+		set_bit(__I40E_VSI_DOWN_REQUESTED, vsi->state);
 		break;
 	}
 


