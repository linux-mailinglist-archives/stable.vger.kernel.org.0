Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E5E13928
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfEDKZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbfEDKZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:25:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E4D20870;
        Sat,  4 May 2019 10:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965553;
        bh=tR+MRprfOBngS7bSmtpEByqIvAYApqoBHZdstMOPoAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wf/fMFHoc/lmFaju3JHgEmq8o4hbFBdnTyBdgDmP2DF56XN+wLjAprWK5jrPq1DC9
         +KmC3Fw3TODIw7fLQ2yOU6jPMs4oRmgGg7/Sks6P5Rh6f/H0ycXHD63pRjk9bOHANP
         SrflWHU7/iZpi1DxM1QIrKEO9KTsY1RlJ5ARa+5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 16/32] selftests: fib_rule_tests: Fix icmp proto with ipv6
Date:   Sat,  4 May 2019 12:25:01 +0200
Message-Id: <20190504102453.021845546@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 15d55bae4e3c43cd9f87fd93c73a263e172d34e1 ]

A recent commit returns an error if icmp is used as the ip-proto for
IPv6 fib rules. Update fib_rule_tests to send ipv6-icmp instead of icmp.

Fixes: 5e1a99eae8499 ("ipv4: Add ICMPv6 support when parse route ipproto")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/fib_rule_tests.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -148,8 +148,8 @@ fib_rule6_test()
 
 	fib_check_iproute_support "ipproto" "ipproto"
 	if [ $? -eq 0 ]; then
-		match="ipproto icmp"
-		fib_rule6_test_match_n_redirect "$match" "$match" "ipproto icmp match"
+		match="ipproto ipv6-icmp"
+		fib_rule6_test_match_n_redirect "$match" "$match" "ipproto ipv6-icmp match"
 	fi
 }
 


