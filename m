Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC0B2E16FA
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgLWDEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbgLWCTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4093E23137;
        Wed, 23 Dec 2020 02:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689920;
        bh=RY+wwWHzXfNXhUw1BdhCy1U6UGhSVWkIQxJRDhnyv4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5aJ0/5dRS9yzN2eRawmSELUq9eCOUtjlJKOPmLx+5o3VGCqbB15IpYcymnL4FQh+
         /kM+fgFVosZonaca0oATcy7YeO2OMhoNX1PfimckUw9wsKvoy2sbGbvFfMsGGXxaw7
         pRlcjNv4tYtUJQaTJvQc/X6+IjUyqCI88cLHEsyZwQJmhRXUYC9eCcHOVRn8NHrZ5P
         2QTRSvLhBx9qZ2MTWW2XFMjXc2ZWkjKdB/qXIPORyWrKq8gbTW+7DDHk2FyI1ACuiC
         gJPq8ouJqbnRTPubZT+VVJg83A7coqHK4edWDuDkrcu9ibuabyg1enjLSr461fOWHS
         bpzkEfeaQcZ3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 021/130] torture: Prevent jitter processes from delaying failed run
Date:   Tue, 22 Dec 2020 21:16:24 -0500
Message-Id: <20201223021813.2791612-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit c64659ef29e3901be0900ec6fb0485fa3dbdcfd8 ]

Even when the kernel panics and qemu dies, runs with jitter enabled will
continue uselessly until the jitter.sh processes terminate.  This can
be annoying if a planned one-hour run instead dies during boot.

This commit therefore kills the jitter.sh processes when the run ends
more than one minute prior to the termination time specified by the
kvm.sh --duration argument or its default.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     | 14 ++++++++++++++
 tools/testing/selftests/rcutorture/bin/kvm.sh      |  5 ++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 33c6696197364..a0e01a69d0d25 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -197,6 +197,20 @@ do
 				echo "ps -fp $killpid" >> $resdir/Warnings 2>&1
 				ps -fp $killpid >> $resdir/Warnings 2>&1
 			fi
+			# Reduce probability of PID reuse by allowing a one-minute buffer
+			if test $((kruntime + 60)) -lt $seconds && test -s "$resdir/../jitter_pids"
+			then
+				awk < "$resdir/../jitter_pids" '
+				NF > 0 {
+					pidlist = pidlist " " $1;
+					n++;
+				}
+				END {
+					if (n > 0) {
+						print "kill " pidlist;
+					}
+				}' | sh
+			fi
 		else
 			echo ' ---' `date`: "Kernel done"
 		fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 72518580df236..a9a6f81d9564c 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -404,8 +404,11 @@ function dump(first, pastlast, batchnum)
 	print "if test -n \"$needqemurun\""
 	print "then"
 	print "\techo ---- Starting kernels. `date` | tee -a " rd "log";
-	for (j = 0; j < njitter; j++)
+	print "\techo > " rd "jitter_pids"
+	for (j = 0; j < njitter; j++) {
 		print "\tjitter.sh " j " " dur " " ja[2] " " ja[3] "&"
+		print "\techo $! >> " rd "jitter_pids"
+	}
 	print "\twait"
 	print "\techo ---- All kernel runs complete. `date` | tee -a " rd "log";
 	print "else"
-- 
2.27.0

