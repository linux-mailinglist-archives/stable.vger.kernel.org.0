Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C375C4F4551
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383303AbiDEMZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348675AbiDEKsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:48:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A0F63BF0;
        Tue,  5 Apr 2022 03:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3FC3B81B18;
        Tue,  5 Apr 2022 10:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527A1C385A0;
        Tue,  5 Apr 2022 10:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154437;
        bh=izMv/LMDq16sbMxK8dWa52dHpvXUUl3PEqt/CPB1xl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpslcnrkn5jN71mI9tgTGudtnm1dzUnK1+bRFc4a1204DUVbZx/9U39Q8Tci4h8+p
         UM3F7BwKL2oyl1PwbCO/FUAD1Bp4jqDGS9hWdBPpeF8/URn7jbxlhlXw2jWF2LYcny
         f/gQHogbQiym2fWAMenOAq7kbPXP9izHz8qNXLiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 579/599] mm/usercopy: return 1 from hardened_usercopy __setup() handler
Date:   Tue,  5 Apr 2022 09:34:33 +0200
Message-Id: <20220405070316.073093929@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

commit 05fe3c103f7e6b8b4fca8a7001dfc9ed4628085b upstream.

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; it just pollutes init's
environment).  This prevents:

  Unknown kernel command line parameters \
  "BOOT_IMAGE=/boot/bzImage-517rc5 hardened_usercopy=off", will be \
  passed to user space.

  Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     hardened_usercopy=off
or
     hardened_usercopy=on
but when "hardened_usercopy=foo" is used, there is no Unknown kernel
command line parameter.

Return 1 to indicate that the boot option has been handled.
Print a warning if strtobool() returns an error on the option string,
but do not mark this as in unknown command line option and do not cause
init's environment to be polluted with this string.

Link: https://lkml.kernel.org/r/20220222034249.14795-1-rdunlap@infradead.org
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: b5cb15d9372ab ("usercopy: Allow boot cmdline disabling of hardening")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Acked-by: Chris von Recklinghausen <crecklin@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/usercopy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -294,7 +294,10 @@ static bool enable_checks __initdata = t
 
 static int __init parse_hardened_usercopy(char *str)
 {
-	return strtobool(str, &enable_checks);
+	if (strtobool(str, &enable_checks))
+		pr_warn("Invalid option string for hardened_usercopy: '%s'\n",
+			str);
+	return 1;
 }
 
 __setup("hardened_usercopy=", parse_hardened_usercopy);


