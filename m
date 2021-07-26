Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FFF3D61B8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhGZPco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237441AbhGZP3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC49A60FC1;
        Mon, 26 Jul 2021 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315684;
        bh=y8gmZqop9BmTiw9GOQqxvDT1B86BHadDU+FgFb9RLPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygR8LpBli+iDSx9GMPYBdJM6JFNbtEUCbV+GSWFaxEvOprdd2409kd8/+eT5nfcMo
         4HE6vS5X7RuN1m6yHboH0rgAyKQUyAUscsdsmoxnHwYp2h9oDW3T9u4Re5h5MvjTBP
         NJzVsXj8vCNP4zP9X9xCYyOiPueqOSEYPpjI31uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 025/223] selftests: icmp_redirect: remove from checking for IPv6 route get
Date:   Mon, 26 Jul 2021 17:36:57 +0200
Message-Id: <20210726153847.069319084@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 24b671aad4eae423e1abf5b7f08d9a5235458b8d ]

If the kernel doesn't enable option CONFIG_IPV6_SUBTREES, the RTA_SRC
info will not be exported to userspace in rt6_fill_node(). And ip cmd will
not print "from ::" to the route output. So remove this check.

Fixes: ec8105352869 ("selftests: Add redirect tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/icmp_redirect.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
index bf361f30d6ef..bfcabee50155 100755
--- a/tools/testing/selftests/net/icmp_redirect.sh
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -311,7 +311,7 @@ check_exception()
 
 	if [ "$with_redirect" = "yes" ]; then
 		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
-		grep -q "${H2_N2_IP6} from :: via ${R2_LLADDR} dev br0.*${mtu}"
+		grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0.*${mtu}"
 	elif [ -n "${mtu}" ]; then
 		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
 		grep -q "${mtu}"
-- 
2.30.2



