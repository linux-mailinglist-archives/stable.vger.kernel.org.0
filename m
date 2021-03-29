Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92BC34CA86
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhC2Iiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234826AbhC2IhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62A58619BB;
        Mon, 29 Mar 2021 08:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007005;
        bh=iBauD/YwGNRCek8/X8z7f22gVG1rUIanDYdTEaY0FK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXIs4aq72ZfceE/DpfUx4Uw0GuoH3VXNPCb5Ne5sku96AN4oSyMRFrwabO5hHd5IL
         eMWs0ymZgQERB+LxLCFVR3b8XGSo1mwoeId0Ww65HOTS2HGOWkD0MnqoB2TZ7cktEt
         /sn7dq+Um8J4aBFaBBgTeRvvpEaYs0eZLktqG+xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 185/254] selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value
Date:   Mon, 29 Mar 2021 09:58:21 +0200
Message-Id: <20210329075639.212662413@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 5aa3c334a449bab24519c4967f5ac2b3304c8dcf ]

The ECN bit defines ECT(1) = 1, ECT(0) = 2. So inner 0x02 + outer 0x01
should be inner ECT(0) + outer ECT(1). Based on the description of
__INET_ECN_decapsulate, the final decapsulate value should be
ECT(1). So fix the test expect value to 0x01.

Before the fix:
TEST: VXLAN: ECN decap: 01/02->0x02                                 [FAIL]
        Expected to capture 10 packets, got 0.

After the fix:
TEST: VXLAN: ECN decap: 01/02->0x01                                 [ OK ]

Fixes: a0b61f3d8ebf ("selftests: forwarding: vxlan_bridge_1d: Add an ECN decap test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index ce6bea9675c0..0ccb1dda099a 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -658,7 +658,7 @@ test_ecn_decap()
 	# In accordance with INET_ECN_decapsulate()
 	__test_ecn_decap 00 00 0x00
 	__test_ecn_decap 01 01 0x01
-	__test_ecn_decap 02 01 0x02
+	__test_ecn_decap 02 01 0x01
 	__test_ecn_decap 01 03 0x03
 	__test_ecn_decap 02 03 0x03
 	test_ecn_decap_error
-- 
2.30.1



