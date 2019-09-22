Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7A8BA880
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfIVTE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395303AbfIVTBS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:01:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D47821907;
        Sun, 22 Sep 2019 19:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178877;
        bh=Djd92TOnQuQnGWGjj7N+dlsVbu2NxvIUCPumOuYgz60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSjM+jKEHmX7fDvN0a+sdLniFOQtk1YzQ2VT18/4Oj7h2orNs6imhjkxbbIwX7U1N
         HSgwK+RlkKbzchUuZ3W508PGhkzxdS3MLF2MlX5jJQQ013eBAA802TiCeZ36vHOnVA
         cHJAVw8gWhJsF/9vfcQHQ9IRgTnTkQMX+cvXcDcw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 10/44] x86/apic: Soft disable APIC before initializing it
Date:   Sun, 22 Sep 2019 15:00:28 -0400
Message-Id: <20190922190103.4906-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2640da4cccf5cc613bf26f0998b9e340f4b5f69c ]

If the APIC was already enabled on entry of setup_local_APIC() then
disabling it soft via the SPIV register makes a lot of sense.

That masks all LVT entries and brings it into a well defined state.

Otherwise previously enabled LVTs which are not touched in the setup
function stay unmasked and might surprise the just booting kernel.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20190722105219.068290579@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 834d1b5b43557..be3d4dcf3a10a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1265,6 +1265,14 @@ void setup_local_APIC(void)
 		return;
 	}
 
+	/*
+	 * If this comes from kexec/kcrash the APIC might be enabled in
+	 * SPIV. Soft disable it before doing further initialization.
+	 */
+	value = apic_read(APIC_SPIV);
+	value &= ~APIC_SPIV_APIC_ENABLED;
+	apic_write(APIC_SPIV, value);
+
 #ifdef CONFIG_X86_32
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
 	if (lapic_is_integrated() && apic->disable_esr) {
-- 
2.20.1

