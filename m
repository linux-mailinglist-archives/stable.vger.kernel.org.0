Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE684001CE
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 17:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349547AbhICPOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 11:14:30 -0400
Received: from mo1.intermailgate.com ([91.203.103.210]:46620 "EHLO
        mo1.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241904AbhICPOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 11:14:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by mo1.intermailgate.com (Postfix) with ESMTP id EDF4C204A3
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 17:13:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630682008; bh=UMauVkLdv3l9ampxRH6KVgaRqPOE1tpGKJIqOCYZjdU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=SesYSAsDcV2br5LdW2UODJ2a5j4CczOlZVMgevT+rJ5pX5qZ1K0i+k5sITH5F+F7U
         BLFsJzPLZKsY2ZC1lGRMr9q4Anvat7Ikqk1birdyFJQlglLFmchzj3eVKAZJla1dDL
         DybfxNn6826uK+Z3z7bTdvbryqZAP9dKTza79ffY=
Received: from mail-lf1-f49.google.com (unknown [162.158.183.122])
        by mo1.intermailgate.com (Postfix) with ESMTPSA id AAB7920494
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 17:13:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630682008; bh=UMauVkLdv3l9ampxRH6KVgaRqPOE1tpGKJIqOCYZjdU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=SesYSAsDcV2br5LdW2UODJ2a5j4CczOlZVMgevT+rJ5pX5qZ1K0i+k5sITH5F+F7U
         BLFsJzPLZKsY2ZC1lGRMr9q4Anvat7Ikqk1birdyFJQlglLFmchzj3eVKAZJla1dDL
         DybfxNn6826uK+Z3z7bTdvbryqZAP9dKTza79ffY=
Received: by mail-lf1-f49.google.com with SMTP id p38so12486581lfa.0
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 08:13:28 -0700 (PDT)
X-Gm-Message-State: AOAM532XtGMX6mSbsqaTqDJNZ2DT7zdfbeQiUIsp7ZAbaJpMm/AMwir/
        BfvZb5pCnkESoKx4xNsKv0JCvJ4IGFF0EPJokic=
X-Google-Smtp-Source: ABdhPJwjC6fG4hfYrESYW1MSXCir6USeF091wf/LCMEhOcQ/ld8L4rpOK/+ZrssMCpbikZ1F+XMgYgJvOkcZEp1mWis=
X-Received: by 2002:a19:5e04:: with SMTP id s4mr3294462lfb.314.1630682007993;
 Fri, 03 Sep 2021 08:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ26g5THH5uZW2D86H64TXBE-OhdSLva8vGwF7Sdak1_R6PmRw@mail.gmail.com>
 <YTIw3/blzpQ3eadg@kroah.com>
In-Reply-To: <YTIw3/blzpQ3eadg@kroah.com>
From:   Patrick Schaaf <bof@bof.de>
Date:   Fri, 3 Sep 2021 17:13:08 +0200
X-Gmail-Original-Message-ID: <CAJ26g5T4BDaKUS66=2gh-4Lh-63OWwpdknpxf6GZuRxSxL4EoQ@mail.gmail.com>
Message-ID: <CAJ26g5T4BDaKUS66=2gh-4Lh-63OWwpdknpxf6GZuRxSxL4EoQ@mail.gmail.com>
Subject: Re: [PATCH] for 5.4 : kthread: Fix PF_KTHREAD vs to_kthread() race
To:     Greg KH <greg@kroah.com>
Cc:     Patrick Schaaf <bof@bof.de>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sigh. Sorry. Only got gmail. Feared that even when that says "plain
text mode", it would fuck it up...

Patch was practically identical to Peter's or the one you pulled into 5.10.62

I'll try a resend with mailx...

Patrick

On Fri, Sep 3, 2021 at 4:27 PM Greg KH <greg@kroah.com> wrote:
>
> On Fri, Sep 03, 2021 at 10:02:02AM +0200, Patrick Schaaf wrote:
> > After 3 days of successfully running 5.4.143 with this patch attached
> > and no issues, on a production workload (host + vms) of a busy
> > webserver and mysql database, I request queueing this for a future 5.4
> > stable, like the 5.10 one requested by Borislav; copying his mail text
> > in the hope that this is best form.
> >
> > please queue for 5.4 stable
> >
> > See https://bugzilla.kernel.org/show_bug.cgi?id=214159 for more info.
> >
> > ---
> > Commit 3a7956e25e1d7b3c148569e78895e1f3178122a9 upstream.
>
> <snip>
>
> This patch is corrupted and can not be applied :(
>
> Can you fix up your email client and resend?
>
> thanks,
>
> greg k-h
