Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ED52E92BB
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbhADJlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 04:41:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbhADJlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 04:41:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609753194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XVjW4HSk1hVwXdQeczGzcQ5veMflMC10yNN5cPRpH0g=;
        b=P0IleynHahW+e1MRwQim7vsrc1Vmm5i0RiidtoRGD8XBEarGtkUyPxS7MoIb+tx79cj5La
        eEfW4/yqcd5+Ky7KHo7/6faUBFmgrxTZaHhM8ZS/kA2TNeRz7A7sPXSN3sDE6OeeE31i+A
        bBndtFUFA06kKKOP01SKebZoSfQx/HM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-TelMdUcGMc6RtvQSzSOCUw-1; Mon, 04 Jan 2021 04:39:50 -0500
X-MC-Unique: TelMdUcGMc6RtvQSzSOCUw-1
Received: by mail-lf1-f72.google.com with SMTP id 25so16658786lft.1
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 01:39:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XVjW4HSk1hVwXdQeczGzcQ5veMflMC10yNN5cPRpH0g=;
        b=sV2UeJeAy0iK4bn+B39n0hd6AkCUF5v/jrIn5B2tD1lcm81b341lpOrH+KMXIOYOOZ
         tf6/a/omVVbVjiUJ7Ij1Zu49v34xiIzm277BvzNDSjgXylkEUzlaNOUUjisltjzI+zhE
         vSIadRaiznjU9Yju0B1P891lZgRUk7SElo4ibnw8k6i57rj/H3nIvxLGV2OiWjqKkyVZ
         awogZnLnA6KM36TU6z9z+k4YscXDcINzLyPM3XnQ7/b6ftvkaSzKURPmqthRId/VNYtG
         RSXA7seVctKyjcWAynD6vOPJEAK1mHC318IFP/03S3x7EBBaVEDHEVUYTz3rsGUOR/2i
         Ni8g==
X-Gm-Message-State: AOAM533gy/YEm/sODRuFAFft0U2tRArcSYykvjeCBAhXP9Pw98WJ5vr/
        qdzg2m6Hm2mw10fSWR+BDuxJXtfDiZCuPgfE3Rgvgv5h8ocbUXlwkLyPniX16tdUzmmsm7SbY1Y
        A3SAEufjFZsXYBxHqWannn5uQXuZ0B7fT
X-Received: by 2002:a05:6512:2f7:: with SMTP id m23mr23333199lfq.517.1609753189246;
        Mon, 04 Jan 2021 01:39:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwVqGu3rr3EuajkBL+S5l4IUuczgGkXJjRybffxYfPraoTA1d3B/A9pl2Fm+WEHVQQLsOX3YZNPWFKZp/FM7VY=
X-Received: by 2002:a05:6512:2f7:: with SMTP id m23mr23333186lfq.517.1609753188974;
 Mon, 04 Jan 2021 01:39:48 -0800 (PST)
MIME-Version: 1.0
References: <20201219100527.16060-1-amir73il@gmail.com>
In-Reply-To: <20201219100527.16060-1-amir73il@gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 4 Jan 2021 10:39:32 +0100
Message-ID: <CAFqZXNtcX54bv2xeQ26_i-=9OkdiJQQzPOveY=aaujOWJjGWLA@mail.gmail.com>
Subject: Re: [PATCH] selinux: fix inconsistency between inode_getxattr and inode_listsecurity
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Michael Labriola <michael.d.labriola@gmail.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 11:07 AM Amir Goldstein <amir73il@gmail.com> wrote:
> When inode has no listxattr op of its own (e.g. squashfs) vfs_listxattr
> calls the LSM inode_listsecurity hooks to list the xattrs that LSMs will
> intercept in inode_getxattr hooks.
>
> When selinux LSM is installed but not initialized, it will list the
> security.selinux xattr in inode_listsecurity, but will not intercept it
> in inode_getxattr.  This results in -ENODATA for a getxattr call for an
> xattr returned by listxattr.
>
> This situation was manifested as overlayfs failure to copy up lower
> files from squashfs when selinux is built-in but not initialized,
> because ovl_copy_xattr() iterates the lower inode xattrs by
> vfs_listxattr() and vfs_getxattr().
>
> Match the logic of inode_listsecurity to that of inode_getxattr and
> do not list the security.selinux xattr if selinux is not initialized.
>
> Reported-by: Michael Labriola <michael.d.labriola@gmail.com>
> Tested-by: Michael Labriola <michael.d.labriola@gmail.com>
> Link: https://lore.kernel.org/linux-unionfs/2nv9d47zt7.fsf@aldarion.sourceruckus.org/
> Fixes: c8e222616c7e ("selinux: allow reading labels before policy is loaded")
> Cc: stable@vger.kernel.org#v5.9+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  security/selinux/hooks.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6b1826fc3658..e132e082a5af 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3406,6 +3406,10 @@ static int selinux_inode_setsecurity(struct inode *inode, const char *name,
>  static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
>  {
>         const int len = sizeof(XATTR_NAME_SELINUX);
> +
> +       if (!selinux_initialized(&selinux_state))
> +               return 0;
> +
>         if (buffer && len <= buffer_size)
>                 memcpy(buffer, XATTR_NAME_SELINUX, len);
>         return len;
> --
> 2.25.1

Looked at the logic in vfs_listxattr() and this looks reasonable.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

Thank you for the patch!

-- 
Ondrej Mosnacek
Software Engineer, Platform Security - SELinux kernel
Red Hat, Inc.

