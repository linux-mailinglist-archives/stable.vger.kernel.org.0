Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1A959DD49
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356074AbiHWKxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357013AbiHWKww (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:52:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB86ABF1E;
        Tue, 23 Aug 2022 02:13:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1BC66113E;
        Tue, 23 Aug 2022 09:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EF7C433C1;
        Tue, 23 Aug 2022 09:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245982;
        bh=8hgEPptPotcAEFQiDmgZ8x/yHxxyNyJ3aCUqRbrzYe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytihZ/N9wF0bVs3WJBc+aY5YMp3HJbuPjLbu8/kHd4Ay9JtQO7wt7BROG5sPkGzNA
         BdH4KdU0QkMdMNXdK0IQbxdOANHwP8LYYpYF2p7Y249M7Qkz3d7R7GtBWKRv4eeKmY
         RJyZsvagqdJfOVvAVs5EbYGG3cELFFRtuYmyHMzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Brady <alan.brady@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 4.19 252/287] i40e: Fix to stop tx_timeout recovery if GLOBR fails
Date:   Tue, 23 Aug 2022 10:27:01 +0200
Message-Id: <20220823080109.695712144@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
@@ -397,7 +397,9 @@ static void i40e_tx_timeout(struct net_d
 		set_bit(__I40E_GLOBAL_RESET_REQUESTED, pf->state);
 		break;
 	default:
-		netdev_err(netdev, "tx_timeout recovery unsuccessful\n");
+		netdev_err(netdev, "tx_timeout recovery unsuccessful, device is in non-recoverable state.\n");
+		set_bit(__I40E_DOWN_REQUESTED, pf->state);
+		set_bit(__I40E_VSI_DOWN_REQUESTED, vsi->state);
 		break;
 	}
 


