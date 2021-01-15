Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB182F79C1
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388354AbhAOMjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388351AbhAOMjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA40B224F9;
        Fri, 15 Jan 2021 12:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714346;
        bh=3eoHRRsQXBKLqb1CMU7QikyEf+E843CHi6znh6mzgbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eu7fDGFX+KMK11s0GvvyqugSsHgqzG13J0LU4RPE68miLFiQPgArHAzqnEGf3hcz8
         /uVC++FNkiVLGT5KpZF3WkDJkF6m7hPcn+n9aVIGzluLIzFmPKx7+oZMWb1nz+05N8
         OW15G8FScqS2r+r1JxzY29zv6IslvSaXjoW9D0PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 093/103] selftests: fib_nexthops: Fix wrong mausezahn invocation
Date:   Fri, 15 Jan 2021 13:28:26 +0100
Message-Id: <20210115122010.509466900@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit a5c9ca76a1c61fb5e4c35de8eb25aa925b03c9e4 upstream.

For IPv6 traffic, mausezahn needs to be invoked with '-6'. Otherwise an
error is returned:

 # ip netns exec me mausezahn veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn"
 Failed to set source IPv4 address. Please check if source is set to a valid IPv4 address.
  Invalid command line parameters!

Fixes: 7c741868ceab ("selftests: Add torture tests to nexthop tests")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/net/fib_nexthops.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -869,7 +869,7 @@ ipv6_torture()
 	pid3=$!
 	ip netns exec me ping -f 2001:db8:101::2 >/dev/null 2>&1 &
 	pid4=$!
-	ip netns exec me mausezahn veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
+	ip netns exec me mausezahn -6 veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
 	pid5=$!
 
 	sleep 300


