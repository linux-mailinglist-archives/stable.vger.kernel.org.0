Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634F244C362
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 15:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhKJOzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 09:55:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231593AbhKJOzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 09:55:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636555935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JGaRarhvw23xm4PTZjUPJaQyjQW9oMGbXcgdEZdlsWo=;
        b=bpq+4tAjtLJi02ygf6uFhRIQpfQooVlKVgvjY2qAB0Hu7Pvt4gua9+nnkdt5Crz/WdKJva
        wvmWtBzvUW87Gb0UDFATvPdfQOn3eBG4L5vPUDyITZ82N6c/sS+qUw7Vr/aVJN95RK2iXM
        Mhhw3bOKR+dRI0BPQQqmtGjPHE1IGLc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-kv6ThWOANZeiLpOr5laCbQ-1; Wed, 10 Nov 2021 09:52:14 -0500
X-MC-Unique: kv6ThWOANZeiLpOr5laCbQ-1
Received: by mail-wm1-f72.google.com with SMTP id n16-20020a05600c3b9000b003331973fdbbso1321097wms.0
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 06:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGaRarhvw23xm4PTZjUPJaQyjQW9oMGbXcgdEZdlsWo=;
        b=SUVQTnoarv2jmpZkBftD5xJIYr0PRdnN8zcDDjsjfrU6hreGqn5MGGCyXhpphpzvgy
         VJkLDMVzh/BYS4Hnx/0bdB++Bl928FfwnQhXsXKH4e1/DN+HMOnb/+Ba2Hd0xKNAxeSw
         0dm4FVRHrHxg083PFjfzJQBKYU6IBXZYXZwOB1XW+m/LWOBdOskNp7l54n7f7GZS9pqq
         xASo3ti02G3JFoS78Elih3u5Mx0tmwO0K6P82/iYTY/km4Oc+Yeos55XK4jtyW199js7
         35gNBdDk2QTRXclShQ580CrHcfE+grHMyGSZ9ap1nEUKNAluBtY6VlpeMlTDZVyOHuO7
         FNdg==
X-Gm-Message-State: AOAM532gDIpWRzSXRUhQA4JEduvdtC28n+JCqzJOywrwo9KI8RviIz4U
        N0in7HLKS3jrroVH36zeMmpMdYrnQZ/NchT3izPwRJI+Z0yNOV7ZV+XJ6WfppTH6QUzoYcwyL98
        RFkZlMstvAmASJfAZvXPPXSVXC16Gan4M
X-Received: by 2002:a5d:43c5:: with SMTP id v5mr356454wrr.11.1636555932911;
        Wed, 10 Nov 2021 06:52:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6l6A0hw8OFbT4CeKMWuzjHe409Rc88qj5MEQ+MgMfrW4P0aNPr9xBjEscvoB2kMqOlJr33ybNzTxG6gtHVog=
X-Received: by 2002:a5d:43c5:: with SMTP id v5mr356435wrr.11.1636555932767;
 Wed, 10 Nov 2021 06:52:12 -0800 (PST)
MIME-Version: 1.0
References: <20211110113842.517426-1-agruenba@redhat.com> <20211110125527.GA25465@lst.de>
In-Reply-To: <20211110125527.GA25465@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 10 Nov 2021 15:52:01 +0100
Message-ID: <CAHc6FU49TnYvrL-FU5oz9th6STuQ=eYokjsD+0QpbkdHedRd9w@mail.gmail.com>
Subject: Re: [5.15 REGRESSION] iomap: Fix inline extent handling in iomap_readpage
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 1:55 PM Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Nov 10, 2021 at 12:38:42PM +0100, Andreas Gruenbacher wrote:
> > +     if (iomap->type == IOMAP_INLINE) {
> > +             /*
> > +              * The filesystem sets iomap->length to the size of the inline
> > +              * data.  We're at the end of the file, so we know that the
> > +              * rest of the page needs to be zeroed out.
> > +              */
> > +             iomap->length = iomap_read_inline_data(iter, page);
> > +             return iomap->length;
>
> You can't just change iomap->length here.  Fix the file system to
> return the right length, please.

Hmm, that doesn't make sense to me: the filesystem doesn't know that
iomap_readpage will pad to page boundaries. This happens at the iomap
layer, so the iomap layer should also deal with the consequences.
We're using different alignment rules here and for direct I/O, so that
makes fake-aligning the extent size in iomap_begin even more
questionable.

"Fixing" the extent size the filesystem returns would also break
direct I/O. We could add some additional padding code to
iomap_dio_inline_iter to deal with that, but currently, there's no
need for that.

Thanks,
Andreas

