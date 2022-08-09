Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9169758E0F9
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345090AbiHIUVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345887AbiHIUU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:20:58 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564B726576
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 13:20:55 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id dc19so24104935ejb.12
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=DGKHHAUwuZfCazjxcNKKHUT7rJIi8ll9zTOb4y7hCUc=;
        b=WEfpeEZLySvke8oWrURAvNB0cuhg5p2fhHNFSr8Ptu4Bkc8DH9B5yKXXkiA0f8ZSUv
         Wk+tTMhRbTpst7yfa9aNELS/+G+R2Y1Y3t1e8NW7tW/W29tb/gDh8ah0vHJT8w/US+Z4
         v7PoDdCm6NLn1YJYubR0e9eymGioz29VRHsSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=DGKHHAUwuZfCazjxcNKKHUT7rJIi8ll9zTOb4y7hCUc=;
        b=UFbUuZK+NauFYP8k8d2ctR7u7IusBgrRqHOoMqDlxOrNkg1C/Jha4w8GsoanEILss8
         mk6qugFwrR/gbMPJaAeGPYEKY0RCdaiy1HqeiTtZDuaIV63RRV2C/sK1OAjA09+Mb3Az
         9pjMOGLhTKkn5CKROGbdejuUdkbr6dgxaDukQ385QJejK2EkhDpsjHMpQbWoHuISVDoj
         YdRYs2ffmoI7abwzHNmDdb6EaD8laL59ZiKaM1gluoEsMFUhdb8IRB4zSms+4/aHdzdR
         kPCVPxPU8Catvk3w/1q60stez4ASwjpHGslREYfSPzuwGSE+bSOT18lzLkWOMt5B9hsC
         PHww==
X-Gm-Message-State: ACgBeo2zxKEc44oOs1oBzwVUs7U8oUNw1A3SBrRz+D+ksNm0MOpduPIm
        NVCTnTGTTWFVkB7WhCw/u3acFc6IsISpGWZ7Ih8=
X-Google-Smtp-Source: AA6agR4VI/TZJDpwRbk/ATevBa8vttF1zPURRsxVnss+Q1cp+FOEiJtYNyvXMpNAmqq136kbsfbCbg==
X-Received: by 2002:a17:906:6a10:b0:730:e9bd:1110 with SMTP id qw16-20020a1709066a1000b00730e9bd1110mr15740318ejc.88.1660076453694;
        Tue, 09 Aug 2022 13:20:53 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id v18-20020a170906293200b0073022b796a7sm1500482ejd.93.2022.08.09.13.20.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:20:52 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id bv3so15509384wrb.5
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:20:52 -0700 (PDT)
X-Received: by 2002:a5d:6248:0:b0:222:cd3b:94c8 with SMTP id
 m8-20020a5d6248000000b00222cd3b94c8mr7137394wrv.97.1660076452117; Tue, 09 Aug
 2022 13:20:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com> <CAHk-=wgsDOz5MfYYS9mE7PvFn4kLhTFdBwXvN6HCEsw1kvJnRQ@mail.gmail.com>
 <91e18a2f-c93d-00b8-7c1b-6d8493c3b2d5@redhat.com> <CAHk-=whg0ddey-LqFAPfZJDXHMjaHJNojAV3q17yvjc6W8QRvQ@mail.gmail.com>
In-Reply-To: <CAHk-=whg0ddey-LqFAPfZJDXHMjaHJNojAV3q17yvjc6W8QRvQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 13:20:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgYAy5ho0Wqx+eri_+a5apYU1Th826UScE7rZRiyhPcGA@mail.gmail.com>
Message-ID: <CAHk-=wgYAy5ho0Wqx+eri_+a5apYU1Th826UScE7rZRiyhPcGA@mail.gmail.com>
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

On Tue, Aug 9, 2022 at 1:14 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But as there are two bits, I'm sure somebody ends up touching one and
> not the other.

Ugh. The nommu code certainly does odd things here. That just looks wrong.

And the hugetlb code does something horrible too, but never *sets* it,
so it looks like some odd subset of VM_SHARED.

                 Linus
