Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BD841DE3
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 09:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfFLHiB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 12 Jun 2019 03:38:01 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:47099 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731536AbfFLHh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 03:37:59 -0400
Received: by mail-oi1-f193.google.com with SMTP id 203so10957886oid.13
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 00:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l8RlG1QWsV/msA4GPsw+qPoVYVJEbhy9x3gDEX1sGFk=;
        b=IrB2oe/IvRsKizy6f0GTFYYSBFR/iQoYcDY0L+S6j7sIC/oRw2pGGXt1VBzsQs5boa
         JY6IeQrrdGZ9vJDJHyU4F2zk9fywVH2rllGiVFS18cuG8qlTEjsSZQE0oAkTeAEw90zQ
         J6H/P7X38jeSWAPJMhp5in0oZia0gzELKWBjGYkY3cfAZI+sNItBtvd8tw/dbirUjdib
         a8R10pdXR9I2hWpyYghygq5U7S2/s3+7yJRFni9gbKa4pbVLvg/PYd2IiHVxFhpBEg/A
         8/eGWhHCk9S0TkTGbjcKXOUAgM9hVDfQcC3nhKx3H37zG7J/nLNR9nNE6rUG08kmHxwA
         c3Eg==
X-Gm-Message-State: APjAAAXrrQpza9MP4yN8GPpOt73DsMYv9b92pOd15heDczFbBaInaR8/
        zjpc6daN8EkbGM+1reho2Iyntf7uY9uGOR52Jxnl5Q==
X-Google-Smtp-Source: APXvYqxGKrbj6VKPiGuz//7rL8OPpyEVFKxqjgiw5dinTi//xSsvie2H8Alt5tbXuOOO3FPX86WAo29s+gzREwF6Roc=
X-Received: by 2002:aca:ed04:: with SMTP id l4mr18335533oih.26.1560325078322;
 Wed, 12 Jun 2019 00:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190611080719.28625-1-omosnace@redhat.com> <CAHC9VhSXZp6QierOGRBXmyUf=pT3Y4mf=78AmQAquuQ8-WBSGw@mail.gmail.com>
In-Reply-To: <CAHC9VhSXZp6QierOGRBXmyUf=pT3Y4mf=78AmQAquuQ8-WBSGw@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 12 Jun 2019 09:37:47 +0200
Message-ID: <CAFqZXNsD06JYYNmpOYyGrxLHCfvVyUSJMZ3mRTWG5-b2Ws7zQw@mail.gmail.com>
Subject: Re: [PATCH] selinux: log raw contexts as untrusted strings
To:     Paul Moore <paul@paul-moore.com>
Cc:     selinux@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 12:56 AM Paul Moore <paul@paul-moore.com> wrote:
> On Tue, Jun 11, 2019 at 4:07 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > These strings may come from untrusted sources (e.g. file xattrs) so they
> > need to be properly escaped.
> >
> > Reproducer:
> >     # setenforce 0
> >     # touch /tmp/test
> >     # setfattr -n security.selinux -v 'kuřecí řízek' /tmp/test
> >     # runcon system_u:system_r:sshd_t:s0 cat /tmp/test
> >     (look at the generated AVCs)
> >
> > Actual result:
> >     type=AVC [...] trawcon=kuřecí řízek
> >
> > Expected result:
> >     type=AVC [...] trawcon=6B75C5996563C3AD20C599C3AD7A656B
> >
> > Fixes: fede148324c3 ("selinux: log invalid contexts in AVCs")
> > Cc: stable@vger.kernel.org # v5.1+
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  security/selinux/avc.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
>
> Thanks, the patch looks fine to me, but it is borderline -stable
> material in my opinion.  I'll add it to the stable-5.2 branch, but in
> the future I would prefer if you left the stable marking off patches
> and sent a reply discussing *why* this should go to stable so we can
> discuss it.  I realize Greg likes to pull a lot of stuff into stable,
> but I try to be a bit more conservative about what gets marked.  Even
> the simplest fix can still break things :)

OK, I was a bit unsure whether to mark it as stable or not and
eventually inclined to do so... I'll try be more careful about it in
the future.

>
> I'm going to start building a test kernel now with this fix, but I
> might hold off on sending this up to Linus for a couple of days to see
> if I can catch Gen Zhang's patches in the same PR.
>
> > diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> > index 8346a4f7c5d7..a99be508f93d 100644
> > --- a/security/selinux/avc.c
> > +++ b/security/selinux/avc.c
> > @@ -739,14 +739,20 @@ static void avc_audit_post_callback(struct audit_buffer *ab, void *a)
> >         rc = security_sid_to_context_inval(sad->state, sad->ssid, &scontext,
> >                                            &scontext_len);
> >         if (!rc && scontext) {
> > -               audit_log_format(ab, " srawcon=%s", scontext);
> > +               if (scontext_len && scontext[scontext_len - 1] == '\0')
> > +                       scontext_len--;
> > +               audit_log_format(ab, " srawcon=");
> > +               audit_log_n_untrustedstring(ab, scontext, scontext_len);
> >                 kfree(scontext);
> >         }
> >
> >         rc = security_sid_to_context_inval(sad->state, sad->tsid, &scontext,
> >                                            &scontext_len);
> >         if (!rc && scontext) {
> > -               audit_log_format(ab, " trawcon=%s", scontext);
> > +               if (scontext_len && scontext[scontext_len - 1] == '\0')
> > +                       scontext_len--;
> > +               audit_log_format(ab, " trawcon=");
> > +               audit_log_n_untrustedstring(ab, scontext, scontext_len);
> >                 kfree(scontext);
> >         }
> >  }
> > --
> > 2.20.1
>
> --
> paul moore
> www.paul-moore.com



-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
