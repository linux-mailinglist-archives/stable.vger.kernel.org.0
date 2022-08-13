Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83C1591B11
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 16:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbiHMOkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 10:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiHMOkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 10:40:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD4B4D167
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:40:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA205B80092
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 14:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F0AC433D6;
        Sat, 13 Aug 2022 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660401598;
        bh=6SBuDbaRK/jL0KHvLVRDTL494b1rEqpTq9pUIKFpk24=;
        h=Subject:To:Cc:From:Date:From;
        b=zUVRaKKh4xh4GAaps+18e1rfjTBENnOrkfvyU9nYrsWXUXIQUA5B6Bc6UgMPL3KCv
         7DMuOSehvVqw9odaLFvgqp52M/IpE5On4lAk23qEWSwJzb+N2ALoG4PL2Ei4gvoQpr
         GCBJrgULBA7LUAaqVOwsAXNYFq/XjSLgDgW6fj+g=
Subject: FAILED: patch "[PATCH] powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E" failed to apply to 4.19-stable tree
To:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 16:38:57 +0200
Message-ID: <16604015377291@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dd8de84b57b02ba9c1fe530a6d916c0853f136bd Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Tue, 28 Jun 2022 16:43:35 +0200
Subject: [PATCH] powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E

On FSL_BOOK3E, _PAGE_RW is defined with two bits, one for user and one
for supervisor. As soon as one of the two bits is set, the page has
to be display as RW. But the way it is implemented today requires both
bits to be set in order to display it as RW.

Instead of display RW when _PAGE_RW bits are set and R otherwise,
reverse the logic and display R when _PAGE_RW bits are all 0 and
RW otherwise.

This change has no impact on other platforms as _PAGE_RW is a single
bit on all of them.

Fixes: 8eb07b187000 ("powerpc/mm: Dump linux pagetables")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/0c33b96317811edf691e81698aaee8fa45ec3449.1656427391.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
index 03607ab90c66..f884760ca5cf 100644
--- a/arch/powerpc/mm/ptdump/shared.c
+++ b/arch/powerpc/mm/ptdump/shared.c
@@ -17,9 +17,9 @@ static const struct flag_info flag_array[] = {
 		.clear	= "    ",
 	}, {
 		.mask	= _PAGE_RW,
-		.val	= _PAGE_RW,
-		.set	= "rw",
-		.clear	= "r ",
+		.val	= 0,
+		.set	= "r ",
+		.clear	= "rw",
 	}, {
 		.mask	= _PAGE_EXEC,
 		.val	= _PAGE_EXEC,

