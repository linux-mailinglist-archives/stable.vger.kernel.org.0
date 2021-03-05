Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1963232EAFF
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhCEMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233406AbhCEMlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:41:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A11A165022;
        Fri,  5 Mar 2021 12:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948071;
        bh=PeWfzulb+clhPBVEu08GBvUVQyZF5shtRru7TSyQ4/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObHuKLCkXvAqETFS5LS9ErBeYtpYx4QUk+nNnjTy1ogrDid03VjaSqC4pJ3D4R2IL
         1kQiDmJXsVT2vMkbEuiR0wmr+nRCJcHyOF0px6nSfLmuZNt/Rn83rnQ+dzdbIbIDK9
         no9ahAyW/ppvCGzsVdKRZH0rJJ9Q8oNiy/OQViZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 07/41] futex: Dont enable IRQs unconditionally in put_pi_state()
Date:   Fri,  5 Mar 2021 13:22:14 +0100
Message-Id: <20210305120851.638890063@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

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
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -882,10 +882,12 @@ static void put_pi_state(struct futex_pi
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
-		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
+		unsigned long flags;
+
+		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
 		pi_state_update_owner(pi_state, NULL);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
-		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
+		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
 	}
 
 	if (current->pi_state_cache) {


