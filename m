Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D801676D6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgBUH60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:58:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730134AbgBUH6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 760C224672;
        Fri, 21 Feb 2020 07:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271904;
        bh=PNI4J4LnI5EeNudriscWBtbKyV+GK1O1DWXIYeyYIG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVvSRKTaS8QL+59DHOfI2PkxGWVaM2kBgSLGwLfz2yO2/0GA6R/xGgeTE1zrVE3J1
         8w+9oU48rDLCFp1wHNG6i2MbbzdY6BjcX1S0j5fGwFL0H8onwExeMSJpu93fWNZeLh
         hBwPpvpHfFQuJsFMLMv83HdGwh6n9OgjoAfTnQ2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Best <sbest@redhat.com>,
        Douglas Miller <dougmill@us.ibm.com>,
        Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 342/399] selftests/eeh: Bump EEH wait time to 60s
Date:   Fri, 21 Feb 2020 08:41:07 +0100
Message-Id: <20200221072434.082898081@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 414f50434aa2463202a5b35e844f4125dd1a7101 ]

Some newer cards supported by aacraid can take up to 40s to recover
after an EEH event. This causes spurious failures in the basic EEH
self-test since the current maximim timeout is only 30s.

Fix the immediate issue by bumping the timeout to a default of 60s,
and allow the wait time to be specified via an environmental variable
(EEH_MAX_WAIT).

Reported-by: Steve Best <sbest@redhat.com>
Suggested-by: Douglas Miller <dougmill@us.ibm.com>
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200122031125.25991-1-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/eeh/eeh-functions.sh | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/powerpc/eeh/eeh-functions.sh b/tools/testing/selftests/powerpc/eeh/eeh-functions.sh
index 26112ab5cdf42..f52ed92b53e74 100755
--- a/tools/testing/selftests/powerpc/eeh/eeh-functions.sh
+++ b/tools/testing/selftests/powerpc/eeh/eeh-functions.sh
@@ -53,9 +53,13 @@ eeh_one_dev() {
 	# is a no-op.
 	echo $dev >/sys/kernel/debug/powerpc/eeh_dev_check
 
-	# Enforce a 30s timeout for recovery. Even the IPR, which is infamously
-	# slow to reset, should recover within 30s.
-	max_wait=30
+	# Default to a 60s timeout when waiting for a device to recover. This
+	# is an arbitrary default which can be overridden by setting the
+	# EEH_MAX_WAIT environmental variable when required.
+
+	# The current record holder for longest recovery time is:
+	#  "Adaptec Series 8 12G SAS/PCIe 3" at 39 seconds
+	max_wait=${EEH_MAX_WAIT:=60}
 
 	for i in `seq 0 ${max_wait}` ; do
 		if pe_ok $dev ; then
-- 
2.20.1



