Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5FBC41879
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 00:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436750AbfFKW4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 18:56:21 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41755 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436971AbfFKW4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 18:56:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id s21so13321024lji.8
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 15:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UScBCj1990BVlduYhjEjZO8DvaVBEZygOQq5R++5jBU=;
        b=h/fMYVlzXohUsYXVqGlAQg+VF1DcgMP20jyQOEs9YAX4WZmM8C4gkGlDl3BrOHKrNg
         YniodCgimo7I2vE96B9XnivOnwGbtKDlOzoDSdVwEH5HAzKks5PVy+Nhl8bnSARMsxST
         UNOs6JL7vMWACSK3nSKWioA0RmwRl/zFcdR+P/T+OiDHFfxOF7Ief9VEsd2R/irMIAdg
         HrNAehA5YJamdl8Uky0VnmfBkXhamENu+qvJTjv6gAxfxgG1XhOo3/SRbrSAfPnc/CQG
         8rqjAXdHTsFrTf1fuNqBQ6fkzhOyCnbhGL8uwzGLQOkmjo7abnqX55wP4z8KjM0fgMqO
         HLVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UScBCj1990BVlduYhjEjZO8DvaVBEZygOQq5R++5jBU=;
        b=jwjfmO/y9Vg8PLJXjCCfQp2BAywBrexcG2qWE8+W7QSpwSXxH1/U+gKidqsFeO+Vyu
         3qm2Y3lyeXUriGnN97aSOYlJmSLLuhUd1dWwMJ5EzPWj9buGOAydBjTkxirvq4qbu/z0
         r7ADdYkWcXpuC9f0sDb0BiM/t2O3zDYlF5L/FSxXAVvWcKv8wr9Mce8I1Dsyw9mXt5re
         HPELldn/BTdmDTUsL6uw8Hoh3T1DyYLsXU4v/jUfANnQ3akNOvegp6rMO1Ybhsmbj0fF
         4skm9a1RswVe12nTbQa5CR4CCcI2lK5gkvaJSdJgygcugrwjstluaaPHUF+K5UEmxFiu
         u/fw==
X-Gm-Message-State: APjAAAWI2Z5QFL69gjHwARKTPNVPyqmQL6bbmoAjJCZAKxh2Pg3TCu50
        fWFsJykN4tJKTJLfdRHKc3TB9eDs4YeyGIQvzAIs
X-Google-Smtp-Source: APXvYqwtxK+/bIRr62KFoQFlOyzNPs5ldqCN7Rv6OQD1h2T8J38lOn5K6QCTh1FuTca1QK796UfokyzhNWn9yHXqvgI=
X-Received: by 2002:a2e:9dd7:: with SMTP id x23mr8869166ljj.160.1560293779452;
 Tue, 11 Jun 2019 15:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190611080719.28625-1-omosnace@redhat.com>
In-Reply-To: <20190611080719.28625-1-omosnace@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 11 Jun 2019 18:56:07 -0400
Message-ID: <CAHC9VhSXZp6QierOGRBXmyUf=pT3Y4mf=78AmQAquuQ8-WBSGw@mail.gmail.com>
Subject: Re: [PATCH] selinux: log raw contexts as untrusted strings
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     selinux@vger.kernel.org, linux-audit@redhat.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 4:07 AM Ondrej Mosnacek <omosnace@redhat.com> wrote=
:
> These strings may come from untrusted sources (e.g. file xattrs) so they
> need to be properly escaped.
>
> Reproducer:
>     # setenforce 0
>     # touch /tmp/test
>     # setfattr -n security.selinux -v 'ku=C5=99ec=C3=AD =C5=99=C3=ADzek' =
/tmp/test
>     # runcon system_u:system_r:sshd_t:s0 cat /tmp/test
>     (look at the generated AVCs)
>
> Actual result:
>     type=3DAVC [...] trawcon=3Dku=C5=99ec=C3=AD =C5=99=C3=ADzek
>
> Expected result:
>     type=3DAVC [...] trawcon=3D6B75C5996563C3AD20C599C3AD7A656B
>
> Fixes: fede148324c3 ("selinux: log invalid contexts in AVCs")
> Cc: stable@vger.kernel.org # v5.1+
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  security/selinux/avc.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Thanks, the patch looks fine to me, but it is borderline -stable
material in my opinion.  I'll add it to the stable-5.2 branch, but in
the future I would prefer if you left the stable marking off patches
and sent a reply discussing *why* this should go to stable so we can
discuss it.  I realize Greg likes to pull a lot of stuff into stable,
but I try to be a bit more conservative about what gets marked.  Even
the simplest fix can still break things :)

I'm going to start building a test kernel now with this fix, but I
might hold off on sending this up to Linus for a couple of days to see
if I can catch Gen Zhang's patches in the same PR.

> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index 8346a4f7c5d7..a99be508f93d 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -739,14 +739,20 @@ static void avc_audit_post_callback(struct audit_bu=
ffer *ab, void *a)
>         rc =3D security_sid_to_context_inval(sad->state, sad->ssid, &scon=
text,
>                                            &scontext_len);
>         if (!rc && scontext) {
> -               audit_log_format(ab, " srawcon=3D%s", scontext);
> +               if (scontext_len && scontext[scontext_len - 1] =3D=3D '\0=
')
> +                       scontext_len--;
> +               audit_log_format(ab, " srawcon=3D");
> +               audit_log_n_untrustedstring(ab, scontext, scontext_len);
>                 kfree(scontext);
>         }
>
>         rc =3D security_sid_to_context_inval(sad->state, sad->tsid, &scon=
text,
>                                            &scontext_len);
>         if (!rc && scontext) {
> -               audit_log_format(ab, " trawcon=3D%s", scontext);
> +               if (scontext_len && scontext[scontext_len - 1] =3D=3D '\0=
')
> +                       scontext_len--;
> +               audit_log_format(ab, " trawcon=3D");
> +               audit_log_n_untrustedstring(ab, scontext, scontext_len);
>                 kfree(scontext);
>         }
>  }
> --
> 2.20.1

--=20
paul moore
www.paul-moore.com
