Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E684BDDA3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351567AbiBUJts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352960AbiBUJsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81632E4;
        Mon, 21 Feb 2022 01:22:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2C484CE0E80;
        Mon, 21 Feb 2022 09:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EBDC340E9;
        Mon, 21 Feb 2022 09:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435317;
        bh=w9TKH42L6B9iXXuJURWlxaWPGp24Nh54zZwHeSNNMm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWTKWtAf5g62SNW0X6TNkKAQVblE78yWkbdgVSUr5hXZ48jLqaZE/VDQqBKrSR6cz
         HXXSRVRIwOR8nUyLSt4ODbsYD2jU/C07uWDV1B3IUeLHwu96FoIkyNoWyn9wDgQ5Xv
         3U2cVNUDfu/Sqh9KA9vwOGU04MdbYK7qg3wrxPjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danie du Toit <danie.dutoit@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 122/227] nfp: flower: netdev offload check for ip6gretap
Date:   Mon, 21 Feb 2022 09:49:01 +0100
Message-Id: <20220221084938.910019696@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Danie du Toit <danie.dutoit@corigine.com>

commit 7dbcda584eaa5bdb4a281c379207dacc1a5e6081 upstream.

IPv6 GRE tunnels are not being offloaded, this is caused by a missing
netdev offload check. The functionality of IPv6 GRE tunnel offloading
was previously added but this check was not included. Adding the
ip6gretap check allows IPv6 GRE tunnels to be offloaded correctly.

Fixes: f7536ffb0986 ("nfp: flower: Allow ipv6gretap interface for offloading")
Signed-off-by: Danie du Toit <danie.dutoit@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20220217124820.40436-1-louis.peens@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 784292b16290..1543e47456d5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -723,6 +723,8 @@ static inline bool nfp_fl_is_netdev_to_offload(struct net_device *netdev)
 		return true;
 	if (netif_is_gretap(netdev))
 		return true;
+	if (netif_is_ip6gretap(netdev))
+		return true;
 
 	return false;
 }
-- 
2.35.1



