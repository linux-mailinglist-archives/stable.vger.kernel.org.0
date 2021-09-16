Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C140E671
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346687AbhIPRVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346977AbhIPQ4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54EA061ABC;
        Thu, 16 Sep 2021 16:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809869;
        bh=w3XAvsaR0o1QNo5DOEbGOAEHTIFUhQqye8XazM8jHMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f70xF9XqYQI9Krd5ptJidyN7YV4An5K5LPiaAbcof3RSmCmUMfGnOUE2BcWPj//a9
         Hddc2DbrwpbondRaQ8QeZIFysc2s8YRFiQrjgRKBFWUVOYvA/8j0yYov0h1S6Hq3Df
         favcNMu8EaCytZn1mOt9gN9jQv6D3bDWmmYnn8c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 312/380] samples: pktgen: fix to print when terminated normally
Date:   Thu, 16 Sep 2021 18:01:09 +0200
Message-Id: <20210916155814.675170687@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



