Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E6F30C05A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhBBNzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233289AbhBBNxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:53:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFA3064FCD;
        Tue,  2 Feb 2021 13:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273452;
        bh=Sa6tYb4IWmrl1JerSSQA4Px3w1Hsran4E+EIK/mwfYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz9/8gNZaDHQ2pGOh7A7PuN0yirxNDVNoiuFevih3ev5DbBCqiyTvoBsbAO2tfu+9
         CG7ETyESahkC9ioCZpqTq29QbjRSChoeZSfh5eb+zU7jf+s6zA3QTDwiuJDCDXA78E
         WGzPSVndju9j21IY9OaKwKsuZL+p0K1oo6QxhXEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/142] selftests: xfrm: fix test return value override issue in xfrm_policy.sh
Date:   Tue,  2 Feb 2021 14:37:23 +0100
Message-Id: <20210202133001.004840935@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit f6e9ceb7a7fc321a31a9dde93a99b7b4b016a3b3 ]

When running this xfrm_policy.sh test script, even with some cases
marked as FAIL, the overall test result will still be PASS:

$ sudo ./xfrm_policy.sh
PASS: policy before exception matches
FAIL: expected ping to .254 to fail (exceptions)
PASS: direct policy matches (exceptions)
PASS: policy matches (exceptions)
FAIL: expected ping to .254 to fail (exceptions and block policies)
PASS: direct policy matches (exceptions and block policies)
PASS: policy matches (exceptions and block policies)
FAIL: expected ping to .254 to fail (exceptions and block policies after hresh changes)
PASS: direct policy matches (exceptions and block policies after hresh changes)
PASS: policy matches (exceptions and block policies after hresh changes)
FAIL: expected ping to .254 to fail (exceptions and block policies after hthresh change in ns3)
PASS: direct policy matches (exceptions and block policies after hthresh change in ns3)
PASS: policy matches (exceptions and block policies after hthresh change in ns3)
FAIL: expected ping to .254 to fail (exceptions and block policies after htresh change to normal)
PASS: direct policy matches (exceptions and block policies after htresh change to normal)
PASS: policy matches (exceptions and block policies after htresh change to normal)
PASS: policies with repeated htresh change
$ echo $?
0

This is because the $lret in check_xfrm() is not a local variable.
Therefore when a test failed in check_exceptions(), the non-zero $lret
will later get reset to 0 when the next test calls check_xfrm().

With this fix, the final return value will be 1. Make it easier for
testers to spot this failure.

Fixes: 39aa6928d462d0 ("xfrm: policy: fix netlink/pf_key policy lookups")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/xfrm_policy.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index 7a1bf94c5bd38..5922941e70c6c 100755
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -202,7 +202,7 @@ check_xfrm() {
 	# 1: iptables -m policy rule count != 0
 	rval=$1
 	ip=$2
-	lret=0
+	local lret=0
 
 	ip netns exec ns1 ping -q -c 1 10.0.2.$ip > /dev/null
 
-- 
2.27.0



