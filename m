Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965CD4F2A80
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350622AbiDEJ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344164AbiDEJS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4366212F;
        Tue,  5 Apr 2022 02:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C274614E4;
        Tue,  5 Apr 2022 09:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F170C385A0;
        Tue,  5 Apr 2022 09:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149495;
        bh=pIuTGn7V2ZbvS6rqkuxePpmv09JwUS3+tmCDJx4nrgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5SDChZujxyFxqy4Wyj6Kr9eujBFj4Co9ArT0yt73EviNvJmXRdrKysRCFZH3ycnK
         Ibij+RF9ImlLyHiNsh383kOMGUqvcdTh2hHwXV21JicyfsZaYpzk2QTe4rgp55bDUY
         V1/TAUNbHcqKl0QK4iFQF+YbNllfSxbGZPI25kPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0735/1017] selftests: test_vxlan_under_vrf: Fix broken test case
Date:   Tue,  5 Apr 2022 09:27:28 +0200
Message-Id: <20220405070416.082992146@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index ea5a7a808f12..1fd1250ebc66 100755
--- a/tools/testing/selftests/net/test_vxlan_under_vrf.sh
+++ b/tools/testing/selftests/net/test_vxlan_under_vrf.sh
@@ -120,11 +120,11 @@ echo "[ OK ]"
 
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



