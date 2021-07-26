Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06563D6010
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhGZPUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236638AbhGZPUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F8EF60240;
        Mon, 26 Jul 2021 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315259;
        bh=vDLIhy+N5aPbnzzu9n74JD7Wlx3WnNTbPANWOz/MYX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qY6lG42hCqCctKtnIqWhijpejms7DyKkecvnmPU1izALmO3Wtw7ZjOGXX+ZUWi9/O
         tfHqWvLPoVZVsD8c4wlXAx3zcID2Vxt2qBAOjaB7v6UvJ+KcHS11mRsE0WMbYlMlHs
         VxqSe7Izy6LwdZtnul7EgAYX1JBsOvgH7MLlbDko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/167] selftests: icmp_redirect: IPv6 PMTU info should be cleared after redirect
Date:   Mon, 26 Jul 2021 17:37:39 +0200
Message-Id: <20210726153840.242078610@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 0e02bf5de46ae30074a2e1a8194a422a84482a1a ]

After redirecting, it's already a new path. So the old PMTU info should
be cleared. The IPv6 test "mtu exception plus redirect" should only
has redirect info without old PMTU.

The IPv4 test can not be changed because of legacy.

Fixes: ec8105352869 ("selftests: Add redirect tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/icmp_redirect.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
index bfcabee50155..104a7a5f13b1 100755
--- a/tools/testing/selftests/net/icmp_redirect.sh
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -309,9 +309,10 @@ check_exception()
 	fi
 	log_test $? 0 "IPv4: ${desc}"
 
-	if [ "$with_redirect" = "yes" ]; then
+	# No PMTU info for test "redirect" and "mtu exception plus redirect"
+	if [ "$with_redirect" = "yes" ] && [ "$desc" != "redirect exception plus mtu" ]; then
 		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
-		grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0.*${mtu}"
+		grep -v "mtu" | grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0"
 	elif [ -n "${mtu}" ]; then
 		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
 		grep -q "${mtu}"
-- 
2.30.2



