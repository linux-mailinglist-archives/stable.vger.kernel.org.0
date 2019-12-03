Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D19111FCA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfLCWiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbfLCWip (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 798C120684;
        Tue,  3 Dec 2019 22:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412724;
        bh=1jaVvqrRRcxk8G/3Hlu0ZZYVZUHHzUghRnsT1CY3Qr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eo/6VkApQM3W+32KTtxQv+btDmo9RPDJXGG19iFlHsltuGZunqapgCIxsVATN852Y
         UDP/bRg/heI0WUQY1TVGed0cg3WRYwclKEWTl/uXyJvEoAr9PXCAgvxrVlSx9Sd5V/
         maavT0PZuvU8VJS5dlhuERyXUtobbTqFMHHHjFUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 38/46] selftests: pmtu: use -oneline for ip route list cache
Date:   Tue,  3 Dec 2019 23:35:58 +0100
Message-Id: <20191203212801.005375736@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

[ Upstream commit 2745aea6750ff0d2c48285d25bdb00e5b636ec8b ]

Some versions of iproute2 will output more than one line per entry, which
will cause the test to fail, like:

TEST: ipv6: list and flush cached exceptions                        [FAIL]
  can't list cached exceptions

That happens, for example, with iproute2 4.15.0. When using the -oneline
option, this will work just fine:

TEST: ipv6: list and flush cached exceptions                        [ OK ]

This also works just fine with a more recent version of iproute2, like
5.4.0.

For some reason, two lines are printed for the IPv4 test no matter what
version of iproute2 is used. Use the same -oneline parameter there instead
of counting the lines twice.

Fixes: b964641e9925 ("selftests: pmtu: Make list_flush_ipv6_exception test more demanding")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Acked-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/pmtu.sh |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1249,8 +1249,7 @@ test_list_flush_ipv4_exception() {
 	done
 	run_cmd ${ns_a} ping -q -M want -i 0.1 -c 2 -s 1800 "${dst2}"
 
-	# Each exception is printed as two lines
-	if [ "$(${ns_a} ip route list cache | wc -l)" -ne 202 ]; then
+	if [ "$(${ns_a} ip -oneline route list cache | wc -l)" -ne 101 ]; then
 		err "  can't list cached exceptions"
 		fail=1
 	fi
@@ -1300,7 +1299,7 @@ test_list_flush_ipv6_exception() {
 		run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s 1800 "${dst_prefix1}${i}"
 	done
 	run_cmd ${ns_a} ping -q -M want -i 0.1 -w 1 -s 1800 "${dst2}"
-	if [ "$(${ns_a} ip -6 route list cache | wc -l)" -ne 101 ]; then
+	if [ "$(${ns_a} ip -oneline -6 route list cache | wc -l)" -ne 101 ]; then
 		err "  can't list cached exceptions"
 		fail=1
 	fi


