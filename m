Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5327917F8B2
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgCJMuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgCJMuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:50:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EACCB2468E;
        Tue, 10 Mar 2020 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844618;
        bh=vOSBD3sjHzK6riGbNN96CcuhfOs6Oto3eXhPhUlUcHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvCR+8aD8qSYdouXvgCqSFWNIGJ/bJJtqT+5OTa9qfkP6KFy+WYH6rLcgV4y0A7vG
         qTovLJgUZtfNeAUl/yPtzV4EXkQ0O4vz4SHrkjvjz6peP213HsX1Zgt2FazdMZQUog
         5ONgiQwD829N2ZYDmoBVMdGMVMb7ncTXzNzITjNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/168] selftests: forwarding: vxlan_bridge_1d: use more proper tos value
Date:   Tue, 10 Mar 2020 13:38:22 +0100
Message-Id: <20200310123641.006584445@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 9b64208f74fbd0e920475ecfe9326f8443fdc3a5 ]

0x11 and 0x12 set the ECN bits based on RFC2474, it would be better to avoid
that. 0x14 and 0x18 would be better and works as well.

Reported-by: Petr Machata <petrm@mellanox.com>
Fixes: 4e867c9a50ff ("selftests: forwarding: vxlan_bridge_1d: fix tos value")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index 353613fc19475..ce6bea9675c07 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -516,9 +516,9 @@ test_tos()
 	RET=0
 
 	tc filter add dev v1 egress pref 77 prot ip \
-		flower ip_tos 0x11 action pass
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0
+		flower ip_tos 0x14 action pass
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x14" v1 egress 77 10
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x18" v1 egress 77 0
 	tc filter del dev v1 egress pref 77 prot ip
 
 	log_test "VXLAN: envelope TOS inheritance"
-- 
2.20.1



