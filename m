Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21A61332FE
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgAGVHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgAGVHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:07:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C27462077B;
        Tue,  7 Jan 2020 21:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431265;
        bh=MM79NCL25bbH0nHMP9HiLQXuyGVNFpLsvMEYvLn9qm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bm+NgRDDRj4IGBFqIkAbe4ua6MHJF5YJHa9AwmqAy0RVB2aTzPoimsKQJ1K4+vocz
         +AeNRimWgxDH0yn+Vyrp3OTYe8cJFPGA7+jys9aCyUUmYZd0QgD15JUB4lrdm3tMOx
         LCUQda2img5Q655uMI47RAGhxNVV3Rbv2VnRnhgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/115] selftests: rtnetlink: add addresses with fixed life time
Date:   Tue,  7 Jan 2020 21:55:11 +0100
Message-Id: <20200107205308.139779209@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3cfa148826e3c666da1cc2a43fbe8689e2650636 ]

This exercises kernel code path that deal with addresses that have
a limited lifetime.

Without previous fix, this triggers following crash on net-next:
 BUG: KASAN: null-ptr-deref in check_lifetime+0x403/0x670
 Read of size 8 at addr 0000000000000010 by task kworker [..]

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/rtnetlink.sh | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index e101af52d1d6..ff665de788ef 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -234,6 +234,26 @@ kci_test_route_get()
 	echo "PASS: route get"
 }
 
+kci_test_addrlft()
+{
+	for i in $(seq 10 100) ;do
+		lft=$(((RANDOM%3) + 1))
+		ip addr add 10.23.11.$i/32 dev "$devdummy" preferred_lft $lft valid_lft $((lft+1))
+		check_err $?
+	done
+
+	sleep 5
+
+	ip addr show dev "$devdummy" | grep "10.23.11."
+	if [ $? -eq 0 ]; then
+		echo "FAIL: preferred_lft addresses remaining"
+		check_err 1
+		return
+	fi
+
+	echo "PASS: preferred_lft addresses have expired"
+}
+
 kci_test_addrlabel()
 {
 	ret=0
@@ -965,6 +985,7 @@ kci_test_rtnl()
 
 	kci_test_polrouting
 	kci_test_route_get
+	kci_test_addrlft
 	kci_test_tc
 	kci_test_gre
 	kci_test_gretap
-- 
2.20.1



