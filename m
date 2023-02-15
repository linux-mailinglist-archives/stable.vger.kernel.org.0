Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13CF6982BC
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 18:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBORzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 12:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBORzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 12:55:13 -0500
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38C21C596;
        Wed, 15 Feb 2023 09:55:10 -0800 (PST)
Date:   Wed, 15 Feb 2023 17:55:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1676483705; x=1676742905;
        bh=/JN56BWgCEKzWRC08wYWK2eiKTWpvLNmRreZjnISt60=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=RYCzRgDdFIT7zHrcZblr68yaiCoYd260RO97y9EmP4A0bHVdDp3CinvOU9KbwmUEM
         WmlDnIea4WhuhH098w8ocrTB/DedyoWJDwwJc7OY/AkpW743hf492u7iDKc4cu9ZI9
         Xp29OdBixhjN+k7FzsH/hWmmMhB9hbE9qEBswx6hlEFSiy6KUZaU+VSKbMeogQWJzO
         iPX04bfhw6/yK61bXU3JpDyX2vweT9xrvTzBCI6Rl6bk/dvaGuGwHzMHRp+l++xw5e
         9qp3dPgg+XFkImY9tQlWg+9mpe6irDTN3w2+JsKqvQTlG2syHe7MTAhXfmf5vlO8tO
         jyaot0ldHGz9w==
To:     David Gow <davidgow@google.com>
From:   =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc:     Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] rust: kernel: Mark rust_fmt_argument as extern "C"
Message-ID: <wwIvK-PQ1cuvgLu7VlX_kR2Re7O4IZ_czCWYKQ6BevpEE-rW8OKdXhh5aSpZaZxoAsbMx37508f_7SzbKOd1xEMvYYlsVkNET4fliKbH7ac=@protonmail.com>
In-Reply-To: <20230214224735.264894-1-davidgow@google.com>
References: <20230214224735.264894-1-davidgow@google.com>
Feedback-ID: 27884398:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, February 14th, 2023 at 23:47, David Gow <davidgow@google.com> w=
rote:

> The rust_fmt_argument function is called from printk() to handle the %pA
> format specifier.
>=20
> Since it's called from C, we should mark it extern "C" to make sure it's
> ABI compatible.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 247b365dc8dc ("rust: add `kernel` crate")
> Signed-off-by: David Gow davidgow@google.com

Reviewed-by: Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>

>=20
> ---
>=20
> See discussion in:
> https://github.com/Rust-for-Linux/linux/pull/967
> and
> https://github.com/Rust-for-Linux/linux/pull/966
>=20
> ---
>  rust/kernel/print.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
> index 30103325696d..ec457f0952fe 100644
> --- a/rust/kernel/print.rs
> +++ b/rust/kernel/print.rs
> @@ -18,7 +18,7 @@ use crate::bindings;
>=20
>  // Called from `vsprintf` with format specifier `%pA`.
>  #[no_mangle]
> -unsafe fn rust_fmt_argument(buf: *mut c_char, end: *mut c_char, ptr: *co=
nst c_void) -> *mut c_char {
> +unsafe extern "C" fn rust_fmt_argument(buf: *mut c_char, end: *mut c_cha=
r, ptr: *const c_void) -> *mut c_char {
>      use fmt::Write;
>      // SAFETY: The C contract guarantees that `buf` is valid if it's les=
s than `end`.
>      let mut w =3D unsafe { RawFormatter::from_ptrs(buf.cast(), end.cast(=
)) };
> --
> 2.39.1.581.gbfd45094c4-goog
