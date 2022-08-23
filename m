Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468B059D5EA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347756AbiHWJGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348119AbiHWJFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:05:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD819844EB;
        Tue, 23 Aug 2022 01:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30860B81C53;
        Tue, 23 Aug 2022 08:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630F8C433C1;
        Tue, 23 Aug 2022 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243294;
        bh=kBIJUnYoiF4hvWbezr8bvwVph0x8Ae5+cW9bccerPLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6VVkbPBAyigqFonlavrZ+3lM60kb/gXzg6QDkAtd7+neTC7uEEpNrDw67CmLLxLu
         mkGyxk1KWGMM4aMeGnf2im5r8gUFn/Z5Nk1nXsv8BgnQen0+sGftlXUlBRjXUFuyPJ
         2/lFP7ZuWBAQBk2qVq9yuojNoMNOKt2BSvg4Qd4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.19 230/365] i40e: Fix tunnel checksum offload with fragmented traffic
Date:   Tue, 23 Aug 2022 10:02:11 +0200
Message-Id: <20220823080127.841289110@linuxfoundation.org>
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

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

commit 2c6482091f01ba104cf8ee549aa5c717e80d43ea upstream.

Fix checksum offload on VXLAN tunnels.
In case, when mpls protocol is not used, set l4 header to transport
header of skb. This fixes case, when user tries to offload checksums
of VXLAN tunneled traffic.

Steps for reproduction (requires link partner with tunnels):
ip l s enp130s0f0 up
ip a f enp130s0f0
ip a a 10.10.110.2/24 dev enp130s0f0
ip l s enp130s0f0 mtu 1600
ip link add vxlan12_sut type vxlan id 12 group 238.168.100.100 dev \
enp130s0f0 dstport 4789
ip l s vxlan12_sut up
ip a a 20.10.110.2/24 dev vxlan12_sut
iperf3 -c 20.10.110.1 #should connect

Without this patch, TX descriptor was using wrong data, due to
l4 header pointing wrong address. NIC would then drop those packets
internally, due to incorrect TX descriptor data, which increased
GLV_TEPC register.

Fixes: b4fb2d33514a ("i40e: Add support for MPLS + TSO")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3204,11 +3204,13 @@ static int i40e_tx_enable_csum(struct sk
 
 	protocol = vlan_get_protocol(skb);
 
-	if (eth_p_mpls(protocol))
+	if (eth_p_mpls(protocol)) {
 		ip.hdr = skb_inner_network_header(skb);
-	else
+		l4.hdr = skb_checksum_start(skb);
+	} else {
 		ip.hdr = skb_network_header(skb);
-	l4.hdr = skb_checksum_start(skb);
+		l4.hdr = skb_transport_header(skb);
+	}
 
 	/* set the tx_flags to indicate the IP protocol type. this is
 	 * required so that checksum header computation below is accurate.


