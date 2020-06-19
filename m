Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89F2201688
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389599AbgFSOwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389594AbgFSOwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:52:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20971217D8;
        Fri, 19 Jun 2020 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578353;
        bh=7JtHJ0E/i7JKdT8A4ooJDTBHYUeVrUdH4UtPO+zE0/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UM05FerQupYvdgoAKCNd3I8haeyjXjo7GjFGLm7kql7I7Hy9XVIj0+Pn8+qXre7bi
         oFmTTuO2rHA7EstRBTsKFJv7OQiQfIenUHEc02Ua+Ym+TW4oTn+F2MDhLmzypdxpHT
         1pq3ykChNjmYfxorxmbQvVRnzfLYqh0sF7G9KvnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 180/190] powerpc/64s: Dont let DT CPU features set FSCR_DSCR
Date:   Fri, 19 Jun 2020 16:33:45 +0200
Message-Id: <20200619141642.797975745@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
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
@@ -385,6 +385,14 @@ static int __init feat_enable_dscr(struc
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


