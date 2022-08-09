Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A9058DFCC
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343493AbiHITH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347758AbiHITG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:06:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EEB220CC
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 11:48:45 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r4so16237636edi.8
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 11:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=DhUIuH+fIv77WJzm8eKuRBv3nR/JhYDUtxzpNkXaI2E=;
        b=OtCLH0do5IYLP3xRhX2XKN5rqVJR6zlV4hl/xmMCr0/f52r1aBM4edtcIvE8u9au8b
         yJAqKhenGtQuoWeme1R2oSE2YmJgYsCOMRYZO36i3m2QVZp048cs2P0WpncxTtN/vTMB
         nD81POpU1weccBApk3K2JDNk+T15xFvxrG/gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=DhUIuH+fIv77WJzm8eKuRBv3nR/JhYDUtxzpNkXaI2E=;
        b=OcHZktTzAX9OO0zpWMINBMJ7pUB4KWsqbmJ1xJo44DgPShgDI7MD35J0JtvwaJQsDC
         NuwTv2NGoS6nePlXwORhy+k38H9pAITHXm/YZPMzObld8rgzVpIlige1/h4SYLOIWBnx
         9JXzjIxr7SIh3uP16RWzFQUyDheIPUn1ZoquC0vc/+cjmPNOU/j/EY2EHyuxViKEByJV
         Ey1Wdo0Z4O2qYznLg2A1B02tvzuSn2rIdX5yI0gP7rS0ZjP5veCpl4byUDXWSWoMfjI1
         0BveBX8XzqpA1o2SkDKmCV3eGRmZXL/bQhz17fg7pAG+2b98TH1MDp0mY+p2TQjGbAd3
         rIDw==
X-Gm-Message-State: ACgBeo1NtHB4AGM18b4sIZgwL0m5zZHRiG0v3aZV6GIv1zcR1qqvEze2
        cT3V0MXqFIs4TA/qvD4t7mGftuGT+ijzMRNzXvI=
X-Google-Smtp-Source: AA6agR7D7S5epqwdTgwc7PJFSX8O1DRCD+awq4Swp9Pouxz+C2lOHmp6GM5v54z81kFxMWk4nGmCTA==
X-Received: by 2002:a05:6402:5193:b0:43e:1d52:fd70 with SMTP id q19-20020a056402519300b0043e1d52fd70mr22751078edd.150.1660070923561;
        Tue, 09 Aug 2022 11:48:43 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id 26-20020a170906309a00b0072b51fb36f7sm1385246ejv.196.2022.08.09.11.48.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 11:48:43 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso2056943wmb.2
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 11:48:42 -0700 (PDT)
X-Received: by 2002:a1c:f603:0:b0:3a5:23ca:3e7c with SMTP id
 w3-20020a1cf603000000b003a523ca3e7cmr12452214wmc.38.1660070921906; Tue, 09
 Aug 2022 11:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com>
In-Reply-To: <20220808073232.8808-1-david@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 11:48:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiKm3QjM1_XwWNW8P8drW6s0ZeANm7VKy_1c7WH6RSp3g@mail.gmail.com>
Message-ID: <CAHk-=wiKm3QjM1_XwWNW8P8drW6s0ZeANm7VKy_1c7WH6RSp3g@mail.gmail.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
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

On Mon, Aug 8, 2022 at 12:32 AM David Hildenbrand <david@redhat.com> wrote:
>
> For example, a write() via /proc/self/mem to a uffd-wp-protected range has
> to fail instead of silently granting write access and bypassing the
> userspace fault handler.

This, btw, just makes me go "uffd-wp is broken garbage" once more.

It also makes me go "if uffd-wp can disallow ptrace writes, then why
doesn't regular write protect do it"?

IOW, I don't think the patch is wrong (apart from the VM_BUG_ON's that
absolutely must go away), but I get the strong feelign that we instead
should try to get rid of FOLL_FORCE entirely.

If some other user action can stop FOLL_FORCE anyway, then why do we
support it at all?

             Linus
