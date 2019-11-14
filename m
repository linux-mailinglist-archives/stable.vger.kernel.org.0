Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61ECDFC9FB
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 16:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfKNPey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 10:34:54 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45426 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfKNPey (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 10:34:54 -0500
Received: by mail-io1-f68.google.com with SMTP id v17so7215147iol.12
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 07:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUlRU9cKKaNVZQJfAQT/do7G2k04lqCGA4z6vNnMsGQ=;
        b=Gf3JcA/6I5FyJbc72sKAqamUPXFxiPVt7Hj5319gDyzsYiJMudzuRdZXmvEpYlK/My
         4UW7i5B9KNCTYQn7nI9dTWijqpLioNvi2TfIVwOFIykEZObvThrKzFX9U8pmytRR07+e
         elXel76PlSzf5sFKyKbZ4XcUWsTA4iLSFjtn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUlRU9cKKaNVZQJfAQT/do7G2k04lqCGA4z6vNnMsGQ=;
        b=ICG90WRweUSYCLBL0V1DWvYpT+yiOoKbFWZhfCP/wtFHt6+4le41Be7GdmJ18t3dm2
         Lu8X4PMYnfUDVm9YObjcdtOEaVfvtYqMcGCAsABMENyoL2pQoclSMfH6ghtDT4znRxxh
         7GkPn9x6kZQ8LtY+IrDX7UahXoZ4vTUR7oTVXzjBouTQ6eeK2vnOBADseH2XgsZ8XSEx
         BI7OrRuU2tm2WjUe+nu2kZYgvwwIzG/t9mNzsc5ZwDmshmSsO+hsYWNH7rsVe0GApRPl
         Yfal66RVQQ87aaKyZ108cmycOkGmA3UmjVzKPGB5Jx/wKgxbWHO7c8hbFTWY6kbdKiU2
         pY/Q==
X-Gm-Message-State: APjAAAUTybTcw83Aww1xOqrBXiZdFgwsrnPpT0s/ixHS1nHU7zPZK3Jx
        XPSAbj2MJf/q6hddojpTbtcb7wM++OCtOj35b+yyzA==
X-Google-Smtp-Source: APXvYqzSGRk8kaQZw1eAWtpTrcv0aiDPDHw7DokTcyToLRrifSAcy/pMiW4l+KCNIFd1O0AHk+CEm1Ze7LF4tMBSKQc=
X-Received: by 2002:a6b:3bca:: with SMTP id i193mr7558649ioa.285.1573745693624;
 Thu, 14 Nov 2019 07:34:53 -0800 (PST)
MIME-Version: 1.0
References: <20191107104957.306383-1-colin.king@canonical.com>
 <CAJfpegtr_xg_VG2npTfaxC+vD7B8bKa_0n9pu5vyfU-XQ9oV9Q@mail.gmail.com>
 <CAOQ4uxhnpeyK6xW-c5NOQZ_h1uhAOUn_BbVVVYhUgZ74KSKDKQ@mail.gmail.com>
 <CAJfpegu7egxf=BVyVQKKW_icjMbjdLcLdd1FEw5hXLvDaiLNVQ@mail.gmail.com> <CAOQ4uxh8n-QW+zTe3Y56suyaQf8Tcascj337AbMmKF7jf9=sjw@mail.gmail.com>
In-Reply-To: <CAOQ4uxh8n-QW+zTe3Y56suyaQf8Tcascj337AbMmKF7jf9=sjw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 14 Nov 2019 16:34:42 +0100
Message-ID: <CAJfpegvKnWR6_aPFwjcP8E7CRPesHPc3Svk=n9=39CnM=Mjfvg@mail.gmail.com>
Subject: Re: [PATCH][V2] ovl: fix lookup failure on multi lower squashfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Colin King <colin.king@canonical.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 14, 2019 at 3:37 PM Amir Goldstein <amir73il@gmail.com> wrote:

> What Colin has now reported brings to light the fact that
> decoding lower file handles was also required for making inode
> numbers persistent.
>
> So the bad_uuid condition is required for all of the above, not
> just for decoding origin.
>
> > Can we do a message that makes
> > that somewhat more clearer?
> >
>
> What about the logs:
>
>                 pr_warn("overlayfs: upper fs does not support xattr,
> falling back to index=off and metacopy=off.\n");
>                 pr_warn("overlayfs: upper fs does not support file
> handles, falling back to index=off.\n");
>                 pr_warn("overlayfs: fs on '%s' does not support file
> handles, falling back to index=off,nfs_export=off.\n",
>
> Should we also change them to reflect the fact the decoding origin
> is not supported???
>
> Seems like a lot of hassle that will end up writing too much information
> that most people won't understand.
>
> IIRC, we also do not guaranty persistent inode numbers for hardlinks
> when index=off.
>
> As for the change in question (falling back => enforcing), if that bothers you,
> we can get rid of this change by testing emitting the print only if
> (ofs->config.nfs_export || ofs->config.index).

That makes sense.

It would also make sense to have a section about inode number
persistence in the documentation.

Thanks,
Miklos
