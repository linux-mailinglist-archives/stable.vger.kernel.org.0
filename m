Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF734A770C
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 18:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346331AbiBBRob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 12:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346329AbiBBRo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 12:44:29 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C0AC06173E
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 09:44:28 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id n8so608101lfq.4
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 09:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKHGp3IZTNDGs1UXssMYvHffCV6Qwe0NnGDvJ02DSIU=;
        b=RKDpe5CLtb/CIOEcm/F1Wm4cAD42bV2H6g1sJD1JeQPpOA6NtJvalfmXR5PJ01nagC
         u7FgEme+IWXhnEF/XF1RCDaaeIkwuGC0b1oc/2HFfXskUYfW0w1N9B0EDpL6YXEXZoAo
         /UCd0OKtcSUKbiydk586E5GNxkOPh39K6wRC7rOSayk0MQi4agLhYrqXmM9qeo2y3pNL
         1AJxsHNUnz4M3PYcvzjCRues/79HPirMOp+ovnpzfoNloag8xlxfyVjBCmDJQ6B2/myW
         36llNOMUayEygCWZV4QHe8BHgmt+y+k5c7RUBX+WRY00dwVhR1NwnPxymSW7/bsBwHuA
         8XGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKHGp3IZTNDGs1UXssMYvHffCV6Qwe0NnGDvJ02DSIU=;
        b=mMzl/EyytPU4Eqy3prOAPobq3CsY22xcgjYUSBdGWLKnfuhxZKbOP3bCl3bM/RQJK8
         zJU6Tik8VLAb26y2yN69GG2cm7Kuk8Ep+fl5FWdzRz1KyDMAvfCi6GdrmgQyZMenxV3P
         QQ8oLs41SJXetiLwSxhq5M/J4KvBo+lDKz7WD2y7ba7ILsHCHZyKU8F/sRp2MAE/tMjj
         7baDw2m79/hIKvDGvy/mlMMmhcNqZJXCYXJdoQa0SNmc8LhSgn6z3iDcZ2zyfNoQwbKD
         j6jHblPNc3S979AE/r/sqKwWXLIQPf4JoJ3aAs+TSxD7T4F/VojFvswuzWXbNEOylXeD
         JjEQ==
X-Gm-Message-State: AOAM531zSL8/YcjsgaGVfjFqLqTFegj6sXrmG64eOm1LIUH4WbcAuW10
        +mMjrOmeI3hjCIqdRovZK/9OumbWOzDMA0PhAID8yt3RAbY=
X-Google-Smtp-Source: ABdhPJx0YTWPb/jNgD7u6P5r6UZ+8PU58yKq7kLZMfs8B16sWgFhDwOLJYS0HSsIkb4w4wa9wcuaaGm6S0gZZThMy48=
X-Received: by 2002:a05:6512:441:: with SMTP id y1mr23314010lfk.315.1643823866351;
 Wed, 02 Feb 2022 09:44:26 -0800 (PST)
MIME-Version: 1.0
References: <20220126025739.2014888-1-jannh@google.com> <87czk5l2i6.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87czk5l2i6.fsf@email.froward.int.ebiederm.org>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 2 Feb 2022 18:43:59 +0100
Message-ID: <CAG48ez3byq=Cn4xGt5HmLBy9fWBapX9RdF-9JOaAus=rDR2TYQ@mail.gmail.com>
Subject: Re: [PATCH] coredump: Also dump first pages of non-executable ELF libraries
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Bill Messmer <wmessmer@microsoft.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 2, 2022 at 4:19 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Jann Horn <jannh@google.com> writes:
>
> > When I rewrote the VMA dumping logic for coredumps, I changed it to
> > recognize ELF library mappings based on the file being executable instead
> > of the mapping having an ELF header. But turns out, distros ship many ELF
> > libraries as non-executable, so the heuristic goes wrong...
> >
> > Restore the old behavior where FILTER(ELF_HEADERS) dumps the first page of
> > any offset-0 readable mapping that starts with the ELF magic.
> >
> > This fix is technically layer-breaking a bit, because it checks for
> > something ELF-specific in fs/coredump.c; but since we probably want to
> > share this between standard ELF and FDPIC ELF anyway, I guess it's fine?
> > And this also keeps the change small for backporting.
>
> In light of the conflict with my other changes, and in light of the pain
> of calling get_user.
>
> Is there any reason why the doesn't unconditionally dump all headers?
> Something like the diff below?
>
> I looked in the history and the code was filtering for ELF headers
> there already.  I am just thinking this feels like a good idea
> regardless of the file format to help verify the file on-disk
> is the file we think was mapped.

Yeah, I guess that's reasonable. The main difference will probably be
that the starting pages of some font files, locale files and python
libraries will also be logged.
