Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC6F4CF913
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbiCGKDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbiCGJ6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:58:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231377C160;
        Mon,  7 Mar 2022 01:46:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E63EB80F9F;
        Mon,  7 Mar 2022 09:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44A4C340F5;
        Mon,  7 Mar 2022 09:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646366;
        bh=aJiMtZDEzYoL9IK8Ld/F52RoqRogDvXyrBRCMv7st+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pSOpyQ2fTqUDGzQhvx9xyZUAFELAU7JdScOUXGTMujIT1ADAMfInBlm0wyIUVRRt
         /JNnpomS+bemBpzhKQKVxxemzptiq1Pi9gLJPbGtx+znBr/io8l+5DQG/+JWgCtw51
         feh0GsNlXkuiJr2D8gCkNMyrBCTR2pmfzMQLFOOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maurice Baijens <maurice.baijens@ellips.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 180/262] ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()
Date:   Mon,  7 Mar 2022 10:18:44 +0100
Message-Id: <20220307091707.496512150@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

commit 6c7273a266759d9d36f7c862149f248bcdeddc0f upstream.

Commit c685c69fba71 ("ixgbe: don't do any AF_XDP zero-copy transmit if
netif is not OK") addressed the ring transient state when
MEM_TYPE_XSK_BUFF_POOL was being configured which in turn caused the
interface to through down/up. Maurice reported that when carrier is not
ok and xsk_pool is present on ring pair, ksoftirqd will consume 100% CPU
cycles due to the constant NAPI rescheduling as ixgbe_poll() states that
there is still some work to be done.

To fix this, do not set work_done to false for a !netif_carrier_ok().

Fixes: c685c69fba71 ("ixgbe: don't do any AF_XDP zero-copy transmit if netif is not OK")
Reported-by: Maurice Baijens <maurice.baijens@ellips.com>
Tested-by: Maurice Baijens <maurice.baijens@ellips.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -388,12 +388,14 @@ static bool ixgbe_xmit_zc(struct ixgbe_r
 	u32 cmd_type;
 
 	while (budget-- > 0) {
-		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
-		    !netif_carrier_ok(xdp_ring->netdev)) {
+		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
 			work_done = false;
 			break;
 		}
 
+		if (!netif_carrier_ok(xdp_ring->netdev))
+			break;
+
 		if (!xsk_tx_peek_desc(pool, &desc))
 			break;
 


