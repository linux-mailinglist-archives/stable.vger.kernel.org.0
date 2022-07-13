Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DF1572EB3
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 09:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiGMHFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 03:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiGMHFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 03:05:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E471BE0F4;
        Wed, 13 Jul 2022 00:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=8cUkVHj6JMzwNeo6rQI43YJNxl4TIBWEA26ulmovh58=;
        t=1657695907; x=1658905507; b=HKRvWBdg1WuTRIqDFHVofDE0IOdUbrpfgsoohxTU1AIdxzJ
        sFTfboc1o7FklJTa+jPAu/rXmntpfE5ZXwNfvuNUwyUTGkEHZLY28MzDCfOd9+ks4C7BSBmSQcINq
        pFTD6Y0gpgGJKYWFYnWzpKkYeZj+UTmfjJ3MhafBA4xW4v5tWz/fQUy9o8a1RtjkWjt4GccbblU+D
        Fz7aWpf+vRI2NchJpoyIhQWZy4VaY+VlkgvJozavM1a/ISV8tMt/NhnjlvBoLIOD23YX+17D9R9MI
        1AgcFVNmkuj5X8HkSOzD/zuWWH7Q6DNtwjtr/j8OKvXn8ugosfqAhP0zA1S0mNNA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBWQi-00Eb1M-1d;
        Wed, 13 Jul 2022 09:05:04 +0200
Message-ID: <d2c55506bd0a93854320ce352a93303cf8080f48.camel@sipsolutions.net>
Subject: Re: [PATCH] um: seed rng using host OS rng
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Wed, 13 Jul 2022 09:05:03 +0200
In-Reply-To: <20220712232738.77737-1-Jason@zx2c4.com>
References: <20220712232738.77737-1-Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-07-13 at 01:27 +0200, Jason A. Donenfeld wrote:
>=20
> +++ b/arch/um/include/shared/os.h
> @@ -11,6 +11,12 @@
>  #include <irq_user.h>
>  #include <longjmp.h>
>  #include <mm_id.h>
> +/* This is to get size_t */
> +#ifndef __UM_HOST__
> +#include <linux/types.h>
> +#else
> +#include <stddef.h>
> +#endif
> =20
>  #define CATCH_EINTR(expr) while ((errno =3D 0, ((expr) < 0)) && (errno =
=3D=3D EINTR))
> =20
> @@ -243,6 +249,7 @@ extern void stack_protections(unsigned long address);
>  extern int raw(int fd);
>  extern void setup_machinename(char *machine_out);
>  extern void setup_hostinfo(char *buf, int len);
> +extern ssize_t os_getrandom(void *buf, size_t len, unsigned int flags);

For me, this doesn't compile, and per the man-page on my system, ssize_t
requires <sys/types.h>, not <stddef.h>?

johannes
