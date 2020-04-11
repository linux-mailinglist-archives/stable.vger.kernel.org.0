Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCF71A5AAA
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgDKXF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgDKXFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091FC20787;
        Sat, 11 Apr 2020 23:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646355;
        bh=ymIorrYieqsCNqFIdMm/hvn6WBU04UNSBOfIym/fxmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Sgn1oSNzA7FCZRYo2YPSv5qJVu8XW6qWA8j91cRbt4DAnaNhNy84aORcvNZFap7u
         +Iymi4p1dAj3/U/ijP+twemvU7er2yZQYsAiLZ6Zn60keneJzQ2T9yqdIg9MZG6qjR
         nugSof5I3it8nYRhbF3YdBPJQ9UiQg7Zi5mmqZfE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 102/149] selftests: KVM: s390: fix early guest crash
Date:   Sat, 11 Apr 2020 19:02:59 -0400
Message-Id: <20200411230347.22371-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

[ Upstream commit 41cbed5b07b5f6ca4ae567059ae7f0ffad1fd454 ]

The guest crashes very early due to changes in the control registers
used by dynamic address translation. Let us use different registers
that will not crash the guest.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/s390x/resets.c | 27 +++++++++++-----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index 1485bc6c8999f..cbb343ad5d424 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -23,25 +23,24 @@ struct kvm_run *run;
 struct kvm_sync_regs *regs;
 static uint64_t regs_null[16];
 
-static uint64_t crs[16] = { 0x40000ULL,
-			    0x42000ULL,
-			    0, 0, 0, 0, 0,
-			    0x43000ULL,
-			    0, 0, 0, 0, 0,
-			    0x44000ULL,
-			    0, 0
-};
-
 static void guest_code_initial(void)
 {
-	/* Round toward 0 */
-	uint32_t fpc = 0x11;
+	/* set several CRs to "safe" value */
+	unsigned long cr2_59 = 0x10;	/* enable guarded storage */
+	unsigned long cr8_63 = 0x1;	/* monitor mask = 1 */
+	unsigned long cr10 = 1;		/* PER START */
+	unsigned long cr11 = -1;	/* PER END */
+
 
 	/* Dirty registers */
 	asm volatile (
-		"	lctlg	0,15,%0\n"
-		"	sfpc	%1\n"
-		: : "Q" (crs), "d" (fpc));
+		"	lghi	2,0x11\n"	/* Round toward 0 */
+		"	sfpc	2\n"		/* set fpc to !=0 */
+		"	lctlg	2,2,%0\n"
+		"	lctlg	8,8,%1\n"
+		"	lctlg	10,10,%2\n"
+		"	lctlg	11,11,%3\n"
+		: : "m" (cr2_59), "m" (cr8_63), "m" (cr10), "m" (cr11) : "2");
 	GUEST_SYNC(0);
 }
 
-- 
2.20.1

