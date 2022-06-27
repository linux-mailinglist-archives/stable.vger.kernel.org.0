Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220D055DEEA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbiF0KTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 06:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiF0KTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 06:19:39 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CF710CB
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 03:19:37 -0700 (PDT)
Received: from mail-yw1-f173.google.com ([209.85.128.173]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N3sNa-1nfL3X2VQe-00zkzV for <stable@vger.kernel.org>; Mon, 27 Jun 2022
 12:19:35 +0200
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-317710edb9dso81067677b3.0
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 03:19:35 -0700 (PDT)
X-Gm-Message-State: AJIora+revQY+wW6eR4B0/CsDy+a2Tcz7rOkntRqf5N2sXfgP18ScCPk
        knC7utuFnAx58rsMcvpsHi1MN+07eDSH/roLwaI=
X-Google-Smtp-Source: AGRyM1sXv3PmBrdzpepe4+Y1ihjsG9luWwVOgiOMQ28r4ahWJ32gsdMKkagIifFp7Ejz5Yu5RRIYaFaj+XPfeU1IOJA=
X-Received: by 2002:a81:72d7:0:b0:317:917b:8a48 with SMTP id
 n206-20020a8172d7000000b00317917b8a48mr13990204ywc.495.1656325174318; Mon, 27
 Jun 2022 03:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a31O-_oGvG3bHCer7DXJApsd-TLV71_NwVt=yMGQ_iR_Q@mail.gmail.com>
 <20220627093810.1352-1-xyangxi5@gmail.com>
In-Reply-To: <20220627093810.1352-1-xyangxi5@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 27 Jun 2022 12:19:18 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0D7sy=jjjUQK0F-RugCNecYBg+JjM=vH=fy0suLDAOCA@mail.gmail.com>
Message-ID: <CAK8P3a0D7sy=jjjUQK0F-RugCNecYBg+JjM=vH=fy0suLDAOCA@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: fix buffer overflow read in __strncpy_from_user
To:     Yangxi Xiang <xyangxi5@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:D1RpZOTm2466/TRql4dzkMICliyr8Fkc84HiVXhdhpt1xQ1HxEM
 tuq+oCHh5LsAMH+lxMC/NArcU6j0Bngwu+rMNSPSSaGdm8R5J6JSO1J3Lo92+TxCokvAtGr
 ph3N9XLA7KlxP4K88FM2jGeldDyjc6y/v9UmwW/sG4u4zEOmZ2bcJes46aU47214GrD7IYi
 SJDlzhX2QdrO27pXNhR2A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:w1kowdDzt+M=:Oq4B29M2k5rY6QOMmS0Uex
 7IwnNKF1SI1L2wcu/EnzTYj9NaBS3H7afi2ZGuZg2fhTYRUo669y4ZqkmGMyN6Ahe6JsAkihr
 74AERYWvXUrrOwYHCryTw4F3a60MZX/IzMNe1vSnIO0mIdghnq5ZQn4LIr3QQL5s7D0uyfdes
 HkFBlg+3m5tvSnOdwg9zfvxijC0CXuBU9jzHGs5Oy8MVUlKHY7aUGM1N58B5z0hYBD+n2sEe3
 1kgIrkKuR/n6opSlAwZzv29Kv01MCYm87L+ip2oMJId/tyrwUIjDt/+9VeZbAILntKGwQbSgj
 FOG+kAfWd2cTTmju7TCi0gYnil3RP3dNdH6D/Ou/2uL2tM/NJ6D5+beZtaDwwSlYM9JfHH6gG
 vGGHpphJUZD6ZM0aWfxgFik6pvyoksFv9h/SIPx4P2jV/e+uEc100YmjELy8cZp/WevBWEu3x
 tdxbXUM3A9qeH/g+eQZ0L3Qo4trDQkI0V6QhZiZdgFF1SfKxFrnFMjx449N9DkuRjLWSWSmrp
 hkiQYuT+tzh5q2eqm3E9Ya8bTKH54eUhQg6YJ9UG7o2Ce2d+0A6LE8D0Npf33OgUI8op+9z6J
 iJtkPntousZ14AopNiwO/4FP/ZKhMgubol9UCo4HP3w9cODhoC6/4elyfS7iJMigN6XCpYE9h
 AfCgQMXGQML3NwCzA9XuFrmqSBZfNXTKP2ruyoiH+R9ge7QdEgPJX7XYRWTgpvXzy/AQ5kn9q
 t5ZtuOOLNcrFAPdi6EeMxYpALYfNUCzyu20W2g==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 11:38 AM Yangxi Xiang <xyangxi5@gmail.com> wrote:
>
> > Which architectures do you mean? I don't see any architecture using
> > asm-generic/uaccess.h without setting GENERIC_STRNCPY_FROM_USER
> > before commit 98b861a30431 or the prior release.
>
> I am a user of LibOS, which uses this __strncpy_from_user.

Ok, got it. This should be part of the changelog then when you send a
patch for stable  kernels. You should also indicate that the code was
removed in mainline kernels and what the fix was there, as well as
which of the older kernels need the fix.

> > Also, I think the implementation relied on strncpy() setting a zero pad
> > at the end of the string, so the ckeck would only be needed for a count
> > value that starts out negative? Is there another way this can actually
> > cause problems?
>
> In kernel there is a common calling pattern is strncpy_from_user(buf,
> user_ptr, sizeof(buf)), as I mentioned before. If the size of
> user_ptr is greater than the buffer in the kernel, no zero attaches
> to the end of copied string (see the implementation in lib/string.c).
> So the checking of the count variable in this boolean condition does
> not protect the tmp buffer in the last iteration of this loop in the
> __strncpy_from_user.

Ah right, of course.

       Arnd
