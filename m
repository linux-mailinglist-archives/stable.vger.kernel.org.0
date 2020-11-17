Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23E92B610C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgKQNPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729619AbgKQNPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:15:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51A5D2151B;
        Tue, 17 Nov 2020 13:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618911;
        bh=OtI9tf6XW0TUEG9IyE0w34zCVQ3hCGoM5zEvrZjH3es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dcz1FW8CRK+J/I+BZ+8ivdWCfJyqagQDKQodfp4yJwVXkmDc59jZR0dY1a/npUZ0O
         nGy5+f3ciDFmDbI5MiKU7JPf0b8WAKL2dN06deZPo5nbIc6oKoQc6sAX+SzloG8hbr
         FhS9T2hqt+YJ2iPS1xlDeFRi14HH+9nLV1wlcp2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.14 50/85] futex: Dont enable IRQs unconditionally in put_pi_state()
Date:   Tue, 17 Nov 2020 14:05:19 +0100
Message-Id: <20201117122113.485126150@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 1e106aa3509b86738769775969822ffc1ec21bf4 upstream.

The exit_pi_state_list() function calls put_pi_state() with IRQs disabled
and is not expecting that IRQs will be enabled inside the function.

Use the _irqsave() variant so that IRQs are restored to the original state
instead of being enabled unconditionally.

Fixes: 153fbd1226fb ("futex: Fix more put_pi_state() vs. exit_pi_state_list() races")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201106085205.GA1159983@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -862,8 +862,9 @@ static void put_pi_state(struct futex_pi
 	 */
 	if (pi_state->owner) {
 		struct task_struct *owner;
+		unsigned long flags;
 
-		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
 		owner = pi_state->owner;
 		if (owner) {
 			raw_spin_lock(&owner->pi_lock);
@@ -871,7 +872,7 @@ static void put_pi_state(struct futex_pi
 			raw_spin_unlock(&owner->pi_lock);
 		}
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex, owner);
-		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
 	}
 
 	if (current->pi_state_cache) {


