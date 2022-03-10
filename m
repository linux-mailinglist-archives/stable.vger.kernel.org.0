Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81EB4D4A4E
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244212AbiCJOdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343658AbiCJObK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3290BA1458;
        Thu, 10 Mar 2022 06:27:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCC1AB82615;
        Thu, 10 Mar 2022 14:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDAEC340E8;
        Thu, 10 Mar 2022 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922431;
        bh=gatLyyLi4/uk4jBszPH9iqAzyHrO/4OkvoeFYT6BEfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofHNKbIMN1QQGEu246ipJemD/S1/6oiMEwuZdy0G1XLrD6hSpHFCF4wF0pMwIdDP9
         3WaDzuuPyTyEZ3sg2ewimtBQJ7AGV8kbpjdOxIjI063/BDxCI6ttCC3JFw0roCu6De
         z2z8OC9WZel2AMCilyCLnAS99invYY4lPirGwsfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 02/33] x86,bugs: Unconditionally allow spectre_v2=retpoline,amd
Date:   Thu, 10 Mar 2022 15:19:03 +0100
Message-Id: <20220310140808.814122420@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit f8a66d608a3e471e1202778c2a36cbdc96bae73b upstream.

Currently Linux prevents usage of retpoline,amd on !AMD hardware, this
is unfriendly and gets in the way of testing. Remove this restriction.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120310.487348118@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -839,13 +839,6 @@ static enum spectre_v2_mitigation_cmd __
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
-	if (cmd == SPECTRE_V2_CMD_RETPOLINE_AMD &&
-	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON &&
-	    boot_cpu_data.x86_vendor != X86_VENDOR_AMD) {
-		pr_err("retpoline,amd selected but CPU is not AMD. Switching to AUTO select\n");
-		return SPECTRE_V2_CMD_AUTO;
-	}
-
 	spec_v2_print_cond(mitigation_options[i].option,
 			   mitigation_options[i].secure);
 	return cmd;


