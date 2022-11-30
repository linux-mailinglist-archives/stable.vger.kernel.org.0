Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2E363CF2E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 07:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiK3G2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 01:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbiK3G2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 01:28:46 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0BC1E720
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 22:28:44 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id v7-20020a4aa507000000b00496e843fdfeso2483630ook.7
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 22:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=06+BuaqCExp3OktAsqU4uEcZm4SWvo2W5juMDl91Gyw=;
        b=q4x4Lmg46LVT8Sl1uTxWib6QfCiVdMjHPanqSl1D/1dYVbivwZGjvDrUXGxxpRzaGG
         OKbpVNZKuOMdZ03JwpArmpGbwe4hBxisvJ6BYqIYHcJdTozwG4LOUzRBDM83yb0iuENy
         ZBDApB3uwnM+a14bYewdHhIL9cb4N5A9dZ1KGr0h+ckoVCr8E4DF1mVw6Kc1ITGmoSo6
         mhsXDO1CVKJ5PInBQIqqm6l+tKXBqkojOcSc4/ipEJ6gfsna0hJnN0iK/4XMLo0FoB/o
         O8QyAo1tp1pA+xA24rp8AwDOdgEYUrrv+yYwVVvoC58+Z26UcIKt58Jv0fqgfQghXxFy
         OSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=06+BuaqCExp3OktAsqU4uEcZm4SWvo2W5juMDl91Gyw=;
        b=HBe+BBM3LcdFmS6LQGD/rgRsaWJoAyT4+6mrCQOVUREoVihzhx8J9H7Qhqr/wL/xVe
         H4YsqwRCwD9SI1DXkIeuCBBgR7Ua4rJoZNMKSHns96oBi+eOR+v2G9ExDvg4cEQX6/cP
         dWxF68I41VCA1baLfxvUk5FWW1pAPe8Tina9h3ngrMiQlvS2rQ5UUq0/matmqW9rCs6D
         fFsA0GhbASn+FQLSVDre8U4+8NsR0kD9kndwTQwo5BINuNCk5o/P5sSjoCfB19cXvVGT
         3pTeqCtlKiMA4bPn+wuN4ow022qgocK5VDD81k9M8Be3OgWIws5bSVShA8ToK+eJrqo0
         0Kug==
X-Gm-Message-State: ANoB5pmI87XF7MX7OP8+SoSGktjSKN/n4JcuRjlEhv/oosXuqC75yab9
        9hwyuMhin7u2ysPTxD891emXKQ==
X-Google-Smtp-Source: AA0mqf5c1p3v1mSw0W1Lxou6w1c9U0b5P6hMhDR4wdAvK1CzpOphup5o33C+z/8uS5ryXcV0TzRX/Q==
X-Received: by 2002:a4a:9e99:0:b0:49f:df9f:f316 with SMTP id u25-20020a4a9e99000000b0049fdf9ff316mr20579972ook.63.1669789724127;
        Tue, 29 Nov 2022 22:28:44 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id w12-20020a056830410c00b006619295af60sm513339ott.70.2022.11.29.22.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 22:28:43 -0800 (PST)
Date:   Tue, 29 Nov 2022 22:28:33 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Nathan Chancellor <nathan@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Hugh Dickins <hughd@google.com>, llvm@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 and earlier only] mm: Fix '.data.once' orphan section
 warning
In-Reply-To: <20221128225345.9383-1-nathan@kernel.org>
Message-ID: <103aa792-661f-396b-82d4-4507df636b9@google.com>
References: <20221128225345.9383-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Nov 2022, Nathan Chancellor wrote:

> Portions of upstream commit a4055888629b ("mm/memcg: warning on !memcg
> after readahead page charged") were backported as commit cfe575954ddd
> ("mm: add VM_WARN_ON_ONCE_PAGE() macro"). Unfortunately, the backport
> did not account for the lack of commit 33def8498fdd ("treewide: Convert
> macro and uses of __section(foo) to __section("foo")") in kernels prior
> to 5.10, resulting in the following orphan section warnings on PowerPC
> clang builds with CONFIG_DEBUG_VM=y:
> 
>   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
>   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
>   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
> 
> This is a difference between how clang and gcc handle macro
> stringification, which was resolved for the kernel by not stringifying
> the argument to the __section() macro. Since that change was deemed not
> suitable for the stable kernels by commit 59f89518f510 ("once: fix
> section mismatch on clang builds"), do that same thing as that change
> and remove the quotes from the argument to __section().
> 
> Fixes: cfe575954ddd ("mm: add VM_WARN_ON_ONCE_PAGE() macro")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Yes indeed: thanks Nathan, sorry about that.

Acked-by: Hugh Dickins <hughd@google.com>

> ---
> 
> As far as I can tell, this should be applied to 5.4 and earlier. It
> should apply cleanly but let me know if not.

I think it should be good for 4.19 also, but I don't know what happens
or would happen in 4.14 and 4.9 trees, since those have no other example
of .data.once or ".data.once" (and I've lost what little I ever knew of
that linker script stuff).

Since we're not hearing complaints about those (or are you?), perhaps
those trees are not clang-ready in other ways, and for gcc it all works
out by itself: I'd be inclined to just leave them as is myself, if there
are no reports of breakage; but you may know better, and prefer to remove
the ' __section(".data.once")' from the 4.14 and 4.9 versions.

> 
>  include/linux/mmdebug.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index 5d0767cb424a..4ed52879ce55 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -38,7 +38,7 @@ void dump_mm(const struct mm_struct *mm);
>  		}							\
>  	} while (0)
>  #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
> -	static bool __section(".data.once") __warned;			\
> +	static bool __section(.data.once) __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
>  	if (unlikely(__ret_warn_once && !__warned)) {			\
> 
> base-commit: 4d2a309b5c28a2edc0900542d22fec3a5a22243b
> -- 
> 2.38.1
