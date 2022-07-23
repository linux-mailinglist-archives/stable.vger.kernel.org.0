Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973F157ED90
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbiGWJ7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237610AbiGWJ6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:58:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6F369F0D;
        Sat, 23 Jul 2022 02:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5243B82C21;
        Sat, 23 Jul 2022 09:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27074C341C0;
        Sat, 23 Jul 2022 09:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570255;
        bh=wGMNTjp6VPYf7orV8ztNuBdmDKJ1DhLEaFQidTOFZH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9CUGOijz/iAcsS2qR9fd5VB8yYw5N0xDRFJxoUAdcOEHTN9r0mEcuU0fIQbMKiWR
         AYbJ6wLHZgxvXhH6tGdAtznNUAmBl50k67+Jq43mrcRMzvu3xAu9T9qG8p8/bBL15+
         ItokoVG8HMAbsOD0hCsm/0ovkN2J9HGhC5U7u85o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 033/148] objtool: Skip magical retpoline .altinstr_replacement
Date:   Sat, 23 Jul 2022 11:54:05 +0200
Message-Id: <20220723095233.591415325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 50e7b4a1a1b264fc7df0698f2defb93cadf19a7b upstream.

When the .altinstr_replacement is a retpoline, skip the alternative.
We already special case retpolines anyway.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Link: https://lkml.kernel.org/r/20210326151300.259429287@infradead.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/special.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -104,6 +104,14 @@ static int get_alt_entry(struct elf *elf
 			return -1;
 		}
 
+		/*
+		 * Skip retpoline .altinstr_replacement... we already rewrite the
+		 * instructions for retpolines anyway, see arch_is_retpoline()
+		 * usage in add_{call,jump}_destinations().
+		 */
+		if (arch_is_retpoline(new_reloc->sym))
+			return 1;
+
 		alt->new_sec = new_reloc->sym->sec;
 		alt->new_off = (unsigned int)new_reloc->addend;
 
@@ -152,7 +160,9 @@ int special_get_alts(struct elf *elf, st
 			memset(alt, 0, sizeof(*alt));
 
 			ret = get_alt_entry(elf, entry, sec, idx, alt);
-			if (ret)
+			if (ret > 0)
+				continue;
+			if (ret < 0)
 				return ret;
 
 			list_add_tail(&alt->list, alts);


