Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B47747ADDD
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhLTO4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45664 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237125AbhLTOyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:54:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D796119C;
        Mon, 20 Dec 2021 14:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55949C36AE7;
        Mon, 20 Dec 2021 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012058;
        bh=pT3ajgoIJTo1YFBepGsWQGl+r+sidAboeM4MFrbg6HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unngMi4A14ZGCoN+1YcSKFOF/u0IkejWXPlKmj2rVqDczL4J70a9AOCH0gbUaAaP/
         /1WjYmJxvX7XGLRRYbDJS8aYqpSmbc/W93MBJRoJ51KG/nhFPbZxh+OW4WRPcAiUak
         XOxr3OoD34vABWIJVjgUdEEOC79Z6wjpzdMnRFlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/177] selftests: icmp_redirect: pass xfail=0 to log_test()
Date:   Mon, 20 Dec 2021 15:33:34 +0100
Message-Id: <20211220143042.254284802@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 3748939bce3fc7a15ef07161826507fbe410bb7a ]

If any sub-test in this icmp_redirect.sh is failing but not expected
to fail. The script will complain:
    ./icmp_redirect.sh: line 72: [: 1: unary operator expected

This is because when the sub-test is not expected to fail, we won't
pass any value for the xfail local variable in log_test() and thus
it's empty. Fix this by passing 0 as the 4th variable to log_test()
for non-xfail cases.

v2: added fixes tag

Fixes: 0a36a75c6818 ("selftests: icmp_redirect: support expected failures")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/icmp_redirect.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
index ecbf57f264ed9..7b9d6e31b8e7d 100755
--- a/tools/testing/selftests/net/icmp_redirect.sh
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -311,7 +311,7 @@ check_exception()
 		ip -netns h1 ro get ${H1_VRF_ARG} ${H2_N2_IP} | \
 		grep -E -v 'mtu|redirected' | grep -q "cache"
 	fi
-	log_test $? 0 "IPv4: ${desc}"
+	log_test $? 0 "IPv4: ${desc}" 0
 
 	# No PMTU info for test "redirect" and "mtu exception plus redirect"
 	if [ "$with_redirect" = "yes" ] && [ "$desc" != "redirect exception plus mtu" ]; then
-- 
2.33.0



