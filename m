Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DB437C64C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbhELPuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235461AbhELPo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:44:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48AB661442;
        Wed, 12 May 2021 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832976;
        bh=q/CQeOZFelVB4w0ZhwP7lNZAUC+B9fNx61ezJKfG7ZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGLpWNpLfRc5S+rZN5wCRPiRzIbdD2ZVGmGjvLZqjH6h32iI1+Dl/hnC0ntpcDhDz
         qKrb/pepGjOoHtCIcpeQ3D5tZaQ8YxbQYOo0gbaToFWHm3u+KluMelCxhY135slrWI
         MkGAJUWUALX7rJw70ziv6GSUfTP74niGywH6zync=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 499/530] selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static
Date:   Wed, 12 May 2021 16:50:09 +0200
Message-Id: <20210512144836.159774941@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit c8d0260cdd96fdccdef0509c4160e28a1012a5d7 ]

The FDB roaming test installs a destination MAC address on the wrong
interface of an FDB database and tests whether the mirroring fails, because
packets are sent to the wrong port. The test by mistake installs the FDB
entry as local. This worked previously, because drivers were notified of
local FDB entries in the same way as of static entries. However that has
been fixed in the commit 6ab4c3117aec ("net: bridge: don't notify switchdev
for local FDB addresses"), and local entries are not notified anymore. As a
result, the HW is not reconfigured for the FDB roam, and mirroring keeps
working, failing the test.

To fix the issue, mark the FDB entry as static.

Fixes: 9c7c8a82442c ("selftests: forwarding: mirror_gre_vlan_bridge_1q: Add more tests")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
index c02291e9841e..880e3ab9d088 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
@@ -271,7 +271,7 @@ test_span_gre_fdb_roaming()
 
 	while ((RET == 0)); do
 		bridge fdb del dev $swp3 $h3mac vlan 555 master 2>/dev/null
-		bridge fdb add dev $swp2 $h3mac vlan 555 master
+		bridge fdb add dev $swp2 $h3mac vlan 555 master static
 		sleep 1
 		fail_test_span_gre_dir $tundev ingress
 
-- 
2.30.2



