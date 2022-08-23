Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DA259E1AF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351179AbiHWKr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355840AbiHWKpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:45:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67A0275E0;
        Tue, 23 Aug 2022 02:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F12AB81C4E;
        Tue, 23 Aug 2022 09:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F310FC433D6;
        Tue, 23 Aug 2022 09:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245861;
        bh=0Jt2oS8ajL4CdGUQpCZ3kNZmqzcv3sKuganqUxlGuhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIoboEmjQunT864OtrG3GjX3cWL/9mOW8zp136Dza2RIbluvL2us6Smtqb5vvld7C
         R7grxUlwdi/CPIi6f5UQouzAJQ0yKxDokM2dJwZOi0eKnWeFc2oy1zPf2CiWAz6tWT
         u6g0AlF6zzgYno5lryFS+NZ05twP/E0dPMXG4jmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 214/287] powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E
Date:   Tue, 23 Aug 2022 10:26:23 +0200
Message-Id: <20220823080108.163917288@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit dd8de84b57b02ba9c1fe530a6d916c0853f136bd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/dump_linuxpagetables-generic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/dump_linuxpagetables-generic.c
+++ b/arch/powerpc/mm/dump_linuxpagetables-generic.c
@@ -17,9 +17,9 @@ static const struct flag_info flag_array
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
 #ifndef CONFIG_PPC_BOOK3S_32
 		.mask	= _PAGE_EXEC,


