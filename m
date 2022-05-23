Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22FD53182D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240457AbiEWRcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241199AbiEWR3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:29:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B399637A3C;
        Mon, 23 May 2022 10:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BCF6B81202;
        Mon, 23 May 2022 17:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D22C385AA;
        Mon, 23 May 2022 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326050;
        bh=qDJjtdALSoGFooNTbyOXOdJWitemf+HcwCFb8+BpK0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYibViR2ZH4cW3y5mNwdnxHO+82SAt5sreKWpWQasMXziqPOz4fayve7XNFfUvjCy
         j6d2KcbgIyPeM3U1VdTHgYDPa4DDNLSidTns3mCTF8uHcdyLiPBmFlpCT+RieI+UCR
         IRiZ+yRluBirnnAo2IL2a7Kfxg7Bw6qc/8iK4uYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.10 06/97] igc: Remove phy->type checking
Date:   Mon, 23 May 2022 19:05:10 +0200
Message-Id: <20220523165813.343279701@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
References: <20220523165812.244140613@linuxfoundation.org>
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

From: Sasha Neftin <sasha.neftin@intel.com>

commit 47bca7de6a4fb8dcb564c7ca14d885c91ed19e03 upstream.

i225 devices have only one phy->type: copper. There is no point checking
phy->type during the igc_has_link method from the watchdog that
invoked every 2 seconds.
This patch comes to clean up these pointless checkings.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4177,17 +4177,10 @@ bool igc_has_link(struct igc_adapter *ad
 	 * false until the igc_check_for_link establishes link
 	 * for copper adapters ONLY
 	 */
-	switch (hw->phy.media_type) {
-	case igc_media_type_copper:
-		if (!hw->mac.get_link_status)
-			return true;
-		hw->mac.ops.check_for_link(hw);
-		link_active = !hw->mac.get_link_status;
-		break;
-	default:
-	case igc_media_type_unknown:
-		break;
-	}
+	if (!hw->mac.get_link_status)
+		return true;
+	hw->mac.ops.check_for_link(hw);
+	link_active = !hw->mac.get_link_status;
 
 	if (hw->mac.type == igc_i225) {
 		if (!netif_carrier_ok(adapter->netdev)) {


