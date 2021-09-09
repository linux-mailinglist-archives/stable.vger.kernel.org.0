Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E014050BF
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348972AbhIIMbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353299AbhIIMUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDCC661AED;
        Thu,  9 Sep 2021 11:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188236;
        bh=w3XAvsaR0o1QNo5DOEbGOAEHTIFUhQqye8XazM8jHMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uys0eAesSX0Zt0CqDGI/8/tzrVCdt83Ds+EXzp/jUxz5YxCuBJixq0/+yOT8lL5j1
         9jzZzswnfjaC7qJtblivdL7At8fw06+kRfNvWHQSiVvJBZyL1mOlrk3y7g6dIKUcyR
         THg3lsLqwWcqmun+hmOyhsxSQMeRc34BUidvxgp9IYB9hlqMeHHeHBFNwWVmnBZRKy
         B8duZMRXF3/rRwCI1/fyu6g8FXslMLRM/P5fZdFpE4Ltor1zcNjDDRS7uqVZxJUQnG
         LiRgT4NnhPVVJcEGnsfNRNDuBUSh7+BfbTSBHArrgAepzYVV4+uv11bgJhyaSekEbG
         jJxTY3l2VkCBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juhee Kang <claudiajkang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 187/219] samples: pktgen: fix to print when terminated normally
Date:   Thu,  9 Sep 2021 07:46:03 -0400
Message-Id: <20210909114635.143983-187-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juhee Kang <claudiajkang@gmail.com>

[ Upstream commit c0e9422c4e6ca9abd4bd6e1598400c7231eb600b ]

Currently, most pktgen samples print the execution result when the
program is terminated normally. However, sample03 doesn't work
appropriately.

This is results of samples:

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample04_many_flows.sh -n 1
    Running... ctrl^C to stop
    Device: eth0@0
    Result: OK: 19(c5+d13) usec, 1 (60byte,0frags)
    51762pps 24Mb/sec (24845760bps) errors: 0

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample03_burst_single_flow.sh -n 1
    Running... ctrl^C to stop

The reason why it doesn't print the execution result when the program is
terminated usually is that sample03 doesn't call the function which
prints the result, unlike other samples.

So, this commit solves this issue by calling the function before
termination. Also, this commit changes control_c function to
print_result to maintain consistency with other samples.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/pktgen/pktgen_sample03_burst_single_flow.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index 5adcf954de73..c12198d5bbe5 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -83,7 +83,7 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 done
 
 # Run if user hits control-c
-function control_c() {
+function print_result() {
     # Print results
     for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 	dev=${DEV}@${thread}
@@ -92,11 +92,13 @@ function control_c() {
     done
 }
 # trap keyboard interrupt (Ctrl-C)
-trap control_c SIGINT
+trap true SIGINT
 
 if [ -z "$APPEND" ]; then
     echo "Running... ctrl^C to stop" >&2
     pg_ctrl "start"
+
+    print_result
 else
     echo "Append mode: config done. Do more or use 'pg_ctrl start' to run"
 fi
-- 
2.30.2

