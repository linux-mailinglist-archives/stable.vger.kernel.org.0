Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2010E6ECDE8
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjDXN2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjDXN1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819316596
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 159BC622E4
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288B8C433D2;
        Mon, 24 Apr 2023 13:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342856;
        bh=0Sm3/m/sbl6YkZnwnL8cRMncGNL49HXMeMUIbD4wg4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSdKSm3TL2KZb8tcgOlui5uGRMlz/vqYpKwSMp7DFrU4VPlzRcN7NMJGZjlIyrlL8
         YN3rqIxCvu4ebjomU3tTLUYq0nQOuPyQnNFpJbm9BGuOHPob64rdJYBQ8dDDFqNiXV
         Xg0eVNATzMg2ZbjFxKYWbmzxxNLVlMtfkY6L04LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Gow <davidgow@google.com>,
        Gary Guo <gary@garyguo.net>,
        =?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 55/98] rust: kernel: Mark rust_fmt_argument as extern "C"
Date:   Mon, 24 Apr 2023 15:17:18 +0200
Message-Id: <20230424131135.993216732@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

commit c682e4c37d2b8ba3bde1125cbbea4ee88824b4e2 upstream.

The rust_fmt_argument function is called from printk() to handle the %pA
format specifier.

Since it's called from C, we should mark it extern "C" to make sure it's
ABI compatible.

Cc: stable@vger.kernel.org
Fixes: 247b365dc8dc ("rust: add `kernel` crate")
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
[Applied `rustfmt`]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/print.rs |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -18,7 +18,11 @@ use crate::bindings;
 
 // Called from `vsprintf` with format specifier `%pA`.
 #[no_mangle]
-unsafe fn rust_fmt_argument(buf: *mut c_char, end: *mut c_char, ptr: *const c_void) -> *mut c_char {
+unsafe extern "C" fn rust_fmt_argument(
+    buf: *mut c_char,
+    end: *mut c_char,
+    ptr: *const c_void,
+) -> *mut c_char {
     use fmt::Write;
     // SAFETY: The C contract guarantees that `buf` is valid if it's less than `end`.
     let mut w = unsafe { RawFormatter::from_ptrs(buf.cast(), end.cast()) };


