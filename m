Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C57B98E2
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 23:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfITVXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 17:23:15 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42560 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfITVXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 17:23:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id c195so5981729lfg.9
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 14:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=w7JcJHFZt8aqkbkYpfqdK5SWXNwbdUoj5292w9SfVRg=;
        b=lo9AeMUNIffb9qzEPhX/cyiC+IKPHwZX7et/vlttZ6dE/O3dQwCDoHngAVzNLjDeVV
         yKv8fuMDbQHYkw78UNWIGkdCEOa8wCVcd3L9RepyySmDyJYue+54wdaiNMt3hmUCw/Jx
         ICvGJbIOfs65aC3j7sWE1uqHHCChawxP4+FKkDBTrmnaszweB5unR3pMdSv+KKnU89XE
         UmVV9JdQLi7cxfHkcHrFsEX3T4Sq5/JBU2MyQyyUBbIno3tEcxGwFBoanc+unS1VscD2
         /IXs6+6n1xYUS/70u9efeep38VcG5uZpp2VAYvhnWSp9xmMsZ9OKNzrXKiXlKepuCkrN
         7d3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=w7JcJHFZt8aqkbkYpfqdK5SWXNwbdUoj5292w9SfVRg=;
        b=rHU4Lzm5tswv0yByN+pmkt8OODO5TdPiEa0lzP9ZD1oEauFXWKz3Zqhtii/HzM0Ou6
         05OeOd7x8JvBzmUPfTUOxbkVwr/HOAiwy6s61lfjLEMoeJf7Oa+JtEtSVMRaFWr7VeO0
         AkfQl9cPg5orbi/Tu+It+Ae5P9iAKue/K+10/O0rWO7jC6t6R7tRX7FoOdfBLiHCaoqv
         6r9X2QoKrppEf7QSup91vcHkulpqYDouhwS1oppesqw4MR+FuE6m4WmMw4SJsc7l2+2M
         QUS7LJOAwbN/gmVEfqHfFiBRj0jQPVZlQN7ALnRmAZHvcNdoncjDSGehsI3czbK4IdPP
         PZuQ==
X-Gm-Message-State: APjAAAVItr+WbRbbc2CU89RVrV26tWIjgKV/6j2bX7hp/5uV62/isf1N
        4DsqHVIGgpKoc6Iisk7YJu0Pu6GpxiHRiFLxzqYFQ3k=
X-Google-Smtp-Source: APXvYqxR2bmoWQhgIL/XN+d+P6zvFv3iCQz//IP34knMV2EftyWCpXT5nlimBs6ZqnpbSTFPtR12L7t4M9glBXHiGao=
X-Received: by 2002:a19:7514:: with SMTP id y20mr3805350lfe.36.1569014591077;
 Fri, 20 Sep 2019 14:23:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190920210803.4405-1-pshilov@microsoft.com>
In-Reply-To: <20190920210803.4405-1-pshilov@microsoft.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 20 Sep 2019 14:23:00 -0700
Message-ID: <CAKywueSieSuPBkSbaLkzFq7i=BDCjQidz9i09NeY5WmGRa9Q=g@mail.gmail.com>
Subject: Re: [PATCH] CIFS: fix deadlock in cached root handling
To:     Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fri, Sep 20, 2019 at 14:08, Pavel Shilovsky <piastryyy@gmail.com>:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> Commit 7e5a70ad88b1 ("CIFS: fix deadlock in cached root handling") upstream.
>
> Prevent deadlock between open_shroot() and
> cifs_mark_open_files_invalid() by releasing the lock before entering
> SMB2_open, taking it again after and checking if we still need to use
> the result.
>
> CC: <stable@vger.kernel.org> # v4.19+
> Link: https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com/T/#u
> Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/smb2ops.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index cc9e846a3865..094be406cde4 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -553,7 +553,50 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
>         oparams.fid = pfid;
>         oparams.reconnect = false;
>
> +       /*
> +        * We do not hold the lock for the open because in case
> +        * SMB2_open needs to reconnect, it will end up calling
> +        * cifs_mark_open_files_invalid() which takes the lock again
> +        * thus causing a deadlock
> +        */
> +       mutex_unlock(&tcon->crfid.fid_mutex);
>         rc = SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, NULL);
> +       mutex_lock(&tcon->crfid.fid_mutex);
> +
> +       /*
> +        * Now we need to check again as the cached root might have
> +        * been successfully re-opened from a concurrent process
> +        */
> +
> +       if (tcon->crfid.is_valid) {
> +               /* work was already done */
> +
> +               /* stash fids for close() later */
> +               struct cifs_fid fid = {
> +                       .persistent_fid = pfid->persistent_fid,
> +                       .volatile_fid = pfid->volatile_fid,
> +               };
> +
> +               /*
> +                * Caller expects this func to set pfid to a valid
> +                * cached root, so we copy the existing one and get a
> +                * reference
> +                */
> +               memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
> +               kref_get(&tcon->crfid.refcount);
> +
> +               mutex_unlock(&tcon->crfid.fid_mutex);
> +
> +               if (rc == 0) {
> +                       /* close extra handle outside of critical section */
> +                       SMB2_close(xid, tcon, fid.persistent_fid,
> +                                  fid.volatile_fid);
> +               }
> +               return 0;
> +       }
> +
> +       /* Cached root is still invalid, continue normaly */
> +
>         if (rc == 0) {
>                 memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
>                 tcon->crfid.tcon = tcon;
> @@ -561,6 +604,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
>                 kref_init(&tcon->crfid.refcount);
>                 kref_get(&tcon->crfid.refcount);
>         }
> +
>         mutex_unlock(&tcon->crfid.fid_mutex);
>         return rc;
>  }
> --
> 2.17.1
>

Forgot to mention that kernels 5.1.y and above already have the
appropriate patch. This is a backport for 4.19.

--
Best regards,
Pavel Shilovsky
