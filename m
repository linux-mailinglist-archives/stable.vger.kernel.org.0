Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9597557EE60
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbiGWKKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239469AbiGWKJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A428049C;
        Sat, 23 Jul 2022 03:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CE70B82C1F;
        Sat, 23 Jul 2022 10:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B67C341C0;
        Sat, 23 Jul 2022 10:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570568;
        bh=lqnSkCXXiV+5UZ7xk1zTCH+Z/JTRzCyyNJlN1tBUpOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1hp6y/iDqo9fN9wiyrOHzM2+x7ptinJqwDL60ewCbyYG+KMpn6VpziqqKy/R+sN5
         CvHnoqNzSKckDeZTTqfvf4j4myAzLNxX/7EWxjcODGAcfpeOW4IA35NGfq8yPh9WCY
         RaQz/ykCGqIvW13tXWuteKS3mwT7YTwP1tOagNv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Borislav Petkov <bp@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.10 131/148] tools/insn: Restore the relative include paths for cross building
Date:   Sat, 23 Jul 2022 11:55:43 +0200
Message-Id: <20220723095301.021493138@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

commit 0705ef64d1ff52b817e278ca6e28095585ff31e1 upstream.

Building perf on ppc causes:

  In file included from util/intel-pt-decoder/intel-pt-insn-decoder.c:15:
  util/intel-pt-decoder/../../../arch/x86/lib/insn.c:14:10: fatal error: asm/inat.h: No such file or directory
     14 | #include <asm/inat.h> /*__ignore_sync_check__ */
        |          ^~~~~~~~~~~~

Restore the relative include paths so that the compiler can find the
headers.

Fixes: 93281c4a9657 ("x86/insn: Add an insn_decode() API")
Reported-by: Ian Rogers <irogers@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Ian Rogers <irogers@google.com>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lkml.kernel.org/r/20210317150858.02b1bbc8@canb.auug.org.au
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/arch/x86/lib/insn.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/arch/x86/lib/insn.c
+++ b/tools/arch/x86/lib/insn.c
@@ -10,13 +10,13 @@
 #else
 #include <string.h>
 #endif
-#include <asm/inat.h> /* __ignore_sync_check__ */
-#include <asm/insn.h> /* __ignore_sync_check__ */
+#include "../include/asm/inat.h" /* __ignore_sync_check__ */
+#include "../include/asm/insn.h" /* __ignore_sync_check__ */
 
 #include <linux/errno.h>
 #include <linux/kconfig.h>
 
-#include <asm/emulate_prefix.h> /* __ignore_sync_check__ */
+#include "../include/asm/emulate_prefix.h" /* __ignore_sync_check__ */
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\


