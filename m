Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C90531915
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiEWRaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241697AbiEWR1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A7875208;
        Mon, 23 May 2022 10:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F982CE16D6;
        Mon, 23 May 2022 17:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46315C385A9;
        Mon, 23 May 2022 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326500;
        bh=dDgockUMxqkKVjLARpU37Xk0WcVS855EiS8jPh0QiFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mle3TGWzZlGB03XXrgVTRpISCe1k2deoaUFrzB55W8/8/lRU8kLzW3gCDC1c+Zrsu
         RZMUvf+YzcXwI+9izb5+VXVU0WGuOs4QGMXwYNCund2Ugy1/w162109/UNwxPfrFK2
         M3BEe16MAoBySPjl3WzE1gl1VNUWY0+M0SUqpiuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Mitchell <kevmitch@arista.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.15 100/132] igb: skip phy status check where unavailable
Date:   Mon, 23 May 2022 19:05:09 +0200
Message-Id: <20220523165840.005997703@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Mitchell <kevmitch@arista.com>

[ Upstream commit 942d2ad5d2e0df758a645ddfadffde2795322728 ]

igb_read_phy_reg() will silently return, leaving phy_data untouched, if
hw->ops.read_reg isn't set. Depending on the uninitialized value of
phy_data, this led to the phy status check either succeeding immediately
or looping continuously for 2 seconds before emitting a noisy err-level
timeout. This message went out to the console even though there was no
actual problem.

Instead, first check if there is read_reg function pointer. If not,
proceed without trying to check the phy status register.

Fixes: b72f3f72005d ("igb: When GbE link up, wait for Remote receiver status condition")
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index bf8ef81f6c0e..b88303351484 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5505,7 +5505,8 @@ static void igb_watchdog_task(struct work_struct *work)
 				break;
 			}
 
-			if (adapter->link_speed != SPEED_1000)
+			if (adapter->link_speed != SPEED_1000 ||
+			    !hw->phy.ops.read_reg)
 				goto no_wait;
 
 			/* wait for Remote receiver status OK */
-- 
2.35.1



