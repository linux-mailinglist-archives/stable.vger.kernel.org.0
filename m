Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5BC6895DD
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjBCKXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjBCKXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:23:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9E893AD9
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:22:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D386C61EBA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0FBC433D2;
        Fri,  3 Feb 2023 10:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419761;
        bh=u5Lh3XxPp/bEQRYtiA+eQoiY+oLFhqf3dNatHenyPYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pP9gIwfOu7hlaA9OOpQXa5aRlOoydfyY5yE5nguctCyYAeeTzeh48W5CQhCzpg0Ev
         TeVeos8PpXSaHsWe7LSQoa6/IW3lKEeDGITVZ8TmVcBckJ7ZjF7LOW7vMj3Ox7yWMl
         2gOHyhKo1uIFfDAHspeUuEAndoOKATJhMXO27hdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wedson Almeida Filho <wedsonaf@gmail.com>,
        Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH 6.1 27/28] rust: print: avoid evaluating arguments in `pr_*` macros in `unsafe` blocks
Date:   Fri,  3 Feb 2023 11:13:15 +0100
Message-Id: <20230203101011.104115185@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miguel Ojeda <ojeda@kernel.org>

commit 6618d69aa129a8fc613e64775d5019524c6f231b upstream.

At the moment it is possible to perform unsafe operations in
the arguments of `pr_*` macros since they are evaluated inside
an `unsafe` block:

    let x = &10u32 as *const u32;
    pr_info!("{}", *x);

In other words, this is a soundness issue.

Fix it so that it requires an explicit `unsafe` block.

Reported-by: Wedson Almeida Filho <wedsonaf@gmail.com>
Reported-by: Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
Link: https://github.com/Rust-for-Linux/linux/issues/479
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/print.rs |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -115,17 +115,24 @@ pub unsafe fn call_printk(
 macro_rules! print_macro (
     // The non-continuation cases (most of them, e.g. `INFO`).
     ($format_string:path, $($arg:tt)+) => (
-        // SAFETY: This hidden macro should only be called by the documented
-        // printing macros which ensure the format string is one of the fixed
-        // ones. All `__LOG_PREFIX`s are null-terminated as they are generated
-        // by the `module!` proc macro or fixed values defined in a kernel
-        // crate.
-        unsafe {
-            $crate::print::call_printk(
-                &$format_string,
-                crate::__LOG_PREFIX,
-                format_args!($($arg)+),
-            );
+        // To remain sound, `arg`s must be expanded outside the `unsafe` block.
+        // Typically one would use a `let` binding for that; however, `format_args!`
+        // takes borrows on the arguments, but does not extend the scope of temporaries.
+        // Therefore, a `match` expression is used to keep them around, since
+        // the scrutinee is kept until the end of the `match`.
+        match format_args!($($arg)+) {
+            // SAFETY: This hidden macro should only be called by the documented
+            // printing macros which ensure the format string is one of the fixed
+            // ones. All `__LOG_PREFIX`s are null-terminated as they are generated
+            // by the `module!` proc macro or fixed values defined in a kernel
+            // crate.
+            args => unsafe {
+                $crate::print::call_printk(
+                    &$format_string,
+                    crate::__LOG_PREFIX,
+                    args,
+                );
+            }
         }
     );
 );


