Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9C48333C
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiACOfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:35:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60386 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiACOcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:32:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D175161119;
        Mon,  3 Jan 2022 14:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F142C36AEB;
        Mon,  3 Jan 2022 14:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220372;
        bh=CimNV+shsGOoPrcFLjR3vYjlz4NNvKPdixSuaJlPVNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bg/GIt9YmsOgRPC9FMn3yLvp3clYrZWea/bBaUkH8bpibaOCwWe3NTO7NwdiaqHEV
         s2+eQIts0egIQbA1BCy7oMHH1Xj/8oFFYL0vdF9zUer4403aE52CNFrTs/Hp47V50w
         7O+ya4mxg/WEd0ainjDpRnmV32ctLifNeLbs8USY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/73] selftests: net: using ping6 for IPv6 in udpgro_fwd.sh
Date:   Mon,  3 Jan 2022 15:24:10 +0100
Message-Id: <20220103142058.492189171@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit 8b3170e07539855ee91bc5e2fa7780a4c9b5c7aa ]

udpgro_fwd.sh output following message:
  ping: 2001:db8:1::100: Address family for hostname not supported

Using ping6 when pinging IPv6 addresses.

Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro_fwd.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 6a3985b8cd7f6..3ea73013d9568 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -185,6 +185,7 @@ for family in 4 6; do
 	IPT=iptables
 	SUFFIX=24
 	VXDEV=vxlan
+	PING=ping
 
 	if [ $family = 6 ]; then
 		BM_NET=$BM_NET_V6
@@ -192,6 +193,7 @@ for family in 4 6; do
 		SUFFIX="64 nodad"
 		VXDEV=vxlan6
 		IPT=ip6tables
+		PING="ping6"
 	fi
 
 	echo "IPv$family"
@@ -237,7 +239,7 @@ for family in 4 6; do
 
 	# load arp cache before running the test to reduce the amount of
 	# stray traffic on top of the UDP tunnel
-	ip netns exec $NS_SRC ping -q -c 1 $OL_NET$DST_NAT >/dev/null
+	ip netns exec $NS_SRC $PING -q -c 1 $OL_NET$DST_NAT >/dev/null
 	run_test "GRO fwd over UDP tunnel" $OL_NET$DST_NAT 1 1 $OL_NET$DST
 	cleanup
 
-- 
2.34.1



