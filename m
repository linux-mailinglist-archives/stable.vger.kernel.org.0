Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5AC59B574
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 18:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiHUQ3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 12:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiHUQ3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 12:29:13 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD711220F8
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 09:29:11 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s11so11082363edd.13
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 09:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=MRk7irxGxk2aHfdmukhlXRNNytXXfiDNpGBpF8JBwuA=;
        b=HlN5sT1Qf9QURE6edPylEV68vVEDnEILL1OgXAaBFeqI57Q8Ssnmbqv4AWgLd6BLbL
         dp3M+OGuEzDGteb0SCQYQ6cDFc4RZjHxaHQliIgB8jY67p+1PNW73v6XiU+SaCKGZF9p
         rQlq7oYB+OjqUPZTpItfQJDDgI+/4/899djdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=MRk7irxGxk2aHfdmukhlXRNNytXXfiDNpGBpF8JBwuA=;
        b=b+R6cRROs4QWBxp18CfnBlvNvT//tww7urTt9O2/dtyxEJJWzWRJQ+4VVEB3tiO8ga
         7GBHNbWRDhjPxJ+ANF/4jtBrwx9tEd32pvvl9aorlG8tW373bZZ+lzaF8X2uyIJkpPVh
         X+k7LX6F7mHBJRDhHmKTF31K0qRsFYDRcyANWGfoX2bybYzTk5qQbt5ZARP5JFhJ31ES
         4daXl+T0rBLMjD1z+VI0fhTMmZ1StCNM9qiIVzV5Te6IliZLDqSujs/xmuucw9+1Hcxh
         Jb9hTe5irxjCcy+Sklktd8MNiwWHax3Fidsiq5Ys4xoVnsa3CYB9mkIdJUtf3YexVFUn
         WyVA==
X-Gm-Message-State: ACgBeo1FcSoX134GbEUfqr6RI+onDd5ZxHcEWzV0dtaAQrhqzTCct451
        KP9AzJODEd7XGq4x4R6E6C7x91p/nSNk2z4R
X-Google-Smtp-Source: AA6agR7+JI9owgDNQyZG1wH6a/jcI24wJ6MirNM1kLB8Nisp+VhKsg5tNw9MPFXtlIy6NlQKg5Bg/g==
X-Received: by 2002:a05:6402:90e:b0:443:ec4b:2b03 with SMTP id g14-20020a056402090e00b00443ec4b2b03mr12975451edz.71.1661099350175;
        Sun, 21 Aug 2022 09:29:10 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id 15-20020a170906300f00b0073d7c35fea8sm778105ejz.59.2022.08.21.09.29.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Aug 2022 09:29:09 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso4845186wmb.2
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 09:29:08 -0700 (PDT)
X-Received: by 2002:a05:600c:657:b0:3a5:e4e6:ee24 with SMTP id
 p23-20020a05600c065700b003a5e4e6ee24mr12668062wmm.68.1661099348623; Sun, 21
 Aug 2022 09:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <1661089567161107@kroah.com>
In-Reply-To: <1661089567161107@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 21 Aug 2022 09:28:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=whSXK98xy6szeyYrG2q7V5TUhk=aaEmU-joB3a8p7EA=Q@mail.gmail.com>
Message-ID: <CAHk-=whSXK98xy6szeyYrG2q7V5TUhk=aaEmU-joB3a8p7EA=Q@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] locking/atomic: Make test_and_*_bit()
 ordered on failure" failed to apply to 5.10-stable tree
To:     gregkh@linuxfoundation.org
Cc:     marcan@marcan.st, arnd@arndb.de, will@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 6:46 AM <gregkh@linuxfoundation.org> wrote:
>
> The patch below does not apply to the 5.10-stable tree.

I think the reason is that "atomic_long_fetch_xyz()" got renamed to
"arch_atomic_long_fetch_or()" by commit cf3ee3c8c29d ("locking/atomic:
add generic arch_*() bitops") in the meantime.

Afaik, the patch should apply by literally just doing

   sed 's/arch_atomic_long/atomic_long/'

on the patch before applying it.

That should fix it all the way back to the 4.19 backport.

          Linus
