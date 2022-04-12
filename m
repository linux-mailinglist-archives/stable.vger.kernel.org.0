Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CEA4FD98A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244618AbiDLIAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357680AbiDLHkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA2A37A86;
        Tue, 12 Apr 2022 00:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E57D061045;
        Tue, 12 Apr 2022 07:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C82C385A1;
        Tue, 12 Apr 2022 07:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747797;
        bh=9jNENUbCs6cw5+MzCQnWH+zyHEXcOMOtfAZicP9f8m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zbg1pcBcKPWuHbdWWpa84TY5oSoq0F6DCk3AXeHAXkie11uCa92DkYlAeslU+RiSP
         AotNtaf8KRt13v8Cgx6Tps6Lo3I+41YuIInwJjraLWMXdjXTHUFavYyS9jhjq0if8c
         5DC67Q9Jw0M1mf1EAUWqjmbgU29H0sVkIwq0NyYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alice Michael <alice.michael@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 210/343] ice: Fix MAC address setting
Date:   Tue, 12 Apr 2022 08:30:28 +0200
Message-Id: <20220412062957.409137034@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 2c0069f3f91f125b1b2ce66cc6bea8eb134723c3 ]

Commit 2ccc1c1ccc671b ("ice: Remove excess error variables") merged
the usage of 'status' and 'err' variables into single one in
function ice_set_mac_address(). Unfortunately this causes
a regression when call of ice_fltr_add_mac() returns -EEXIST because
this return value does not indicate an error in this case but
value of 'err' remains to be -EEXIST till the end of the function
and is returned to caller.

Prior mentioned commit this does not happen because return value of
ice_fltr_add_mac() was stored to 'status' variable first and
if it was -EEXIST then 'err' remains to be zero.

Fix the problem by reset 'err' to zero when ice_fltr_add_mac()
returns -EEXIST.

Fixes: 2ccc1c1ccc671b ("ice: Remove excess error variables")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 296f9d5f7408..92e0fe9316b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5432,16 +5432,19 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 
 	/* Add filter for new MAC. If filter exists, return success */
 	err = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
-	if (err == -EEXIST)
+	if (err == -EEXIST) {
 		/* Although this MAC filter is already present in hardware it's
 		 * possible in some cases (e.g. bonding) that dev_addr was
 		 * modified outside of the driver and needs to be restored back
 		 * to this value.
 		 */
 		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
-	else if (err)
+
+		return 0;
+	} else if (err) {
 		/* error if the new filter addition failed */
 		err = -EADDRNOTAVAIL;
+	}
 
 err_update_filters:
 	if (err) {
-- 
2.35.1



