Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26E52010BF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393704AbgFSPdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404939AbgFSPdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:33:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B582166E;
        Fri, 19 Jun 2020 15:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580787;
        bh=eDxLH4ouDqLNWQDr9hjpdo2YNXdlxYjycEeNZepbj/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qB1l/4nkd9ytutk2NFY6D40kEZSm7JhdmJ0ugO9N//SwrFFaOMnwBoh94W/0bmGK/
         5AqaomU3oBpb3aWGwUBFJl8zSlHsS/P+4WLhlZ+k/+XXf84radF6n5UE73FfINnfwW
         USdigQb6/2GxQ2xzDw7eUFOj54pBDMgtfayK7RkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.7 342/376] powerpc/64s: Dont let DT CPU features set FSCR_DSCR
Date:   Fri, 19 Jun 2020 16:34:20 +0200
Message-Id: <20200619141726.521924280@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 993e3d96fd08c3ebf7566e43be9b8cd622063e6d upstream.

The device tree CPU features binding includes FSCR bit numbers which
Linux is instructed to set by firmware.

Whether that's a good idea or not, in the case of the DSCR the Linux
implementation has a hard requirement that the FSCR_DSCR bit not be
set by default. We use it to track when a process reads/writes to
DSCR, so it must be clear to begin with.

So if firmware tells us to set FSCR_DSCR we must ignore it.

Currently this does not cause a bug in our DSCR handling because the
value of FSCR that the device tree CPU features code establishes is
only used by swapper. All other tasks use the value hard coded in
init_task.thread.fscr.

However we'd like to fix that in a future commit, at which point this
will become necessary.

Fixes: 5a61ef74f269 ("powerpc/64s: Support new device tree binding for discovering CPU features")
Cc: stable@vger.kernel.org # v4.12+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200527145843.2761782-2-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/dt_cpu_ftrs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -346,6 +346,14 @@ static int __init feat_enable_dscr(struc
 {
 	u64 lpcr;
 
+	/*
+	 * Linux relies on FSCR[DSCR] being clear, so that we can take the
+	 * facility unavailable interrupt and track the task's usage of DSCR.
+	 * See facility_unavailable_exception().
+	 * Clear the bit here so that feat_enable() doesn't set it.
+	 */
+	f->fscr_bit_nr = -1;
+
 	feat_enable(f);
 
 	lpcr = mfspr(SPRN_LPCR);


