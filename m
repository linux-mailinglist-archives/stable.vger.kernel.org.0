Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A494F42AB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382361AbiDEMPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242775AbiDEKfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EFA4A920;
        Tue,  5 Apr 2022 03:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 568BBB81BC5;
        Tue,  5 Apr 2022 10:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4A0C385A1;
        Tue,  5 Apr 2022 10:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154057;
        bh=WTTgE0jq1ET24nxFgkUnERXPbOwuOz6l4qpBGMY5MV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJf1RUzKmTIBoSPMbVGl97qAEdIxzwa1SO318SypLmwvz5j3741W8LWExNBF3A+zC
         I5WDTdpPAQtC7uouk2CWZjI6iWzcAeBidoMZYgiIRKm2XFKQ/J6Cy0S/eF8wk9+epy
         F11irdxnb+Kd65jWoooxSTctAnISCB7ZsnfjVaig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 441/599] selftests: test_vxlan_under_vrf: Fix broken test case
Date:   Tue,  5 Apr 2022 09:32:15 +0200
Message-Id: <20220405070311.955504838@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit b50d3b46f84282d795ae3076111acb75ae1031f3 ]

The purpose of the last test case is to test VXLAN encapsulation and
decapsulation when the underlay lookup takes place in a non-default VRF.
This is achieved by enslaving the physical device of the tunnel to a
VRF.

The binding of the VXLAN UDP socket to the VRF happens when the VXLAN
device itself is opened, not when its physical device is opened. This
was also mentioned in the cited commit ("tests that moving the underlay
from a VRF to another works when down/up the VXLAN interface"), but the
test did something else.

Fix it by reopening the VXLAN device instead of its physical device.

Before:

 # ./test_vxlan_under_vrf.sh
 Checking HV connectivity                                           [ OK ]
 Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
 Check VM connectivity through VXLAN (underlay in a VRF)            [FAIL]

After:

 # ./test_vxlan_under_vrf.sh
 Checking HV connectivity                                           [ OK ]
 Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
 Check VM connectivity through VXLAN (underlay in a VRF)            [ OK ]

Fixes: 03f1c26b1c56 ("test/net: Add script for VXLAN underlay in a VRF")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220324200514.1638326-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/test_vxlan_under_vrf.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/test_vxlan_under_vrf.sh b/tools/testing/selftests/net/test_vxlan_under_vrf.sh
index 09f9ed92cbe4..a44b9aca7427 100755
--- a/tools/testing/selftests/net/test_vxlan_under_vrf.sh
+++ b/tools/testing/selftests/net/test_vxlan_under_vrf.sh
@@ -118,11 +118,11 @@ echo "[ OK ]"
 
 # Move the underlay to a non-default VRF
 ip -netns hv-1 link set veth0 vrf vrf-underlay
-ip -netns hv-1 link set veth0 down
-ip -netns hv-1 link set veth0 up
+ip -netns hv-1 link set vxlan0 down
+ip -netns hv-1 link set vxlan0 up
 ip -netns hv-2 link set veth0 vrf vrf-underlay
-ip -netns hv-2 link set veth0 down
-ip -netns hv-2 link set veth0 up
+ip -netns hv-2 link set vxlan0 down
+ip -netns hv-2 link set vxlan0 up
 
 echo -n "Check VM connectivity through VXLAN (underlay in a VRF)            "
 ip netns exec vm-1 ping -c 1 -W 1 10.0.0.2 &> /dev/null || (echo "[FAIL]"; false)
-- 
2.34.1



