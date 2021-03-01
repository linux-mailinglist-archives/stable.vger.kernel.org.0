Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44250328E45
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbhCAT1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:27:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241522AbhCATXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11ECB64FF7;
        Mon,  1 Mar 2021 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618484;
        bh=NV9fGt0mpJcVALe3T9Y1RBXJGn2NsdnAAeNVb8PNTtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQqNhuyVHInIV07JV4OKrhrA2FRh7cXz4UGD96cOnpUwKnAe1RPyRv/cuk1DY5ggW
         s+dfW1NUZ6AmoeuSVrUTuCshLI/13riJihTj1sSI7fW6htDoa+yXYr3b8tjw0n6ZSt
         hB3YiUf5aVAR57b0NvKMF9aVkmfA7uTfuhE1Fexg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/663] selftests/bpf: Convert test_xdp_redirect.sh to bash
Date:   Mon,  1 Mar 2021 17:05:44 +0100
Message-Id: <20210301161146.484280922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 732fa32330667a80ce4985ca81b6e9d6b2ad2072 ]

The test_xdp_redirect.sh script uses a bash feature, '&>'. On systems,
e.g. Debian, where '/bin/sh' is dash, this will not work as
expected. Use bash in the shebang to get the expected behavior.

Further, using 'set -e' means that the error of a command cannot be
captured without the command being executed with '&&' or '||'. Let us
restructure the ping-commands, and use them as an if-expression, so
that we can capture the return value.

v4: Added missing Fixes:, and removed local variables. (Andrii)
v3: Reintroduced /bin/bash, and kept 'set -e'. (Andrii)
v2: Kept /bin/sh and removed bashisms. (Randy)

Fixes: 996139e801fd ("selftests: bpf: add a test for XDP redirect")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210211082029.1687666-1-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xdp_redirect.sh | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
index dd80f0c84afb4..c033850886f44 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # Create 2 namespaces with two veth peers, and
 # forward packets in-between using generic XDP
 #
@@ -57,12 +57,8 @@ test_xdp_redirect()
 	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 &> /dev/null
 	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 &> /dev/null
 
-	ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
-	local ret1=$?
-	ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
-	local ret2=$?
-
-	if [ $ret1 -eq 0 -a $ret2 -eq 0 ]; then
+	if ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null &&
+	   ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null; then
 		echo "selftests: test_xdp_redirect $xdpmode [PASS]";
 	else
 		ret=1
-- 
2.27.0



