Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65F36433BC
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiLETjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiLETiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7AA2A403
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E8DDB81157
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63836C433D7;
        Mon,  5 Dec 2022 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268946;
        bh=JvmiSyaxlLqnmxUfrXlgh44m+y2++kkJohwZzrE+Cvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGx9qpMBmfIKzalxx00RICC4b0NKZuGYwCpCD5DAZO+OqEVjdHsGU6yrWfyleoPuX
         d9vIZLG8pqyTVhoEONWZiwFmYzUsluEdvnV2ulctKO6LiFpi2748WDmEeXb+u/e/KU
         hWHmWWMCPjrqP5/x1dkib00uvRHtIEBab7H/YVaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 069/120] error-injection: Add prompt for function error injection
Date:   Mon,  5 Dec 2022 20:10:09 +0100
Message-Id: <20221205190808.698949739@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit a4412fdd49dc011bcc2c0d81ac4cab7457092650 upstream.

The config to be able to inject error codes into any function annotated
with ALLOW_ERROR_INJECTION() is enabled when FUNCTION_ERROR_INJECTION is
enabled.  But unfortunately, this is always enabled on x86 when KPROBES
is enabled, and there's no way to turn it off.

As kprobes is useful for observability of the kernel, it is useful to
have it enabled in production environments.  But error injection should
be avoided.  Add a prompt to the config to allow it to be disabled even
when kprobes is enabled, and get rid of the "def_bool y".

This is a kernel debug feature (it's in Kconfig.debug), and should have
never been something enabled by default.

Cc: stable@vger.kernel.org
Fixes: 540adea3809f6 ("error-injection: Separate error-injection from kprobe")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1872,8 +1872,14 @@ config NETDEV_NOTIFIER_ERROR_INJECT
 	  If unsure, say N.
 
 config FUNCTION_ERROR_INJECTION
-	def_bool y
+	bool "Fault-injections of functions"
 	depends on HAVE_FUNCTION_ERROR_INJECTION && KPROBES
+	help
+	  Add fault injections into various functions that are annotated with
+	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
+	  value of theses functions. This is useful to test error paths of code.
+
+	  If unsure, say N
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"


