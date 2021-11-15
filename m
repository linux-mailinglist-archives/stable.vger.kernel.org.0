Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF1E451454
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhKOUCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344270AbhKOTYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64BC663659;
        Mon, 15 Nov 2021 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002489;
        bh=44tmNFUr3yPmoso9ajUWe4/xno244YXGvHWI641IeOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTz/+fjpn3vBoDfvGBYyo496lwrKYondFbMHCRdi7q7urDdBgVvawk9mWp+dgFnPG
         77jIRxCL8ce52Ojzek3pUbwvOCebr7gLZVfQiJ48uBkTjAWuWC4Q3OmuUTzdDd8smE
         P40RZp1DhevPkmHT0StIMCuOxaakyG0E6xpSbskc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 559/917] selftests: mptcp: fix proto type in link_failure tests
Date:   Mon, 15 Nov 2021 18:00:54 +0100
Message-Id: <20211115165447.746367190@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit 7c909a98042ce403c8497c5d6ff94dd53bdd2131 ]

In listener_ns, we should pass srv_proto argument to mptcp_connect command,
not cl_proto.

Fixes: 7d1e6f1639044 ("selftests: mptcp: add testcase for active-back")
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 255793c5ac4ff..586af88194e56 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -297,7 +297,7 @@ do_transfer()
 	if [ "$test_link_fail" -eq 2 ];then
 		timeout ${timeout_test} \
 			ip netns exec ${listener_ns} \
-				$mptcp_connect -t ${timeout_poll} -l -p $port -s ${cl_proto} \
+				$mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
 					${local_addr} < "$sinfail" > "$sout" &
 	else
 		timeout ${timeout_test} \
-- 
2.33.0



