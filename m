Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D266A7208
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 18:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjCAR0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 12:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCAR0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 12:26:50 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D98367E6
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 09:26:47 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s26so56757395edw.11
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 09:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677691606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JBUdOkhZDhGTfbkVjVWJFke9kip+9af6zApOUg8Q8Pw=;
        b=RYmAQdCJZzxNHZOyt8zK30FB21DTqRixN5kVrkIMX33OYkJdl8jePPjKFpT0JXl1su
         tuNcfz0hAtMNg98mnP/4OkRBvPjYrOzr0wAoZ4Gp5JnCngONxSvJU9niyLOeq69PgKHI
         oBz5ZwxBUPlQxCeuZj+pgykQMmYFjh12MBoz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677691606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JBUdOkhZDhGTfbkVjVWJFke9kip+9af6zApOUg8Q8Pw=;
        b=mvj/m86IwCmCP6F5pwJgBpXrJ6QXQb/hQ6iYTzgYT5nYqo1N+xnPnP9ATY1ggyP5WA
         i5wEK4N8hK5Gg86s2UAwCKgUTWsxa7UrqH8xi1lG5YYQVEd87rPdMoffNnxXELFbr52u
         ZXG7CVnbhsvClaJxZ0SDoZDX5UHuu7+ZshSaza2IuZSnifmQ617JWu7axxMCaJm7h5Fp
         4xFefKvkhzcPV1Hfs7Wjsfvb6/SwgNdqp1bwSAy5qKUAe0sL9IiHWGuBzO1pSKj0fXg/
         BlLBl0Sg/MIz4pe9OZZTzq1A3znc/X+xfUgPrgJI47rCr3xyiFDYo+/m+CdRmHaMj6cN
         gkVw==
X-Gm-Message-State: AO0yUKU0znxSwOlApe4a+wbWfvAyGCKfecpm6PigehkqLQZRs/AQnKgA
        mOzIi4eVoqejkxsdsllXtYEfepixQJXt076b/JJUjw==
X-Google-Smtp-Source: AK7set+j24zWW7YH2Omg0WGAOyfOML8BGR+KqhA6JXzKDSzoHqChqo6lRINwDfoTmHTWU9Vau62DWQ==
X-Received: by 2002:aa7:c90c:0:b0:4aa:b63f:a0e with SMTP id b12-20020aa7c90c000000b004aab63f0a0emr7125740edt.17.1677691606051;
        Wed, 01 Mar 2023 09:26:46 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id f25-20020a170906139900b008eddbd46d7esm6022012ejc.31.2023.03.01.09.26.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 09:26:45 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id u9so7413843edd.2
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 09:26:45 -0800 (PST)
X-Received: by 2002:a50:8e5b:0:b0:4ab:3a49:68b9 with SMTP id
 27-20020a508e5b000000b004ab3a4968b9mr4039033edx.5.1677691604823; Wed, 01 Mar
 2023 09:26:44 -0800 (PST)
MIME-Version: 1.0
References: <20230301171007.420708-1-willy@infradead.org>
In-Reply-To: <20230301171007.420708-1-willy@infradead.org>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Wed, 1 Mar 2023 09:26:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi5b+-Hys_8V7asP13EY=YSA8MUv=DwP7WK7mKeNvpRFw@mail.gmail.com>
Message-ID: <CAHk-=wi5b+-Hys_8V7asP13EY=YSA8MUv=DwP7WK7mKeNvpRFw@mail.gmail.com>
Subject: Re: [PATCH] freevxfs: Fix kernel memory exposure with inline files
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>, security@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 1, 2023 at 9:10=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> +       memcpy_to_file_folio(folio, 0, vip->vii_immed.vi_immed, isize);

Well, this function doesn't exist upstream yet, much less in any
stable kernels..

In fact, I can't find any sign of that function *anywhere*. Searching
for it on lkml finds zero hits, as does linux-next.

Is it something hidden in your personal tree, or is my grep failing
because the function generation is behind some macro magic?

And while I'm on this subject: the "memcpy_from_file_folio()"
interface is horrendously broken. For the highmem case, it shouldn't
be an inline function, and it should loop over pages - instead of
leaving the callers having to do that.

Of course, callers don't actually do that (since there are no callers
- unless I'm again missing it due to some macro games with token
concatenation), but I really wish it was fixed before any callers
appear.

               Linus
