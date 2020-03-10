Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B896417F974
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgCJM4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgCJM4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:56:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED14A20674;
        Tue, 10 Mar 2020 12:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845014;
        bh=eoNayO3uiDva1CrJ3Fk5TV4cI6wo6Xy7e7/LDxK2Xuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADiYwnoqJG5z5dBTE8PFMrAgK53H3Km49I7r4cZ3LxTwbQnYN6gyANaw+WX+wJUM2
         BJXVvHU1/Q03ec9is2J8k0pbGlmdx4SRzXRi16vvJlI6zBPQWIe3aSMsZByVsBDL3F
         Rqmhc43/8V0dqfpD7ze2Nh1pdJFdMbG8ta8sufOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 030/189] selftests: forwarding: vxlan_bridge_1d: fix tos value
Date:   Tue, 10 Mar 2020 13:37:47 +0100
Message-Id: <20200310123642.501946978@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4e867c9a50ff1a07ed0b86c3b1c8bc773933d728 ]

After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
strict vxlan xmit tos value by RT_TOS(), which limits the tos value less
than 0x1E. With current value 0x40 the test will failed with "v1: Expected
to capture 10 packets, got 0". So let's choose a smaller tos value for
testing.

Fixes: d417ecf533fe ("selftests: forwarding: vxlan_bridge_1d: Add a TOS test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index bb10e33690b25..353613fc19475 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -516,9 +516,9 @@ test_tos()
 	RET=0
 
 	tc filter add dev v1 egress pref 77 prot ip \
-		flower ip_tos 0x40 action pass
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x40" v1 egress 77 10
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x30" v1 egress 77 0
+		flower ip_tos 0x11 action pass
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0
 	tc filter del dev v1 egress pref 77 prot ip
 
 	log_test "VXLAN: envelope TOS inheritance"
-- 
2.20.1



