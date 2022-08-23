Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46859D406
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbiHWISf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243041AbiHWIQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7699D696FF;
        Tue, 23 Aug 2022 01:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB7396125C;
        Tue, 23 Aug 2022 08:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB454C433C1;
        Tue, 23 Aug 2022 08:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242256;
        bh=7JAZnDt9lcHI9LQLfpATVy4VPp1dPuVcZFLyzYVRfB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUpPF8b5Z4Co5+lkFP5mE/4Jf6upBWyTENqXNPer64L3aNsxWSMN9/sdmzRDl3iHy
         Vv/CAR0tDk69xoU1o7exmplTEQgj1zsDczLfBfSpNYpma+c9nEuSNIprXjQW4QIHyo
         enpJwmqOj/08hmNwwq8S5veMlZx+UlP2WfigbaEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 043/101] powerpc/powernv: Avoid crashing if rng is NULL
Date:   Tue, 23 Aug 2022 10:03:16 +0200
Message-Id: <20220823080036.179213506@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 90b5d4fe0b3ba7f589c6723c6bfb559d9e83956a upstream.

On a bare-metal Power8 system that doesn't have an "ibm,power-rng", a
malicious QEMU and guest that ignore the absence of the
KVM_CAP_PPC_HWRNG flag, and calls H_RANDOM anyway, will dereference a
NULL pointer.

In practice all Power8 machines have an "ibm,power-rng", but let's not
rely on that, add a NULL check and early return in
powernv_get_random_real_mode().

Fixes: e928e9cb3601 ("KVM: PPC: Book3S HV: Add fast real-mode H_RANDOM implementation.")
Cc: stable@vger.kernel.org # v4.1+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220727143219.2684192-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/rng.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -67,6 +67,8 @@ int powernv_get_random_real_mode(unsigne
 	struct powernv_rng *rng;
 
 	rng = raw_cpu_read(powernv_rng);
+	if (!rng)
+		return 0;
 
 	*v = rng_whiten(rng, in_rm64(rng->regs_real));
 


