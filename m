Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD21658D9D
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 14:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiL2Nor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 08:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiL2NoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 08:44:18 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EC5280;
        Thu, 29 Dec 2022 05:44:16 -0800 (PST)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1672321453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ONVoAOSV4R74Fcc+S7klnQwitE7KOgWX9DTWXdoRQo0=;
        b=TXVDMhPJGL1QCQYUmQxrJxkU/cypzAG1uj6UUvbwCzsXTADl0sr21wzpVAog+QM9x2iJo4
        P+4oDQub8fT4ZCwg74hqVrTA1HXclyuPqL+Qhrz9vXHJ1N0m+Zz31b9t8e382J+34Oy7Ct
        saOOgoK8aqg4YdOYU7lbfG4MUTmC+tJZ/khpoRJuvQwsU4GPbu8J8vn8eZfzuJJ5x7oGMl
        02RHJ23JJ6x/sfVcX2dlYTiWVFTp6J71bOtOoVKgkGMYQbtzEJMJkP6gQUoh0lDy6rVm8l
        2vShLjYpSiVzioTj9ycGy7eoFmN8DGyF7OEb+GcuJ2cDfO+jc0lNE8qbm3GQ7g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1672321453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ONVoAOSV4R74Fcc+S7klnQwitE7KOgWX9DTWXdoRQo0=;
        b=DB3b0cWA02D46fic+goYCvu+45MlQLaUlbBt0nfXLXaSAlWlRPKVkCxgo3+sXPj+TLlwCI
        gAz9sAAlYmgnGsAg==
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
        linux-doc@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] docs: gdbmacros: print newest record
Date:   Thu, 29 Dec 2022 14:49:39 +0106
Message-Id: <20221229134339.197627-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,INVALID_DATE_TZ_ABSURD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

@head_id points to the newest record, but the printing loop
exits when it increments to this value (before printing).

Exit the printing loop after the newest record has been printed.

The python-based function in scripts/gdb/linux/dmesg.py already
does this correctly.

Fixes: e60768311af8 ("scripts/gdb: update for lockless printk ringbuffer")
Cc: stable@vger.kernel.org
Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 Documentation/admin-guide/kdump/gdbmacros.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kdump/gdbmacros.txt b/Documentation/admin-guide/kdump/gdbmacros.txt
index 82aecdcae8a6..030de95e3e6b 100644
--- a/Documentation/admin-guide/kdump/gdbmacros.txt
+++ b/Documentation/admin-guide/kdump/gdbmacros.txt
@@ -312,10 +312,10 @@ define dmesg
 			set var $prev_flags = $info->flags
 		end
 
-		set var $id = ($id + 1) & $id_mask
 		if ($id == $end_id)
 			loop_break
 		end
+		set var $id = ($id + 1) & $id_mask
 	end
 end
 document dmesg

base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
-- 
2.30.2

