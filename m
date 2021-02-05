Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98673118D5
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 03:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhBFCrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 21:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhBFClG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 21:41:06 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE27C08ECAB;
        Fri,  5 Feb 2021 14:31:36 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id f1so12141356lfu.3;
        Fri, 05 Feb 2021 14:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=15xZIlhRM3LdLmJHcO1w7aAs76lN+wDvfvxtiXcJlvk=;
        b=jfbfeb5tgm6FKkYUne0SU2Txz5qMWk4Icdk6DzWGAcPFFIaa8nKKAgtnhAqs4TjvlY
         9XOG57AWSLjhFKaXojBYbcUQQ37BKZKd/ozA3crJBbxq2mgXfdIDeZ+sSMoef08RbvgQ
         Fywxo6n8AQ26ElAlKpOaWl9YD501OqjqzKre2qVrV86XkicTnmRUT4PxRZ3fZV+trNIi
         SXgT7wMjxE7Hro7m3vTMj75ZNkKwMODz7JgVGFgULi5+OoyEAsL+K2dAmlo1UgdkYKMR
         dKFQqrN8bZlxACCD+LUDASNemW5cJNUSv4kVzfQVUqzn7YBmHB2P6ztGR1yTcUeNoSgu
         DnLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=15xZIlhRM3LdLmJHcO1w7aAs76lN+wDvfvxtiXcJlvk=;
        b=mgMy3iHMOOdQqDjcDIJ/hw293TLjrtJYw06a+k2X5qtGki714XM3KQTDMjIXWlXar7
         6es7uMPUnTsECoKMhqQWW0d7GKdpZsHruykOtfhaq37f5tomFYGPWA2lD903HFCDpROB
         hhhPr8uXz3QXPoi2vSjwhmeuxHAT4aaUM6fOqtonEFLTwUyAfrykvUjMtpYnxsz+timY
         8SV0jM+BC7PLSfp++JKokv5QlFBDgzVTXwSONokMTwkqFQsOX5aQ5qak4ElLDG7KhxBC
         WisWC0MfC6X41ys+A4L5fEtcSVnsDerZWM6EFjWqnA8Wd7mmoLLWhr8mgz+xzZXijmdT
         TDsg==
X-Gm-Message-State: AOAM533V2iP3aL51P+O+N3GtqKxM1xNDnONEJsWkxiBl4vJUdCTuHlEk
        UeFVNniXPDkJpaLVcYuGQTAXshPMQbnawMUl8lQgJ2yldCM=
X-Google-Smtp-Source: ABdhPJzwAaCWi/dSp6MPmSt2EtE1HV97PMbSXSvtHh6XVivMUnBdE0MesPEPjMJ7E2p/0bUEdiqrB9mF2XWMVwEINgg=
X-Received: by 2002:a05:6512:1311:: with SMTP id x17mr3608227lfu.307.1612564294768;
 Fri, 05 Feb 2021 14:31:34 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o4b9RfQ5omd911pLH3WFbiC1-ghF43kRZ5-4SV+PeS=g@mail.gmail.com>
 <20210205144248.13508-1-aaptel@suse.com>
In-Reply-To: <20210205144248.13508-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 Feb 2021 16:31:23 -0600
Message-ID: <CAH2r5mvBC7_WXuu3i3S7qffvj1pbhRUvv+HtY2fs49vSVmKS8Q@mail.gmail.com>
Subject: Re: [PATCH v4] cifs: report error instead of invalid when
 revalidating a dentry fails
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next, since it seems to have
fixed the problem we saw with test generic/070


On Fri, Feb 5, 2021 at 8:42 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> Assuming
> - //HOST/a is mounted on /mnt
> - //HOST/b is mounted on /mnt/b
>
> On a slow connection, running 'df' and killing it while it's
> processing /mnt/b can make cifs_get_inode_info() returns -ERESTARTSYS.
>
> This triggers the following chain of events:
> =3D> the dentry revalidation fail
> =3D> dentry is put and released
> =3D> superblock associated with the dentry is put
> =3D> /mnt/b is unmounted
>
> This patch makes cifs_d_revalidate() return the error instead of 0
> (invalid) when cifs_revalidate_dentry() fails, except for ENOENT (file
> deleted) and ESTALE (file recreated).
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> Suggested-by: Shyam Prasad N <nspmangalore@gmail.com>
> CC: stable@vger.kernel.org
>
> ---
>  fs/cifs/dir.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 68900f1629bff..97ac363b5df16 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -737,6 +737,7 @@ static int
>  cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
>  {
>         struct inode *inode;
> +       int rc;
>
>         if (flags & LOOKUP_RCU)
>                 return -ECHILD;
> @@ -746,8 +747,25 @@ cifs_d_revalidate(struct dentry *direntry, unsigned =
int flags)
>                 if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(ino=
de)))
>                         CIFS_I(inode)->time =3D 0; /* force reval */
>
> -               if (cifs_revalidate_dentry(direntry))
> -                       return 0;
> +               rc =3D cifs_revalidate_dentry(direntry);
> +               if (rc) {
> +                       cifs_dbg(FYI, "cifs_revalidate_dentry failed with=
 rc=3D%d", rc);
> +                       switch (rc) {
> +                       case -ENOENT:
> +                       case -ESTALE:
> +                               /*
> +                                * Those errors mean the dentry is invali=
d
> +                                * (file was deleted or recreated)
> +                                */
> +                               return 0;
> +                       default:
> +                               /*
> +                                * Otherwise some unexpected error happen=
ed
> +                                * report it as-is to VFS layer
> +                                */
> +                               return rc;
> +                       }
> +               }
>                 else {
>                         /*
>                          * If the inode wasn't known to be a dfs entry wh=
en
> --
> 2.29.2
>


--
Thanks,

Steve
