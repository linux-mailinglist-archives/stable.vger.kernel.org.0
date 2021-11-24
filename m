Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E27B45C9D3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbhKXQYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:24:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348409AbhKXQYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 11:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637770898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=90TigdZMMnC7ewblMejePQnNAjZkBXfCyuwYeUoTC3s=;
        b=P9pHl8judLcOrChG1VENmsc10NDesdh8KXSw4J9GPHGcKdwEhVSeX4jly7dMdJQNSc1xmi
        F5uK+xOpN5uphLr2YnRC5bW5ZGktq2Irp4vIMp6hOeDhtJZ/yWv3JlzCIHlceHilDr8DCK
        QRMpPVugO5p+MSp/jKb1QWb4v/v43L8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-klCk5UPgPJ-uKSf0ZGXNug-1; Wed, 24 Nov 2021 11:21:37 -0500
X-MC-Unique: klCk5UPgPJ-uKSf0ZGXNug-1
Received: by mail-qt1-f200.google.com with SMTP id o12-20020a05622a008c00b002aff5552c89so2423672qtw.23
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:21:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=90TigdZMMnC7ewblMejePQnNAjZkBXfCyuwYeUoTC3s=;
        b=VDoHwlCS3aa3ZiBypJcXqfR/YzcCZAD5IRdOkGmm10+FaPjCM8GcVKyzssTIu5h4pS
         3m6SV2KG/75thzUNyYqYUiD21WuWituA6cFf5sJtCoTiOi47M7+9dhFuBknRNiTbJJqC
         icE5GePDO9g/vEkNK9h3Khx2fBwfW7gNr9N52XKYpivsMiIR9UStjiQuuSa8YjN/w3Fw
         0liodnqdafPmtir9mDLKLMeEs4csM102n7jhP8fkGHGqsif2gqhh/Xs+qTG0IMFVH31J
         zH4HvSJbDbl3r3Hnn9s1y46aB3q+ICukLwcRJwuq5d76lDmDE+90pw4lnYCqaB0rxuNw
         WPbA==
X-Gm-Message-State: AOAM531mQkB1rGwQSbamT3EhiZRhiiTdx8oRtlID83UTdA/dinmr5Cuc
        zDvAkWfZxXkRBKNFFsNqqP91xJlf6l+d0eA7xSF4xqUfMn/5fNzIDvDcWLQSTag54RQ3xYiLx5G
        nSU3USKbu1XKrAd+8q4BHZYpemMOfZQIT
X-Received: by 2002:a05:620a:298e:: with SMTP id r14mr7132017qkp.509.1637770897313;
        Wed, 24 Nov 2021 08:21:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+fhe6xQgUQvMw7x2eFGQXvQxfQ2GkuBX44MmkUSmaXmqu6/TnUHIiNOX11TRYsRT4PyQD0pb69t7BShFnHq0=
X-Received: by 2002:a05:620a:298e:: with SMTP id r14mr7131993qkp.509.1637770897141;
 Wed, 24 Nov 2021 08:21:37 -0800 (PST)
MIME-Version: 1.0
References: <20211124115658.328640564@linuxfoundation.org> <20211124115701.855204038@linuxfoundation.org>
In-Reply-To: <20211124115701.855204038@linuxfoundation.org>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Wed, 24 Nov 2021 17:21:26 +0100
Message-ID: <CAOssrKd=XAvCKW9t0gk9g_FBqFs6pPNJFsP7pc2EF6Dcj-se7w@mail.gmail.com>
Subject: Re: [PATCH 4.4 109/162] fuse: fix page stealing
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Frank Dinoff <fdinoff@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 1:04 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Miklos Szeredi <mszeredi@redhat.com>
>
> commit 712a951025c0667ff00b25afc360f74e639dfabe upstream.
>
> It is possible to trigger a crash by splicing anon pipe bufs to the fuse
> device.
>
> The reason for this is that anon_pipe_buf_release() will reuse buf->page if
> the refcount is 1, but that page might have already been stolen and its
> flags modified (e.g. PG_lru added).
>
> This happens in the unlikely case of fuse_dev_splice_write() getting around
> to calling pipe_buf_release() after a page has been stolen, added to the
> page cache and removed from the page cache.
>
> Fix by calling pipe_buf_release() right after the page was inserted into
> the page cache.  In this case the page has an elevated refcount so any
> release function will know that the page isn't reusable.
>
> Reported-by: Frank Dinoff <fdinoff@google.com>
> Link: https://lore.kernel.org/r/CAAmZXrsGg2xsP1CK+cbuEMumtrqdvD-NKnWzhNcvn71RV3c1yw@mail.gmail.com/
> Fixes: dd3bb14f44a6 ("fuse: support splice() writing to fuse device")
> Cc: <stable@vger.kernel.org> # v2.6.35
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Hi Greg,

This patch turned out to have a bug, so stable releases that didn't
yet have it released might be better off backing it out for now and
releasing only together with the fix to avoid regressions.

Thanks,
Miklos

