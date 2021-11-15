Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1F7451E88
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243399AbhKPAg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345061AbhKOT0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0289F60EE4;
        Mon, 15 Nov 2021 19:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003370;
        bh=jEsPN6D0hFl/Ft7hVzroBX7+X1zeddaqnRqUwQ8bxt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzO63pA926uat/asZyROZrFevyytguWFqqdtbrsTVXCBKTInbIs4KPCPO090nvrvR
         vm33GRYj7hqRzq3titROkJJhTzry/RD2MSt25sdueyoQwS8Hlb1Hv0C8qlxHuEtbUk
         oKmQTFSIQBMsCvQ11Bjbdewc85p/aFfyjyAExFSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell Currey <ruscur@russell.cc>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 909/917] powerpc/security: Use a mutex for interrupt exit code patching
Date:   Mon, 15 Nov 2021 18:06:44 +0100
Message-Id: <20211115165459.863700428@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell Currey <ruscur@russell.cc>

commit 3c12b4df8d5e026345a19886ae375b3ebc33c0b6 upstream.

The mitigation-patching.sh script in the powerpc selftests toggles
all mitigations on and off simultaneously, revealing that rfi_flush
and stf_barrier cannot safely operate at the same time due to races
in updating the static key.

On some systems, the static key code throws a warning and the kernel
remains functional.  On others, the kernel will hang or crash.

Fix this by slapping on a mutex.

Fixes: 13799748b957 ("powerpc/64: use interrupt restart table to speed up return from interrupt")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Russell Currey <ruscur@russell.cc>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211027072410.40950-1-ruscur@russell.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/feature-fixups.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -228,6 +228,7 @@ static void do_stf_exit_barrier_fixups(e
 
 static bool stf_exit_reentrant = false;
 static bool rfi_exit_reentrant = false;
+static DEFINE_MUTEX(exit_flush_lock);
 
 static int __do_stf_barrier_fixups(void *data)
 {
@@ -253,6 +254,9 @@ void do_stf_barrier_fixups(enum stf_barr
 	 * low level interrupt exit code before patching. After the patching,
 	 * if allowed, then flip the branch to allow fast exits.
 	 */
+
+	// Prevent static key update races with do_rfi_flush_fixups()
+	mutex_lock(&exit_flush_lock);
 	static_branch_enable(&interrupt_exit_not_reentrant);
 
 	stop_machine(__do_stf_barrier_fixups, &types, NULL);
@@ -264,6 +268,8 @@ void do_stf_barrier_fixups(enum stf_barr
 
 	if (stf_exit_reentrant && rfi_exit_reentrant)
 		static_branch_disable(&interrupt_exit_not_reentrant);
+
+	mutex_unlock(&exit_flush_lock);
 }
 
 void do_uaccess_flush_fixups(enum l1d_flush_type types)
@@ -486,6 +492,9 @@ void do_rfi_flush_fixups(enum l1d_flush_
 	 * without stop_machine, so this could be achieved with a broadcast
 	 * IPI instead, but this matches the stf sequence.
 	 */
+
+	// Prevent static key update races with do_stf_barrier_fixups()
+	mutex_lock(&exit_flush_lock);
 	static_branch_enable(&interrupt_exit_not_reentrant);
 
 	stop_machine(__do_rfi_flush_fixups, &types, NULL);
@@ -497,6 +506,8 @@ void do_rfi_flush_fixups(enum l1d_flush_
 
 	if (stf_exit_reentrant && rfi_exit_reentrant)
 		static_branch_disable(&interrupt_exit_not_reentrant);
+
+	mutex_unlock(&exit_flush_lock);
 }
 
 void do_barrier_nospec_fixups_range(bool enable, void *fixup_start, void *fixup_end)


