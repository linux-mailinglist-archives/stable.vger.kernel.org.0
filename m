Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9ECC31362E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhBHPHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233002AbhBHPFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:05:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5837264EB6;
        Mon,  8 Feb 2021 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796635;
        bh=pp/6OyV+65kPiDzgroOMAzbZu47iwdhzlM6DTuP4c98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hM0OF7PRLZJMtNgZdJyD4jIi9vugC+AHAR1ayIM79SoGQaNQmMHn/37ujhGZ9JLRN
         rQpITncI4AHxJf9iqkvHochFC+WgzrXiDApAPCiZ1D6LimDrqGGL+t1abr37mzj7Aa
         TC3FdwCdYq4/aW/is+u9+2DfmHvIR4+5Efuy0DNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 11/43] futex: Use pi_state_update_owner() in put_pi_state()
Date:   Mon,  8 Feb 2021 16:00:37 +0100
Message-Id: <20210208145806.763930801@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 6ccc84f917d33312eb2846bd7b567639f585ad6d ]

No point in open coding it. This way it gains the extra sanity checks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -879,10 +879,7 @@ static void put_pi_state(struct futex_pi
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
-		raw_spin_lock_irq(&pi_state->owner->pi_lock);
-		list_del_init(&pi_state->list);
-		raw_spin_unlock_irq(&pi_state->owner->pi_lock);
-
+		pi_state_update_owner(pi_state, NULL);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 	}
 


