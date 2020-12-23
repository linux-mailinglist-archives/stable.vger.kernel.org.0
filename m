Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8169F2E175E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgLWDJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbgLWCSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C979A23370;
        Wed, 23 Dec 2020 02:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689846;
        bh=NY+pm1T3bmTqsuWanFH+J/5JcBxQGzGFCy4Cz8k3620=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crLmU7PIG+4azxHQdOaWKjNontzbGQyxSWUKTAjVPVD+KVakQcSlPZC1F/ZCPUIsl
         furjMYih6Lhq+rlnNkjyjYbgbpINW2leFoisSwpNZ3RgwTdwfJG7odCivKFkyOyiMa
         Dy42/vTglGIxFsEzHdFVxQDIqf/nmFHIPxgkHQXm6hame9omy77nNpRBT8+qrwCH2z
         vP2vNEbPEgD3by14YdwWKnGrU4woIYyuI+sr5wu/jBaT7lz4UymqffqkD37uYiQaZD
         IU4mPISF4qyhNGL4bokjBmB67r+3S3i1Y3xyc4tG7HqFwlk6dNVqcvih9sk0x6JH5i
         JHh38al8Wvk1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 046/217] torture: Prevent jitter processes from delaying failed run
Date:   Tue, 22 Dec 2020 21:13:35 -0500
Message-Id: <20201223021626.2790791-46-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index 6dc2b49b85ea0..6544a289a5832 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -223,6 +223,20 @@ do
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
index 6eb1d3f6524d5..5ad3882563ce6 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -459,8 +459,11 @@ function dump(first, pastlast, batchnum)
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

