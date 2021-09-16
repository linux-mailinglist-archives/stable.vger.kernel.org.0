Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFE140E7D6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349801AbhIPRnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353977AbhIPRh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47A2863277;
        Thu, 16 Sep 2021 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811010;
        bh=YEC4jJ1LBWD3tQ8++dMqLrxnkDQeusqtbuXxD3bYWI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMTGhvbE/QNiS3HAGYk7gmuTCYO0UECRzP2sDT3WC/U4kbboE4C5ohS9JXiCNbgc9
         vAQ/vL4lRHm0nsTuMu0Aw7ErLktCCX9I5SswaOuZfVCdRhlk+VlTvUMiFtFDieHOEG
         jWzA+w/NnP4GrFtf1R4A5nZBXASvnqKju0kCs5TE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 351/432] samples: pktgen: fix to print when terminated normally
Date:   Thu, 16 Sep 2021 18:01:40 +0200
Message-Id: <20210916155822.716559782@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index ab87de440277..8bf2fdffba16 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -85,7 +85,7 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 done
 
 # Run if user hits control-c
-function control_c() {
+function print_result() {
     # Print results
     for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do
 	dev=${DEV}@${thread}
@@ -94,11 +94,13 @@ function control_c() {
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



