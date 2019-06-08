Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA01B39EE7
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfFHLrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727532AbfFHLrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:47:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EEA3214DA;
        Sat,  8 Jun 2019 11:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994424;
        bh=C+6URup4x6WWyXK1GXWSoHnLonUHCD8kJjjmj9A+3h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRqe83gqWvIWV1jDOXWN96qkTGVvxQc+zL5E/Aap505mCtGRx6uO2lAnLsQl7KDka
         ejALwEDHrKnM3fRUqMkcEZVGKVsXFm+aXzcOSudyiKY6kdvNwUj+jxo27BZyrT2PsE
         8nUmQPSr5MtrRr+9Bh4UuDRV9pAQC9mCg6dbjsY4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/31] selftests: netfilter: missing error check when setting up veth interface
Date:   Sat,  8 Jun 2019 07:46:16 -0400
Message-Id: <20190608114646.9415-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114646.9415-1-sashal@kernel.org>
References: <20190608114646.9415-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

[ Upstream commit 82ce6eb1dd13fd12e449b2ee2c2ec051e6f52c43 ]

A test for the basic NAT functionality uses ip command which needs veth
device. There is a condition where the kernel support for veth is not
compiled into the kernel and the test script breaks. This patch contains
code for reasonable error display and correct code exit.

Signed-off-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 8ec76681605c..f25f72a75cf3 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -23,7 +23,11 @@ ip netns add ns0
 ip netns add ns1
 ip netns add ns2
 
-ip link add veth0 netns ns0 type veth peer name eth0 netns ns1
+ip link add veth0 netns ns0 type veth peer name eth0 netns ns1 > /dev/null 2>&1
+if [ $? -ne 0 ];then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
 ip link add veth1 netns ns0 type veth peer name eth0 netns ns2
 
 ip -net ns0 link set lo up
-- 
2.20.1

