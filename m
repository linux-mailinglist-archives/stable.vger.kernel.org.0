Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAEB598AB7
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 19:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbiHRRuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 13:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241671AbiHRRuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 13:50:51 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A237BC8C
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 10:50:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id fy5so4623111ejc.3
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 10:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+udMhoflNILtLwMziy9QxbssD2QG4JpM06SxHHpbxCA=;
        b=NIFQwkNUiiLFi8Kjt5lNwduVmw8vZNrnkydVranhuX0VDQLaXP8rdwO6iHupijdwu4
         YXvINWRetkI8m/oPV2ppzNtRa+zS7ekhe735BIHqWol3mnYKxcWl2pHdmtWWZ3JMXWu2
         besgRXCgcXwerlm7kZFSHvID0lfS0iRiD22Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+udMhoflNILtLwMziy9QxbssD2QG4JpM06SxHHpbxCA=;
        b=H9Eok/4Fkew3/uWcsiEu2SEHuaj9RPZaWjFA3wuIbIi9RreMbYSeHx80fPKb1FAAsq
         hMOUYqPO4+r73RZmROVX5ndJREtHx6oS5SnZQD4aB146EHZaIV/XtVFqXvGyw4t3Oy0a
         +er0BAiqFnzXKOOf0g/BTqJ+dWvI+XdfHc9UTjz9hm1k4m85bbLj9QtMBOIdWIOW4WSl
         9hQ9IfKREe4po0m8Eg0eE11f95FGaFYiQRHArAyT0Ecn8QVR4cdb59yiFwRcoXkGwFyE
         iKnbJxG3dmw4HL+v+80MGIRqKQ9vKHEfC49tXII3lenjG8CbGMeETqqxHD2h0LPhwgrU
         dGzw==
X-Gm-Message-State: ACgBeo14OTSPmnDtkcvhmRRHaa8KgYv2enT9i7UoxaUILjUyKjLJDjm+
        /jX1c8f5hFYWY6O+Z0viHCnsol2B55Mw91kK
X-Google-Smtp-Source: AA6agR64FGn/dzv8k8VyMLK59CvpdcLYpaW434K7Ui2UsnX2wG8BtaX2ggL944YhsaYvi9o8l4L1SA==
X-Received: by 2002:a17:907:2cd1:b0:730:65c9:4c18 with SMTP id hg17-20020a1709072cd100b0073065c94c18mr2562257ejc.324.1660845048760;
        Thu, 18 Aug 2022 10:50:48 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id h23-20020a50ed97000000b00445b5874249sm1519079edr.62.2022.08.18.10.50.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 10:50:48 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id s23so1191691wmj.4
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 10:50:48 -0700 (PDT)
X-Received: by 2002:a05:600c:657:b0:3a5:e4e6:ee24 with SMTP id
 p23-20020a05600c065700b003a5e4e6ee24mr5555143wmm.68.1660845047779; Thu, 18
 Aug 2022 10:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com> <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
 <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
 <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org> <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
 <CADVnQykRMcumBjxND9E4nSxqA-s3exR3AzJ6+Nf0g+s5H6dqeQ@mail.gmail.com>
 <21869cb9-d1af-066a-ba73-b01af60d9d3a@kernel.org> <CADVnQy=AnJY9NZ3w_xNghEG80-DhsXL0r_vEtkr=dmz0ugcoVw@mail.gmail.com>
 <eca0e388-bdd1-7d83-76a8-971de8e3a0ce@kernel.org>
In-Reply-To: <eca0e388-bdd1-7d83-76a8-971de8e3a0ce@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 18 Aug 2022 10:50:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjMKztOKfaqqPeEyM+9eHrfkJfrSrsaWx3EXDrRtyO98Q@mail.gmail.com>
Message-ID: <CAHk-=wjMKztOKfaqqPeEyM+9eHrfkJfrSrsaWx3EXDrRtyO98Q@mail.gmail.com>
Subject: Re: python-eventlet test broken in 5.19 [was: Revert "tcp: change
 pingpong threshold to 3"]
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Neal Cardwell <ncardwell@google.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        LemmyHuang <hlm3280@163.com>, stable <stable@vger.kernel.org>,
        temotor@gmail.com, jakub@stasiak.at
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 11:44 PM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> Thanks a lot, Neal! So for the time being, until this is resolved in
> eventlet, I pushed a change to disable the test in openSUSE.

Yes, that is the right approach in this case, since it really does
seem to be purely about timing.

Note that "breaks user space" is not about random test suites. For all
we know, a test suite can exist literally to check for known bugs etc.

No user space breakage is about real loads by real people, ie "I used
to do this, and now that no longer works".

The test suites showing behavioral differences are certainly always a
cause of worry - because the test may exist for a very particular
reason, and may be indicative that yes, there are actual real programs
depending on this behavior - but isn't in itself necessarily a problem
in itself.

            Linus
