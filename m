Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82DC57DE81
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiGVJ2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiGVJ2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:28:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38901B5C90;
        Fri, 22 Jul 2022 02:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1A6EB827BE;
        Fri, 22 Jul 2022 09:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E3DC341C6;
        Fri, 22 Jul 2022 09:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481456;
        bh=/dc3mGi7bQmupPffWgNjejnw/63egPiFRy77Qic0Qag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YiCPFBjMFqfNBWCyvbXkJXNUXpTkmqZYFJ/P8oe5y9taN/ZSfBYIP6KGwRdv8i42
         qpr1008iLasKg3lsJ/K+KsthaGOUZNDQHtt2rco0nc4DTzC+PPt9/fW22Papx4PLYN
         mimkdiAbWcn1Ts1pOyphUdiYSG2gch1XXboTIh2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 80/89] x86/asm/32: Fix ANNOTATE_UNRET_SAFE use on 32-bit
Date:   Fri, 22 Jul 2022 11:11:54 +0200
Message-Id: <20220722091137.818560555@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 3131ef39fb03bbde237d0b8260445898f3dfda5b upstream.

The build on x86_32 currently fails after commit

  9bb2ec608a20 (objtool: Update Retpoline validation)

with:

  arch/x86/kernel/../../x86/xen/xen-head.S:35: Error: no such instruction: `annotate_unret_safe'

ANNOTATE_UNRET_SAFE is defined in nospec-branch.h. And head_32.S is
missing this include. Fix this.

Fixes: 9bb2ec608a20 ("objtool: Update Retpoline validation")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/63e23f80-033f-f64e-7522-2816debbc367@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/head_32.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -23,6 +23,7 @@
 #include <asm/cpufeatures.h>
 #include <asm/percpu.h>
 #include <asm/nops.h>
+#include <asm/nospec-branch.h>
 #include <asm/bootparam.h>
 #include <asm/export.h>
 #include <asm/pgtable_32.h>


