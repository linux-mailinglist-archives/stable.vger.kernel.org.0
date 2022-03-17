Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28DC4DC355
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 10:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiCQJwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 05:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiCQJwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 05:52:03 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1041BB794;
        Thu, 17 Mar 2022 02:50:47 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by gnuweeb.org (Postfix) with ESMTPSA id DB50A7E324;
        Thu, 17 Mar 2022 09:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1647510646;
        bh=dgpQsMk1hhmDhijYbCiLOJpAaJQUNRsWuthKQ+bUHkU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sm3AP0VWC9wpIz1h1j0rz6g6Sr2vEyKSuqQb0KGakkCwuBxbPPsOmXbJ9JzoTpYKw
         kp37R9/GEgKqWrnk3WNka04g++VvpjHf9HxUA2t1li0BapsBsY8CrBYndZKyoMApf5
         nnXGuKV9wQE9SWJyQV+7lhnwq7Dk4HaaRvaiAks36FBJL1sdq1RfxiDeRNvajvRMNj
         SkLB4i6UbgpQ5u8OBzubKz1o1jT26o+i8jFXjGKCkrLQXHrKzvbH8RWfyq1JeVpHCk
         MVO7gfpbImqkSRbRFgnvc6IVaJEBcwEYU/dUSAhgHn932Ve3FueuOX5Yox3TMF3cnC
         ltn2BLtcIXNgg==
Received: by mail-lf1-f46.google.com with SMTP id h14so8027764lfk.11;
        Thu, 17 Mar 2022 02:50:46 -0700 (PDT)
X-Gm-Message-State: AOAM5320FWywKrmwRSYZmZ0wY4MS11mJALvJWGFZY6mqzozAoVQsJhOO
        K7vvBqMwPaKX1yKlmC16z71wLQk/JABm/cVDvT4=
X-Google-Smtp-Source: ABdhPJyVG2tE334Tjx2J2A13v0ElcfZ7nCgEfgim+YD4a5zKeY5nnX+E2bqqRvlbZA7gN/ce5pYEYHiUZraS3Ls4nqc=
X-Received: by 2002:ac2:4855:0:b0:443:888e:5982 with SMTP id
 21-20020ac24855000000b00443888e5982mr2327036lfy.447.1647510644979; Thu, 17
 Mar 2022 02:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
 <CAFBCWQLJ6vCWePF0W4U7mont=Jn4QfDUq-8UpOcm37yqtbkQ8Q@mail.gmail.com> <YjL+9sUPLvE57GE0@zn.tnic>
In-Reply-To: <YjL+9sUPLvE57GE0@zn.tnic>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Thu, 17 Mar 2022 16:50:27 +0700
X-Gmail-Original-Message-ID: <CAFBCWQJNvRHGUrSG1Am7TssX5ypMNDxveD+Uy+wV+S6uf=P6Nw@mail.gmail.com>
Message-ID: <CAFBCWQJNvRHGUrSG1Am7TssX5ypMNDxveD+Uy+wV+S6uf=P6Nw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Two x86 fixes
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        David.Laight@aculab.com, Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 4:27 PM Borislav Petkov wrote:
> Yes, what's up?
>
> Are those urgent fixes which break some use case or can you simply sit
> patiently and wait?

Sorry for pinging at the wrong time. Excuse my weekly ping. They are
not urgent fixes. So no rush.

> Because we have an upcoming merge window and we need to prepare for
> that. And there are real bugs that need fixing too.

Hopefully, the 5.17 release and 5.18 merge window go well.

-- 
Ammar Faizi
