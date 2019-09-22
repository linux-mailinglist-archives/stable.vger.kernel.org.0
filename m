Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AF1BA4A0
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfIVSua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbfIVSua (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D062E21D7A;
        Sun, 22 Sep 2019 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178229;
        bh=o0TPlNlA6sE8SAGKH4X9ZsJIGV0LCZYH5UcKTwQ4ZXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19iOUnsIGA91Oj06QOJnoundTpxUzaTVHqnLoplbF17HnNG2pw4GFzFUQfQKYFFWU
         eAQgJSok3VrKiM7+OTkgTthcA5vHbUpystpFhp8s/DlVorX1um/hj6iNeheQBLyMUH
         tHklJ6Ys83eCwhJmz5mkupmK14vJyzguyDyBSO54=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 028/185] x86/apic: Soft disable APIC before initializing it
Date:   Sun, 22 Sep 2019 14:46:46 -0400
Message-Id: <20190922184924.32534-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
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
index 67d1259e0f7c0..a18d6dd934e55 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1550,6 +1550,14 @@ static void setup_local_APIC(void)
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

