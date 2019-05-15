Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E651F010
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfEOL3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732314AbfEOL3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:29:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0342B216F4;
        Wed, 15 May 2019 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919786;
        bh=eOT/cH2Rj/MbeOz0BDKtEkQDlgNJp2D9ELE24IIFEX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZp7q2Xv/B+5TCx9c0qRH9HU9Rih1N11hpc07dR2g7ixHIaoukTDUbVFuJAB285+P
         1M9RRBSsJZqWzAKCC6HCagLCnOi1PL4O764ENJsJtETuH80XmxaTqypdGV15vv1+3w
         bc8Ek5Nbay3+vIsfSplwHHZWqVmeU7XX5qvmXGC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 076/137] selftests/net: correct the return value for run_afpackettests
Date:   Wed, 15 May 2019 12:55:57 +0200
Message-Id: <20190515090658.949905307@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8c03557c3f25271e62e39154af66ebdd1b59c9ca ]

The run_afpackettests will be marked as passed regardless the return
value of those sub-tests in the script:
    --------------------
    running psock_tpacket test
    --------------------
    [FAIL]
    selftests: run_afpackettests [PASS]

Fix this by changing the return value for each tests.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/run_afpackettests | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/run_afpackettests b/tools/testing/selftests/net/run_afpackettests
index 2dc95fda7ef76..ea5938ec009a5 100755
--- a/tools/testing/selftests/net/run_afpackettests
+++ b/tools/testing/selftests/net/run_afpackettests
@@ -6,12 +6,14 @@ if [ $(id -u) != 0 ]; then
 	exit 0
 fi
 
+ret=0
 echo "--------------------"
 echo "running psock_fanout test"
 echo "--------------------"
 ./in_netns.sh ./psock_fanout
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	ret=1
 else
 	echo "[PASS]"
 fi
@@ -22,6 +24,7 @@ echo "--------------------"
 ./in_netns.sh ./psock_tpacket
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	ret=1
 else
 	echo "[PASS]"
 fi
@@ -32,6 +35,8 @@ echo "--------------------"
 ./in_netns.sh ./txring_overwrite
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	ret=1
 else
 	echo "[PASS]"
 fi
+exit $ret
-- 
2.20.1



