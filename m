Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDF46A724A
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 18:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCARt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 12:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjCARt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 12:49:56 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B130B360B1
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 09:49:54 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id i34so57151457eda.7
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 09:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677692993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fr+dmVMwm91Gy8NGRZmShMJBGqxMRDYe1XiiIn6bQcc=;
        b=NsYcWm922eOD7daali3r/KaM2DduEsfnEs9H7XLCTrqSaido46CzHsIXdd9XqiarNx
         dut/JEJnkSbj0yVGOdRQ5eU2/Roj5lXMTvWuyThME6UmSBjGY0c0XfuWKRTY1kpQGMT1
         hTvaZtvRwGGjl7Di42zO+kzTc7Kkuo3FxOIR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677692993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fr+dmVMwm91Gy8NGRZmShMJBGqxMRDYe1XiiIn6bQcc=;
        b=Cy2ACgqkWq2Elzy4rrFPZsSAOf3ewQLRjCkaPEH2v8UWBxlZyfvxL8hg1JtIlKwxUK
         COjC/JLLvyEAnTi6/tH8h8keehQtAmoG/YegGSvQm/C2T8iYs4w7271+ekkxY7H0unUt
         mi2fjaElni7bhN3E3Owbvx7Bwe+YSxYG9Lk4Wo1BgZOqH+3IjZQ9WcUerunwwGi8Py5Z
         HMFiQkxHCwj5IFP71C6PuPnTefMvVF3R5I05LEpsQDJkw6Eyfey+9iL3jsqr9+o+xg5L
         S1CNg3bKJem8opki8u3GnFV66ZZiMgmzh1YbAmfJKep8nIAFIUD42KOZKBb0idXEeqvk
         aOjA==
X-Gm-Message-State: AO0yUKWRVwaz/RQoPxmXOfawrCbcfKedBlyZ7y8xBlb1kC54Q64tJHH5
        votY8PUXNRD1aGvKZmQgFW3Fp8KmG7aziDNe4jIb7Q==
X-Google-Smtp-Source: AK7set/0NY7gLuN+K7V9sOx+uHpsm4QQl6Z69w2VwMAe9pUl6DVAGRHfDdqiQ7wSmCi/LuQpvbEVKw==
X-Received: by 2002:a17:907:365:b0:8b3:b74:aeb5 with SMTP id rs5-20020a170907036500b008b30b74aeb5mr6900456ejb.30.1677692992766;
        Wed, 01 Mar 2023 09:49:52 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id c21-20020a170906341500b008ecda4510c9sm6154447ejb.146.2023.03.01.09.49.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 09:49:52 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id u9so7700212edd.2
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 09:49:51 -0800 (PST)
X-Received: by 2002:a50:99c5:0:b0:4ae:e5f1:7c50 with SMTP id
 n5-20020a5099c5000000b004aee5f17c50mr4372495edb.5.1677692991611; Wed, 01 Mar
 2023 09:49:51 -0800 (PST)
MIME-Version: 1.0
References: <20230301171007.420708-1-willy@infradead.org> <CAHk-=wi5b+-Hys_8V7asP13EY=YSA8MUv=DwP7WK7mKeNvpRFw@mail.gmail.com>
 <Y/+Ni+kYeUWQokis@casper.infradead.org>
In-Reply-To: <Y/+Ni+kYeUWQokis@casper.infradead.org>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Wed, 1 Mar 2023 09:49:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=whXtntyCvVmVGcWvnYxeAkTBy9uK+5CUG_ka3ytd+Ww_A@mail.gmail.com>
Message-ID: <CAHk-=whXtntyCvVmVGcWvnYxeAkTBy9uK+5CUG_ka3ytd+Ww_A@mail.gmail.com>
Subject: Re: [PATCH] freevxfs: Fix kernel memory exposure with inline files
To:     Matthew Wilcox <willy@infradead.org>
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

On Wed, Mar 1, 2023 at 9:38=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> The first caller was pagecache_read() in fs/ext4/verity.c.  I
> think that's waiting for next merge window.

Ahh.

> It does make sense
> in that context -- the caller genuinely wants to loop over multiple
> folios because its read may cross folio boundaries, so it makes
> sense.

Hmm. Can we make it a lot more obvious that you really have to do that some=
 way?

Perhaps in the name ("partial" somewhere or something) or even with a
__must_check on the return value or similar?

Because as-is, it really implies "copy to folio", and the natural
reaction would be to loop over folios.

The ext4 code you quote doesn't loop over folios, it loops over bytes,
so in that context the function does indeed make sense.

               Linus
