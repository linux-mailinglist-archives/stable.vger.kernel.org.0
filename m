Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CC55A9325
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbiIAJbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiIAJbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:31:14 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05CD647FE;
        Thu,  1 Sep 2022 02:30:25 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id c3so17127314vsc.6;
        Thu, 01 Sep 2022 02:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=zyckv1N7jAJOPfH2OUuRZQlNIE+b3BRMU0Ayh2pzEes=;
        b=UPXVIh05c1mXGqUb6LGSFgWlnrHq2npnhPTfccKuoMYbV/waRAnjiR2TVoF/kfHgLp
         Kg0/MJkqVzLB09uDPsCA06xh3IvWsDa+oFVo0EVv8sg7GzvGwaUpFBwY+ux9zUdV66Zv
         xJEJ9TBsuqN8gO8B5nIQ0k26Pg+Nuh5vjKomukkRfllcyQAIpMx9rnMsuO+Exsp2cuN8
         tSnfGn0ErJY+fgM/TW5lxlZ0Utp3rxDQIbkV0JmAWD0g8q3CWkiL9nsOV4beIrTRV5Aq
         BfPL0sSBeY0AugM52dtJSzTAy3ZP1PGaqVqdk4ZoCvriHHqrKCUJ7iSXfz/9WWqWh7NR
         iE9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=zyckv1N7jAJOPfH2OUuRZQlNIE+b3BRMU0Ayh2pzEes=;
        b=R90FfjFiSQMUnyiw1xQSIlwGC/tIl58U2zu3JyRQ/NF6LjRNc4z7JDfJI3dHHQaIBC
         KoIipn/T+JBZLPJ/671DwJLifhUA0FtcLfSoaskhCyehsEFlaqyYd2nA1Wd/ezN4OxeH
         Gw7c7TbaUA1ikfpz+6641oXBKNVIo9VE0Wb65SWtsxrIHLc/qik+X0jrIOVqzIAPrWQP
         GtO1r0C4mJQgFHKhrvUZzoNFi33AhpmhGzzMyzQK88w/+ufn+SKjjRjGxxBVXZt34aAc
         b68V6F6Hz+2b+atHKn1EYiU/TCBRo6q+EwcwlcICoxAF+40dzK2JgA9GwQAFA+oDksFa
         cGMA==
X-Gm-Message-State: ACgBeo1g1FIpHiyypOhHJRFk6wuq3ay5LNJu1EEa5j7W2XOFKSXaj6YF
        V+BxEZYC9MLb85GhZ+Pk32ka/842W7c6nYQ7nLI=
X-Google-Smtp-Source: AA6agR5kk1isbB5yEdeLaIyUtb4d3xjFXmAoyQtfIJrrDwbKVOfmssTl2sYTrAk79aCyzQu2G2Cp616goOEvjBZRJZI=
X-Received: by 2002:a67:b90f:0:b0:390:cb3e:efb8 with SMTP id
 q15-20020a67b90f000000b00390cb3eefb8mr7296461vsn.71.1662024624827; Thu, 01
 Sep 2022 02:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220901054854.2449416-1-amir73il@gmail.com> <20220901054854.2449416-7-amir73il@gmail.com>
 <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
In-Reply-To: <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 1 Sep 2022 12:30:13 +0300
Message-ID: <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
Subject: Re: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in xfs_ifree
To:     Frank Hofmann <fhofmann@cloudflare.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 1, 2022 at 12:04 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
>
> On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> >
> > [backport for 5.10.y]
>
> Hi Amir, hi Dave,
>
> I've got no objections to backporting this change at all. We've been
> using the patch on our internal 5.15 tracker branch happily for
> several months now.
>
> Would like to highlight though that it's currently not yet merged in
> linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
> If this gets queued for 5.10 then maybe it also should be for 5.15 ?
>

Hi Frank,

Quoting from my cover letter:

Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
I pointed Leah's attention to these patches and she said she will
include them in a following 5.15.y update.

Thanks,
Amir.
