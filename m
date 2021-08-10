Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022E13E5BF7
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 15:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhHJNlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 09:41:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43462 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbhHJNlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 09:41:44 -0400
Date:   Tue, 10 Aug 2021 13:41:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628602880;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MvqNAUK9CzyqMGlZRxuxmPHmqua1EIZDIwIvRqbZ9Bk=;
        b=GgeEf5g5ykpI5MAk24OIMq4lJo2NMR3CT6BzKj+Ma4rhYN7whocYg/AA2zJVv/vqjU86df
        ytwHTKnfXO8vDaZwQJJiGmlQIdvfWMwKWB4QPj41H62VRGue18kIUwX8Kxj1CXXc1mnMxM
        cqVCVXBk+sOSgE98kwZFALXUtfcUXJe/gvtVvdtzgRPrAhnHn1VUtq3ba1uLXYPSJvEPfh
        fr/M4ytPgwgYfh54wC43ai+GXsjqfG6qiwIM66wzLYq9UZIM+zAOX5/iZEqDxyCLMrV1aw
        v1ai/NKF/wHMmykQ0TC6H9vVgJoaWCr4N9hbm5IwG3KWRra/7Jkn/xDE2Ew3gA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628602880;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MvqNAUK9CzyqMGlZRxuxmPHmqua1EIZDIwIvRqbZ9Bk=;
        b=LnsEQIXg9/53TLmragVDvux0mbaSzlQs9tg4WttdGZWQ1zic2s6UMeFdCoYGZHGM4oLrM/
        k3NuyIRnzKl6qoBg==
From:   "tip-bot2 for Ben Dai" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/timings: Prevent potential array overflow in
 __irq_timings_store()
Cc:     Ben Dai <ben.dai@unisoc.com>, Thomas Gleixner <tglx@linutronix.de>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20210425150903.25456-1-ben.dai9703@gmail.com>
References: <20210425150903.25456-1-ben.dai9703@gmail.com>
MIME-Version: 1.0
Message-ID: <162860287930.395.16257613336849312790.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     b9cc7d8a4656a6e815852c27ab50365009cb69c1
Gitweb:        https://git.kernel.org/tip/b9cc7d8a4656a6e815852c27ab50365009cb69c1
Author:        Ben Dai <ben.dai@unisoc.com>
AuthorDate:    Sun, 25 Apr 2021 23:09:03 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 15:39:00 +02:00

genirq/timings: Prevent potential array overflow in __irq_timings_store()

When the interrupt interval is greater than 2 ^ PREDICTION_BUFFER_SIZE *
PREDICTION_FACTOR us and less than 1s, the calculated index will be greater
than the length of irqs->ema_time[]. Check the calculated index before
using it to prevent array overflow.

Fixes: 23aa3b9a6b7d ("genirq/timings: Encapsulate storing function")
Signed-off-by: Ben Dai <ben.dai@unisoc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210425150903.25456-1-ben.dai9703@gmail.com

---
 kernel/irq/timings.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/irq/timings.c b/kernel/irq/timings.c
index d309d6f..4d2a702 100644
--- a/kernel/irq/timings.c
+++ b/kernel/irq/timings.c
@@ -453,6 +453,11 @@ static __always_inline void __irq_timings_store(int irq, struct irqt_stat *irqs,
 	 */
 	index = irq_timings_interval_index(interval);
 
+	if (index > PREDICTION_BUFFER_SIZE - 1) {
+		irqs->count = 0;
+		return;
+	}
+
 	/*
 	 * Store the index as an element of the pattern in another
 	 * circular array.
