Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A6A3967A
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 22:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfFGUKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 16:10:10 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41601 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbfFGUKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 16:10:10 -0400
Received: by mail-ot1-f68.google.com with SMTP id 107so2991558otj.8
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 13:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QlVygW5HX3gMOqI9iagu+o2KfHmRD4CVE+mKAqVQHDc=;
        b=brKoMC2YNPiZDdbuJUJptjoM9KaSU8S4ObGocQkg1KQo4JtkdYErEgLDttxwqmD1JH
         dL/IlNi9BXKIc8G2/scgxlh4GMR1LPlSwT1q5vcXHrdpTfXILVnLCPxnCBYk7gUFnfFF
         NdgiE59NbaWDqNP5wfElrVabi+k2yJJyvfJduho23fxEAZDaN8S5AlfdlL96Y1r7QtR1
         A3okrfILjOgYAttOW90Hvjo0YcQe/1HvRH2+1CnF6pxcSFE6miNDAwBkMxuMaeftbxpC
         eVrIbhAE3WWKVoxN2mrCw1iTp9wy3oCPHn39dU3YvYz4bSqNGMa2gZQYQQPeD7kvC730
         R67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QlVygW5HX3gMOqI9iagu+o2KfHmRD4CVE+mKAqVQHDc=;
        b=R7MqR1XfulXWYe6pVKHWTMHaupjwJy1X8Kq3x9X2fIuuMdkUKqACBAL5ZkMYlZBtua
         BmFZb34aqLPsP/IyccviL9CunCzw3qicI6yB66J0cDp5aX2cMl4VtXPOrZMgkjocJoUj
         s77iJWHjAtMCEFyxZwNF7uyCC1un0GMvUs9W6ncG1MEqF/5XsQLh21V2SjnWW3pBnDgk
         2PpWc48w5IUSxOwKLd66JT4WwNWXmJNsHA9IxC24sePsCmLQdjS7TIr1/n0IVX1MgWRY
         c+6N3F/lUuOiovygeOEfjl2FV/4C6WfEDuDSi2jTSsb5mudFn3dxeueqRcNzw7qGUOYo
         YH8Q==
X-Gm-Message-State: APjAAAULQMsJHfyl2awQn1pfb+JIUeWoKa+gqjA2xcWAU36yNq/g3cMm
        mw8wnbtcvrjpZqgoF5Wu2AHrlpqHCENb9qZNoNKXDw==
X-Google-Smtp-Source: APXvYqza6PFTcS6UhXtsr41/gRao+O5Nm4kLPIDhyAJGiSy5KNxsRBiCwJGc9Q8H+D6BnJ2xLKRvXnTj8YRz1komqIE=
X-Received: by 2002:a9d:7248:: with SMTP id a8mr20388166otk.363.1559938209740;
 Fri, 07 Jun 2019 13:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155977193862.2443951.10284714500308539570.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190606144643.4f3363db9499ebbf8f76e62e@linux-foundation.org>
 <CAPcyv4hHs75hYs+Ye+NHHiU31C6CnBqCFdo=2c5seN7kvxKOrw@mail.gmail.com> <20190607125430.81e63cd56590ab3fea37a635@linux-foundation.org>
In-Reply-To: <20190607125430.81e63cd56590ab3fea37a635@linux-foundation.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 7 Jun 2019 13:09:58 -0700
Message-ID: <CAPcyv4iSndjxgQZq1HtsyY5=h837b-MY3FNDzAdrBGiKJGwOvw@mail.gmail.com>
Subject: Re: [PATCH v9 11/12] libnvdimm/pfn: Fix fsdax-mode namespace
 info-block zero-fields
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 7, 2019 at 12:54 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 6 Jun 2019 15:06:26 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Thu, Jun 6, 2019 at 2:46 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Wed, 05 Jun 2019 14:58:58 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > > At namespace creation time there is the potential for the "expected to
> > > > be zero" fields of a 'pfn' info-block to be filled with indeterminate
> > > > data. While the kernel buffer is zeroed on allocation it is immediately
> > > > overwritten by nd_pfn_validate() filling it with the current contents of
> > > > the on-media info-block location. For fields like, 'flags' and the
> > > > 'padding' it potentially means that future implementations can not rely
> > > > on those fields being zero.
> > > >
> > > > In preparation to stop using the 'start_pad' and 'end_trunc' fields for
> > > > section alignment, arrange for fields that are not explicitly
> > > > initialized to be guaranteed zero. Bump the minor version to indicate it
> > > > is safe to assume the 'padding' and 'flags' are zero. Otherwise, this
> > > > corruption is expected to benign since all other critical fields are
> > > > explicitly initialized.
> > > >
> > > > Fixes: 32ab0a3f5170 ("libnvdimm, pmem: 'struct page' for pmem")
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > >
> > > The cc:stable in [11/12] seems odd.  Is this independent of the other
> > > patches?  If so, shouldn't it be a standalone thing which can be
> > > prioritized?
> > >
> >
> > The cc: stable is about spreading this new policy to as many kernels
> > as possible not fixing an issue in those kernels. It's not until patch
> > 12 "libnvdimm/pfn: Stop padding pmem namespaces to section alignment"
> > as all previous kernel do initialize all fields.
> >
> > I'd be ok to drop that cc: stable, my concern is distros that somehow
> > pickup and backport patch 12 and miss patch 11.
>
> Could you please propose a changelog paragraph which explains all this
> to those who will be considering this patch for backports?
>

Will do. I'll resend the series with this and the fixups proposed by Oscar.
