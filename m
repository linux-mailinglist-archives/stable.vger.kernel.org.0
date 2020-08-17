Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE92024731B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391524AbgHQSvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387892AbgHQPxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:53:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92DA720657;
        Mon, 17 Aug 2020 15:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679583;
        bh=u2l8rYnpqO1GxowdoZloj+Y5TmSk8RmfO86+JjBpaeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RO+pLPcY96ZEPWwDrD6mgT96b6Izbez7ETsVwRFF/O9CEGnPmmczVes3tEjhy3si+
         f0CayJqARFwY0pgDysMvMAnqQ31VYM6q3uCZz6ujUdM4FHJFc2OyiUXVMxUssxu36Y
         fvrhhOxqkpGd8onUfMVHSnWIdLvV3YPMCY2cTYz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 265/393] selftests/powerpc: Squash spurious errors due to device removal
Date:   Mon, 17 Aug 2020 17:15:15 +0200
Message-Id: <20200817143832.469464474@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 5f8cf6475828b600ff6d000e580c961ac839cc61 ]

For drivers that don't have the error handling callbacks we implement
recovery by removing the device and re-probing it. This causes the sysfs
directory for the PCI device to be removed which causes the following
spurious error to be printed when checking the PE state:

Breaking 0005:03:00.0...
./eeh-basic.sh: line 13: can't open /sys/bus/pci/devices/0005:03:00.0/eeh_pe_state: no such file
0005:03:00.0, waited 0/60
0005:03:00.0, waited 1/60
0005:03:00.0, waited 2/60
0005:03:00.0, waited 3/60
0005:03:00.0, waited 4/60
0005:03:00.0, waited 5/60
0005:03:00.0, waited 6/60
0005:03:00.0, waited 7/60
0005:03:00.0, Recovered after 8 seconds

We currently try to avoid this by checking if the PE state file exists
before reading from it. This is however inherently racy so re-work the
state checking so that we only read from the file once, and we squash any
errors that occur while reading.

Fixes: 85d86c8aa52e ("selftests/powerpc: Add basic EEH selftest")
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200727010127.23698-1-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/eeh/eeh-functions.sh | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/powerpc/eeh/eeh-functions.sh b/tools/testing/selftests/powerpc/eeh/eeh-functions.sh
index f52ed92b53e74..00dc32c0ed75c 100755
--- a/tools/testing/selftests/powerpc/eeh/eeh-functions.sh
+++ b/tools/testing/selftests/powerpc/eeh/eeh-functions.sh
@@ -5,12 +5,17 @@ pe_ok() {
 	local dev="$1"
 	local path="/sys/bus/pci/devices/$dev/eeh_pe_state"
 
-	if ! [ -e "$path" ] ; then
+	# if a driver doesn't support the error handling callbacks then the
+	# device is recovered by removing and re-probing it. This causes the
+	# sysfs directory to disappear so read the PE state once and squash
+	# any potential error messages
+	local eeh_state="$(cat $path 2>/dev/null)"
+	if [ -z "$eeh_state" ]; then
 		return 1;
 	fi
 
-	local fw_state="$(cut -d' ' -f1 < $path)"
-	local sw_state="$(cut -d' ' -f2 < $path)"
+	local fw_state="$(echo $eeh_state | cut -d' ' -f1)"
+	local sw_state="$(echo $eeh_state | cut -d' ' -f2)"
 
 	# If EEH_PE_ISOLATED or EEH_PE_RECOVERING are set then the PE is in an
 	# error state or being recovered. Either way, not ok.
-- 
2.25.1



