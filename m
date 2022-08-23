Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7367B59DC72
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbiHWLLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357262AbiHWLKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:10:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81819B6D06;
        Tue, 23 Aug 2022 02:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5960060F85;
        Tue, 23 Aug 2022 09:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED9BC433D6;
        Tue, 23 Aug 2022 09:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246225;
        bh=b09QnvDg7xfHPslMRVg7vHUSCPbJTeYQlqKvtTja7U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAwaf9ljDuOcApSQWmSmwzRRRpLZW3pJVsfBndEDTTnt5l38BsChcjim3Gq9w6TpP
         w5ve/lkQj6a4HPKkZpFPDVlvuGJx9FbQMEHM4Gxth4fkYjmxpaaLfg9NlCTzmJj9/M
         84I0KGz4fd+Eo/HpTyH+TdqhwHVY35jNheGN6o7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 042/389] powerpc/powernv: Avoid crashing if rng is NULL
Date:   Tue, 23 Aug 2022 10:22:00 +0200
Message-Id: <20220823080117.372655712@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -63,6 +63,8 @@ int powernv_get_random_real_mode(unsigne
 	struct powernv_rng *rng;
 
 	rng = raw_cpu_read(powernv_rng);
+	if (!rng)
+		return 0;
 
 	*v = rng_whiten(rng, __raw_rm_readq(rng->regs_real));
 


