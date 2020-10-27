Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A553529C21B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761663AbgJ0Rbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762180AbgJ0OlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:41:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38A020773;
        Tue, 27 Oct 2020 14:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809682;
        bh=/AgdZpYKHEmdN5fGFoYyxwBX0RIOkFZ6ZZ1HZRDqrRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBNqLvBYR6hDKbrZlo+INgn0g6J23xNmVwRYxCXROdMOJ1ZUOpkiku9+nxKae8vfG
         L+6QWLYHOPmuV8ZtmiYUYFTEV3cLc6dz98ciwX9ffUV9JqIztbnN3L6WPXk4+e7FHh
         IsrGcKE5LDq+vV6Q98cF1xoBE+gitm9ysGbop0vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 251/408] selftests/powerpc: Fix eeh-basic.sh exit codes
Date:   Tue, 27 Oct 2020 14:53:09 +0100
Message-Id: <20201027135506.702225959@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 996f9e0f93f16211945c8d5f18f296a88cb32f91 ]

The kselftests test running infrastructure expects tests to finish with an
exit code of 4 if the test decided it should be skipped. Currently
eeh-basic.sh exits with the number of devices that failed to recover, so if
four devices didn't recover we'll report a skip instead of a fail.

Fix this by checking if the return code is non-zero and report success
and failure by returning 0 or 1 respectively. For the cases where should
actually skip return 4.

Fixes: 85d86c8aa52e ("selftests/powerpc: Add basic EEH selftest")
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201014024711.1138386-1-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/eeh/eeh-basic.sh | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/powerpc/eeh/eeh-basic.sh b/tools/testing/selftests/powerpc/eeh/eeh-basic.sh
index f988d2f42e8f2..cf001a2c69420 100755
--- a/tools/testing/selftests/powerpc/eeh/eeh-basic.sh
+++ b/tools/testing/selftests/powerpc/eeh/eeh-basic.sh
@@ -1,17 +1,19 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0-only
 
+KSELFTESTS_SKIP=4
+
 . ./eeh-functions.sh
 
 if ! eeh_supported ; then
 	echo "EEH not supported on this system, skipping"
-	exit 0;
+	exit $KSELFTESTS_SKIP;
 fi
 
 if [ ! -e "/sys/kernel/debug/powerpc/eeh_dev_check" ] && \
    [ ! -e "/sys/kernel/debug/powerpc/eeh_dev_break" ] ; then
 	echo "debugfs EEH testing files are missing. Is debugfs mounted?"
-	exit 1;
+	exit $KSELFTESTS_SKIP;
 fi
 
 pre_lspci=`mktemp`
@@ -79,4 +81,5 @@ echo "$failed devices failed to recover ($dev_count tested)"
 lspci | diff -u $pre_lspci -
 rm -f $pre_lspci
 
-exit $failed
+test "$failed" == 0
+exit $?
-- 
2.25.1



