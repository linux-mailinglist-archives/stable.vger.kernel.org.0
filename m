Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154504C7DA3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 23:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiB1WnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 17:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiB1WnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 17:43:06 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC055469E
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 14:42:26 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id p20so19519648ljo.0
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 14:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=izAQUggyP+5/oVhiuZDs8c+/hcOxRl41iBfO6/Va0lE=;
        b=gdhZ7E6qyVixQYbKXVG63vM2xxb0swnRwsBzKeIqWG+fvd2iqhAyhIGljd7cmjcZk+
         VR0ScDUTHEHFo886kC5m1yLaFtBCSaxGF8GxeWo+jc9QYY+zeoG6JzMqgBDKYVLOvOLh
         RDcjCrs31LKoUs+2CZ4lKeaBV+t9lou9IkWaXm01N/ieXDUWpXKj1+GKvYSSTn/ucwiQ
         xOQy2ZQ4KfSJOuJq6Dwvy59kumfzDJGCNtAzV9eaVqcqkKkDbvvh9EzYgF2XkstDB/44
         6af2uolk/7inaQ8fKQLIbomP/hHrh1kyhBCozZUGBlNhuQrEEX4Z8CusUwLIcUxSxIzt
         6ppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=izAQUggyP+5/oVhiuZDs8c+/hcOxRl41iBfO6/Va0lE=;
        b=L1CThA6IVr8JUwdw/70ZXAcpOJKzepwACI0HOFY0P5DctbgsTHTX7kov8aHRQLHxJR
         WJZ0pomGtmtaifyRdmMIvHHAqXUniDSfbbQDSoTgKDNGGkmYEj+Yfq9u1+MnuKhqRoV6
         uCsa2vr7m2BwHPnmKiaxQe0Q6oT4UT+RaVGCUoo5otZR/+MXuln+ALtuFh+O7rl57tof
         7hqol6kq7I6qtZfMFg+KRXCHKb+tS9d8xy75oII54RlAGansZQntXoJEd6hf2jYs+iVb
         Xl9wN/KCWvV4DUMRUCFLW718to7s683Uc4egxXbpkx0ZYjLKgKIZlYvENT672hWcDtGU
         2Zlw==
X-Gm-Message-State: AOAM531gmzy0/3otNDzxrdQMK9HSKPK2Dp25QUFS6MFnUxbvGhbFFY/1
        oiWr2P09sYJZyeBm7Vl8NqlAhfuAMnXVU0whRXXjNg==
X-Google-Smtp-Source: ABdhPJzvQ1kr0rlRYJB1BEesLr5I7VO9esTcIjTZCi65uc18521AsP4dIy+Ihsbg2tS+cZ/NY2TvWS6w4S+ZilQ+PiA=
X-Received: by 2002:a2e:bf24:0:b0:246:801e:39d3 with SMTP id
 c36-20020a2ebf24000000b00246801e39d3mr8704495ljr.472.1646088144327; Mon, 28
 Feb 2022 14:42:24 -0800 (PST)
MIME-Version: 1.0
References: <20220225221625.3531852-1-keescook@chromium.org>
In-Reply-To: <20220225221625.3531852-1-keescook@chromium.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 28 Feb 2022 14:42:12 -0800
Message-ID: <CAKwvOdm5pRtyf8W2c4q_xt353Kp+BSsC7qo5OE6VOEfOLCOJZQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Handle ksize() vs __alloc_size by forgetting size
To:     Kees Cook <keescook@chromium.org>
Cc:     llvm@lists.linux.dev, Marco Elver <elver@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 2:16 PM Kees Cook <keescook@chromium.org> wrote:
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 37bde99b74af..a14f3bfa2f44 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -182,8 +182,32 @@ int kmem_cache_shrink(struct kmem_cache *s);
>  void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
>  void kfree(const void *objp);
>  void kfree_sensitive(const void *objp);
> +
> +/**
> + * ksize - get the actual amount of memory allocated for a given object
> + * @objp: Pointer to the object
> + *
> + * kmalloc may internally round up allocations and return more memory
> + * than requested. ksize() can be used to determine the actual amount of
> + * memory allocated. The caller may use this additional memory, even though
> + * a smaller amount of memory was initially specified with the kmalloc call.
> + * The caller must guarantee that objp points to a valid object previously
> + * allocated with either kmalloc() or kmem_cache_alloc(). The object
> + * must not be freed during the duration of the call.
> + *
> + * Return: size of the actual memory used by @objp in bytes
> + */
> +#define ksize(objp) ({                                                 \
> +       /*                                                              \
> +        * Getting the actual allocation size means the __alloc_size    \
> +        * hints are no longer valid, and the compiler needs to         \
> +        * forget about them.                                           \
> +        */                                                             \
> +       OPTIMIZER_HIDE_VAR(objp);                                       \
> +       _ksize(objp);                                                   \
> +})
>  size_t __ksize(const void *objp);
> -size_t ksize(const void *objp);
> +size_t _ksize(const void *objp);

If you wanted to discourage others from calling _ksize, you could hide
its declaration within the scope of statement expression within ksize:
https://godbolt.org/z/e4sd4nE6q
-- 
Thanks,
~Nick Desaulniers
