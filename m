Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E0696D9D
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 20:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjBNTOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 14:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBNTN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 14:13:59 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234F825E2B
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 11:13:59 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id l201so18398846ybf.10
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 11:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pXcppXk4sqKzMfvrWIcFdUhO+LBg/Sx5HjhK9InjLrM=;
        b=sBkTngIVAaqz5LH/0bWPS1DnkXZldvsO+retgT7Ci5Lu8G9n+PTbmVAvcUKVBDw/0s
         yr4M5LhS2p2umzeK2YE6SV7FZxw+TJomxo1C4DJH4wrUtr/ZzAmCYmb3yiRG2fmgofR9
         tPscLBX1kz1bsG6af6H5UgRXWhb1m3OLym5NycwHqh6yAZDiqJooWbKEd7RCIou8Ax/j
         4VzDpPIjRFRh6ParORPWhbPgZE3N5JWcdeGEkBlFFQWYEcmu776E1AjtjFEELYosaVDw
         d/roJISxnfdtGmea00pPM2nW5penJlU69skXybwsP/5ZLsFNQ0mc/Bh1yFluW3wog9/M
         O1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXcppXk4sqKzMfvrWIcFdUhO+LBg/Sx5HjhK9InjLrM=;
        b=QNJk8IH2Wq9FWrMXefdsoQ92CajlDE++xdDb27uFgF9/W43+C+SgADN+7LG7VfgMEi
         kG9s8DUC1Oer9Zms4YsH1VV4z3041w9B0FBnH4ePOkcv4FI3dSwhc/ewvWVYAEBJ2sZj
         p5refRslR7ng1eqAeXwk0YHI2tQmlMXlijldKEHg7IVVqBgtKUrbxMf44t19f80FNIwZ
         LzRZdoVfXU6yCLiFt5pwksDeVyVKDkaGptLL1LDeSmTGz1dzFRKKh+EGI/rl5ivalS/O
         a+PJKAFMDzXrKa1yNj7xRhykmOEbjV7lZtpfEOvdk9Fd8TYhBbRj03jgPfqijWUxfakw
         F6BA==
X-Gm-Message-State: AO0yUKUyw2xjzMJHfodIJ07vG3jWYjdsJd7QKxh1H9xG+BApZG10FNau
        +EiDPjU3Wja3+iAjL2KlXBqXGTxQHmxKi+dgTaSwww==
X-Google-Smtp-Source: AK7set/tHwV6zaeaEHX7+c7voFKH8GjEjjky3i2eoCFFjx8yJ27ervyaGd6XZj+X5EmG0hBWTzNbXzKZK+X/oIAX0Zg=
X-Received: by 2002:a25:e303:0:b0:925:6e:c676 with SMTP id z3-20020a25e303000000b00925006ec676mr430727ybd.179.1676402038198;
 Tue, 14 Feb 2023 11:13:58 -0800 (PST)
MIME-Version: 1.0
References: <CAJuCfpGiktjjPZYPp8LNtbmvYhkxh_icEWXOVgsq9qeq+w6s+g@mail.gmail.com>
 <20230214181335.3946674-1-kamatam@amazon.com> <Y+vZLQXlkf/7XvVB@gmail.com>
In-Reply-To: <Y+vZLQXlkf/7XvVB@gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 14 Feb 2023 11:13:45 -0800
Message-ID: <CAJuCfpFpTGbPnJBh-MT3nat0t=HVr2ZWLELDAYtQ+TYhjg6XHg@mail.gmail.com>
Subject: Re: [PATCH v3] sched/psi: fix use-after-free in ep_remove_wait_queue()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Munehisa Kamata <kamatam@amazon.com>, hannes@cmpxchg.org,
        hdanton@sina.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mengcc@amazon.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Feb 14, 2023 at 10:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Feb 14, 2023 at 10:13:35AM -0800, Munehisa Kamata wrote:
> > Using wake_up_pollfree() here might be less than ideal, but it also is not
> > fully contradicting the comment at commit 42288cb44c4b ("wait: add
> > wake_up_pollfree()") since the waitqueue's lifetime is not tied to file's
> > one and can be considered as another special case.
>
> If that comment is outdated now, then please update the comment too.  We can do
> better than "not fully contradicting".

Agree. I don't see it contradicting that comment.

>
> - Eric
