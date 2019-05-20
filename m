Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227B523C61
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 17:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392275AbfETPlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 11:41:00 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:43619 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391672AbfETPlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 11:41:00 -0400
Received: by mail-ot1-f53.google.com with SMTP id i8so13355837oth.10
        for <stable@vger.kernel.org>; Mon, 20 May 2019 08:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5QSUm6/xL4WGvvJmVrGCi+MUsTk2A8AVb5uoylgpYm0=;
        b=yPev5JIATuPBAUeewEekviqNSsYEYMPVj34Ea7J3VHdDWfkJJm/Lss37NJzZXuSbcC
         YRWqEDzGwnKyGJ7cfmBUCwLnOU/8qZso7KUyoxCpR1o8jo9s6hM/D8+pnibzSAEiHUth
         qmci2Y5QYlrrWb6PkGnzvPjqxjjWW/5HxgR5KoDHlQ/Byo2F5xDeeHmYv19+at8R+TMZ
         tu+Vu2APi20B80NNxCZHFz3fpj9rYA8GEe82GaUHJ8I6t+MvUs+Ar9a+Vgx2EB76jf89
         ErQzIHthFAPF1mpVWGOYtN71zpeES9K3vrWlKWx5qmwTMgZWKug91Di3ce4BOAyUnJfW
         dKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5QSUm6/xL4WGvvJmVrGCi+MUsTk2A8AVb5uoylgpYm0=;
        b=uOLQs2p9Oc96cErKA+CXduv8g8Wf6R8yvqUBCblDib5fEp2u8PmrHHQSIU4cbThekx
         TdiRGiFGW6M0AuCwk/TKKa9SIi9A9lYOEFY/1yu+nNvb6Ml3xHLvoqmXgZQiQqC/8q3l
         eoVyjDqSKVKd550hudqNkjgQhvNlT5eysQqdEtfyRMlLKe5vaDrewQyPjHcStiaN0mkx
         VXHsixhaNTcBXyDZQxsZ8Lh5/9AYFZrxmzxryR4Vm6YF1MfhFdWRnt6dMG8CxozREeNo
         H6hfIzqjQDvdLY/O2dpsHPA2UWK1B6CF4BQI3WOvsMrOkjQzb9Twp36aM18xA7xkWdWo
         +ilg==
X-Gm-Message-State: APjAAAXidynGmV71Z2q1NFhkwEr3yEvWVadbw4TcL5ziVq+qcLMQGvXz
        oJ8qg3YmU/TTUHsUEYrLi0NfOf2D4+aYqQkoW3MVZA==
X-Google-Smtp-Source: APXvYqxs3KuEEqHCDOtKW83Hc+3/Eh7qrrFqOEiop9JaJSWQJfM8wgC/rkaym0C4K7iuUNGIYwsqH+mgvaYu198CCOk=
X-Received: by 2002:a05:6830:1182:: with SMTP id u2mr34065267otq.71.1558366859535;
 Mon, 20 May 2019 08:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz> <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
 <201905170855.8E2E1AC616@keescook> <CAPcyv4g9HpMaifC+Qe2RVbgL_qq9vQvjwr-Jw813xhxcviehYQ@mail.gmail.com>
 <201905171225.29F9564BA2@keescook> <CAPcyv4iSeUPWFeSZW-dmYz9TnWhqVCx1Y1VjtUv+125_ZSQaYg@mail.gmail.com>
 <20190520075232.GA30972@quack2.suse.cz>
In-Reply-To: <20190520075232.GA30972@quack2.suse.cz>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 20 May 2019 08:40:48 -0700
Message-ID: <CAPcyv4hwiKGDtkT7-r8Ei3kOQBMA3LwDGBNM9H8N6HC5fxi6tw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
To:     Jan Kara <jack@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        stable <stable@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Smits <jeff.smits@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 12:52 AM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 18-05-19 21:46:03, Dan Williams wrote:
> > On Fri, May 17, 2019 at 12:25 PM Kees Cook <keescook@chromium.org> wrote:
> > > On Fri, May 17, 2019 at 10:28:48AM -0700, Dan Williams wrote:
> > > > It seems dax_iomap_actor() is not a path where we'd be worried about
> > > > needing hardened user copy checks.
> > >
> > > I would agree: I think the proposed patch makes sense. :)
> >
> > Sounds like an acked-by to me.
>
> Yeah, if Kees agrees, I'm fine with skipping the checks as well. I just
> wanted that to be clarified. Also it helped me that you wrote:
>
> That routine (dax_iomap_actor()) validates that the logical file offset is
> within bounds of the file, then it does a sector-to-pfn translation which
> validates that the physical mapping is within bounds of the block device.
>
> That is more specific than "dax_iomap_actor() takes care of necessary
> checks" which was in the changelog. And the above paragraph helped me
> clarify which checks in dax_iomap_actor() you think replace those usercopy
> checks. So I think it would be good to add that paragraph to those
> copy_from_pmem() functions as a comment just in case we are wondering in
> the future why we are skipping the checks... Also feel free to add:
>
> Acked-by: Jan Kara <jack@suse.cz>

Will do, thanks Jan.
