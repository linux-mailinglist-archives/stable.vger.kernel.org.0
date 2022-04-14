Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D86A50113B
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245142AbiDNNnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344070AbiDNNaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06471D64;
        Thu, 14 Apr 2022 06:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9C07B82941;
        Thu, 14 Apr 2022 13:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A1BC385A5;
        Thu, 14 Apr 2022 13:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942853;
        bh=3iLHWJ9oMVew3w5dKq0ip6r7rm2TZisUU8LmVzgiauw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7k3P2BWe17RxE0zu+J5sdXgINRDGXvMbcZNgvGD2JF7pBy03W/Ii1bpn0C3bJVXU
         2Rxr4e+NU3X0+5svb+4Z+NU3eTS130Ho8phge3y7vjvpYHNAH3aIt6NCdmyTLSVWid
         qpmoXv3ioH7Y1E+sCZGtqht+nCEjqS+rQfT9Zqds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 245/338] mm/mmap: return 1 from stack_guard_gap __setup() handler
Date:   Thu, 14 Apr 2022 15:12:28 +0200
Message-Id: <20220414110845.864034268@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Randy Dunlap <rdunlap@infradead.org>

commit e6d094936988910ce6e8197570f2753898830081 upstream.

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; it just pollutes init's
environment).  This prevents:

  Unknown kernel command line parameters \
  "BOOT_IMAGE=/boot/bzImage-517rc5 stack_guard_gap=100", will be \
  passed to user space.

  Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     stack_guard_gap=100

Return 1 to indicate that the boot option has been handled.

Note that there is no warning message if someone enters:
	stack_guard_gap=anything_invalid
and 'val' and stack_guard_gap are both set to 0 due to the use of
simple_strtoul(). This could be improved by using kstrtoxxx() and
checking for an error.

It appears that having stack_guard_gap == 0 is valid (if unexpected) since
using "stack_guard_gap=0" on the kernel command line does that.

Link: https://lkml.kernel.org/r/20220222005817.11087-1-rdunlap@infradead.org
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: 1be7107fbe18e ("mm: larger stack guard gap, between vmas")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2469,7 +2469,7 @@ static int __init cmdline_parse_stack_gu
 	if (!*endptr)
 		stack_guard_gap = val << PAGE_SHIFT;
 
-	return 0;
+	return 1;
 }
 __setup("stack_guard_gap=", cmdline_parse_stack_guard_gap);
 


