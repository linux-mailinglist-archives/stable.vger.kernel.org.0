Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436F957230F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiGLSmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiGLSmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CA9D7BAD;
        Tue, 12 Jul 2022 11:41:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F34361AD2;
        Tue, 12 Jul 2022 18:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2261EC3411C;
        Tue, 12 Jul 2022 18:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651297;
        bh=wGMNTjp6VPYf7orV8ztNuBdmDKJ1DhLEaFQidTOFZH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2sBWAO7+FwuRQbmKIJu7a9ISk1Qu+bGCSRQV+EOHryT9qiF+9i6bhFOCPMpiR02k
         O2nlQRjXbT7FHvXahCkS5zoHaqPlo2Ut//u13AbU8CIthI8hJA+zuwhSt2YgONH5Iq
         I83sM7vxrZeIFwk8OvOZcPTNFjkVxMXWhN9nzJNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 033/130] objtool: Skip magical retpoline .altinstr_replacement
Date:   Tue, 12 Jul 2022 20:37:59 +0200
Message-Id: <20220712183247.926163688@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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


