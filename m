Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992C0450FC9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbhKOSgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242240AbhKOSe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:34:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4894563346;
        Mon, 15 Nov 2021 18:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999253;
        bh=pKhH/t9S/manekTLD5/XhoBYKn7pRmMlwLKnyU9Itno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Me+IDacecYJ3x+Ij/7XuM9xN8lWwifzwxIBsvGUo1gF70ii65tvaq1bU0YXGqoX/A
         Q+vHI9jg2W2u5kRzgUXHf4Zpy8FZq+14WGCAWSD07+1HbuLGBgu0/2qKVAExpCadhW
         cQQOQWSBJ4650U/0lK9brxiUHEL7Twdseaj59COg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 231/849] selftests: net: fib_nexthops: Wait before checking reported idle time
Date:   Mon, 15 Nov 2021 17:55:14 +0100
Message-Id: <20211115165428.014414851@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit b69c99463d414cc263411462d52f25205657e9af ]

The purpose of this test is to verify that after a short activity passes,
the reported time is reasonable: not zero (which could be reported by
mistake), and not something outrageous (which would be indicative of an
issue in used units).

However, the idle time is reported in units of clock_t, or hundredths of
second. If the initial sequence of commands is very quick, it is possible
that the idle time is reported as just flat-out zero. When this test was
recently enabled in our nightly regression, we started seeing spurious
failures for exactly this reason.

Therefore buffer the delay leading up to the test with a sleep, to make
sure there is no legitimate way of reporting 0.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_nexthops.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 0d293391e9a44..b5a69ad191b07 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -2078,6 +2078,7 @@ basic_res()
 		"id 101 index 0 nhid 2 id 101 index 1 nhid 2 id 101 index 2 nhid 1 id 101 index 3 nhid 1"
 	log_test $? 0 "Dump all nexthop buckets in a group"
 
+	sleep 0.1
 	(( $($IP -j nexthop bucket list id 101 |
 	     jq '[.[] | select(.bucket.idle_time > 0 and
 	                       .bucket.idle_time < 2)] | length') == 4 ))
-- 
2.33.0



