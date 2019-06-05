Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22488354B8
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 02:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfFEAVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 20:21:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42016 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFEAVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 20:21:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id e6so10071551pgd.9;
        Tue, 04 Jun 2019 17:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pgZyi+TWQp0b83ordEQ0pY7oXdcD+RbM5gH3ankJN6o=;
        b=nKHZjTACUcMdwvx/qFygexo+AOrlr0r76e1eYA5qo3hpv2om0ZjeFXq4fIlY9mODgf
         5ElPfz4OseqxYLtN0ujXUMtPK8CUjU33pRLaIWwCBkjK8R+Mf5ppTl8kM8BShYYyYyjS
         Lc5XS0sofsvlEJWm7NK4RuMRGXEs8CTe6J5VFhJ88xEcU3Fvqr/Te9/Axqa4LWL/LziS
         eugUeQ20MOwl9WE+mNS6qnLOOy2jRGmB+EOGcq+9xIUenX88TpGlvN/S7fXuEtriucc3
         WP5/+zHTSIEDwkxdmfXwZc9Ulp5D2gyZvh+d7HPDhM8OqL7gqhe/LjquJPBxJNwT/Rxy
         /yIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pgZyi+TWQp0b83ordEQ0pY7oXdcD+RbM5gH3ankJN6o=;
        b=VL7smcAFmWGKBjmlvfCH+vlm9gLzUZo56kz4Dnra8dj1FxdJl2YQilDZxnjj/GfSvj
         8zeUedynDrE7+DPjjpnpF83qYFInybowV7MGLVpcPMxRZe2WW3TPpcQwmXm8GEao769C
         jtvozJsf3+FIrZiiGRHQQEgHfz0S/NKUeyKWDOSUMSoH/nVO67QBIh06HMeNfK6fLT10
         vaCFHwUczNim9Pkx8SNns/78os+jUE/2wzimr7I/+j1+WiJhjAsAJlFlQV4n8Y31D4kO
         tZrQWmm4eqKV94fR0yvYbix9CEzL5hXVICm/f9zWX1384n4d3ZOMwd91jiRUpAmAcppW
         HHSw==
X-Gm-Message-State: APjAAAUl0vZg5LQbu3iHTsGDz9yzbNHhv9QQ9LU59wbzVZ3BGHj/JbGJ
        SwfZuXJHKOGWoLvVr1es4Q3AQDTImtglV5TvGzEHs+Ue
X-Google-Smtp-Source: APXvYqyva+Ai55/epJ8vzKWFL2MjStLJN4bqzJiHFWMo1K4kMiWMMFKY+vVJu9Q+H4vrYEWrdr3Hm1SS2swiBmBCEWc=
X-Received: by 2002:a17:90a:8982:: with SMTP id v2mr39038396pjn.138.1559694089672;
 Tue, 04 Jun 2019 17:21:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190605001534.28278-1-lsahlber@redhat.com>
In-Reply-To: <20190605001534.28278-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 4 Jun 2019 19:21:18 -0500
Message-ID: <CAH2r5mskCwZykiDqUzR_1rF7U4GZW3cVKuGMXWRS1Aq=X9CiSQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix panic in smb2_reconnect
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tentatively merged into cifs-2.6.git for-next (and to the github tree
for next buildbot run)

On Tue, Jun 4, 2019 at 7:15 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RH Bugzilla: 1702264
>
> We need to protect so that the call to smb2_reconnect() in
> smb2_reconnect_server() does not end up freeing the session
> because it can lead to a use after free and crash.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 565b60b62f4d..ab8dc73d2282 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3113,9 +3113,14 @@ void smb2_reconnect_server(struct work_struct *work)
>                                 tcon_exist = true;
>                         }
>                 }
> +               /*
> +                * IPC has the same lifetime as its session and uses its
> +                * refcount.
> +                */
>                 if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect) {
>                         list_add_tail(&ses->tcon_ipc->rlist, &tmp_list);
>                         tcon_exist = true;
> +                       ses->ses_count++;
>                 }
>         }
>         /*
> @@ -3134,7 +3139,10 @@ void smb2_reconnect_server(struct work_struct *work)
>                 else
>                         resched = true;
>                 list_del_init(&tcon->rlist);
> -               cifs_put_tcon(tcon);
> +               if (tcon->ipc)
> +                       cifs_put_smb_ses(tcon->ses);
> +               else
> +                       cifs_put_tcon(tcon);
>         }
>
>         cifs_dbg(FYI, "Reconnecting tcons finished\n");
> --
> 2.13.6
>


-- 
Thanks,

Steve
