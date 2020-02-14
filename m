Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C8A15DD7F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388386AbgBNP6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388709AbgBNP6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9808F24694;
        Fri, 14 Feb 2020 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695929;
        bh=PNI4J4LnI5EeNudriscWBtbKyV+GK1O1DWXIYeyYIG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvthPykI9v3lMPRBBsqQ8efu29bYmx+7/MPnhHwE64VTz2XrgV1YDvl2s2vs1uXGM
         3qY4qtBipt/r/EHPqjk+sUlZwhqPxY38IyuIlsyw74R3AXIA32OXSWNLk4l2QGjadd
         WV7fogs4AR/4ohgua/ClCDSd4kUezjrFpFwkXmSE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver O'Halloran <oohall@gmail.com>,
        Steve Best <sbest@redhat.com>,
        Douglas Miller <dougmill@us.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 465/542] selftests/eeh: Bump EEH wait time to 60s
Date:   Fri, 14 Feb 2020 10:47:37 -0500
Message-Id: <20200214154854.6746-465-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

