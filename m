Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D460138041
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 00:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfFFWGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 18:06:39 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39608 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfFFWGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 18:06:39 -0400
Received: by mail-ot1-f65.google.com with SMTP id r21so46634otq.6
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 15:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EIr4OnOI1xF9wai5ier5nmSpwnMBcVJFFbPwhyrlfw8=;
        b=W6owKkiaiucLtIk2d/rhThge65YAuZhOXdGbJAq1YJnZeuj3agBqhdzoWw4pAHpEGG
         yCCRRgubBcq/P+3tO+QxBLrGvQWm34ZFjVhCGGnC25tsI1wz0ookadExgISatwc+xFwx
         9F3A1KcbDxhZpKNcMECopMoti2uf29JMv8oNXtACIP4ZdnAKSAeFcKK0Z75QstHVe1Kk
         FSNS/e4ugOpcEKATo1xHjQe71a839vKxrezJgS4nSTbtKrDnRK96iahNefKSCqeqIl7K
         GpNADCiQeyijYdm/jA366lM8s7uLcFJlrvqzsE5Q567T+TEojZQ525tKJu3IpPIztD1S
         rFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EIr4OnOI1xF9wai5ier5nmSpwnMBcVJFFbPwhyrlfw8=;
        b=YBHV5Ipxw72FJBknRdqR9EixoYbph/zzGD78/VWkps8p4Gcm5Drw06q01Z7GSGSGBt
         2apxYxOgV0I1CPCVTFIRlRvQKvNGiSwAVD9GY+sgtySeyHaEwow538f5/9rgW4IHGncv
         h1U6ibt6Rv5p2xyGYnRQYpIcRZwKUmdP7LOJonytTorP8ioSQHE534aEP+ZmZAvCOkHm
         sxn2dnaeJqGLFGaUqnnfiYJy5xrNasb1nt/9dIandNk8Q1eiMhdpsTUvJ8WbPKvep+Qt
         WsJd7UteMx0o4NtA2TZ52SBCSuyfYBNMD3qT+XxpTwCnXqR62TorXJanvl/0EFlmSjhT
         ZbJw==
X-Gm-Message-State: APjAAAX6QP2+hVrUubl9nQvfQi1KhnqmAs1q4tgmi6Qld9PQgSR5L/pZ
        cZ+dYZB6iIfC/FnsvGY5o90t83kCIqGoRD/sdlz3djafC+g=
X-Google-Smtp-Source: APXvYqycw+T+CReJfdLZE2qHIqv0pPOCCdRZcOCC2XXW8oc8RYjE0NVBkRV9yjOJGx4MnVYldEDTHY2D/nu9EblRWvQ=
X-Received: by 2002:a9d:7a9a:: with SMTP id l26mr12110810otn.71.1559858798146;
 Thu, 06 Jun 2019 15:06:38 -0700 (PDT)
MIME-Version: 1.0
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155977193862.2443951.10284714500308539570.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190606144643.4f3363db9499ebbf8f76e62e@linux-foundation.org>
In-Reply-To: <20190606144643.4f3363db9499ebbf8f76e62e@linux-foundation.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 6 Jun 2019 15:06:26 -0700
Message-ID: <CAPcyv4hHs75hYs+Ye+NHHiU31C6CnBqCFdo=2c5seN7kvxKOrw@mail.gmail.com>
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

On Thu, Jun 6, 2019 at 2:46 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 05 Jun 2019 14:58:58 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
>
> > At namespace creation time there is the potential for the "expected to
> > be zero" fields of a 'pfn' info-block to be filled with indeterminate
> > data. While the kernel buffer is zeroed on allocation it is immediately
> > overwritten by nd_pfn_validate() filling it with the current contents of
> > the on-media info-block location. For fields like, 'flags' and the
> > 'padding' it potentially means that future implementations can not rely
> > on those fields being zero.
> >
> > In preparation to stop using the 'start_pad' and 'end_trunc' fields for
> > section alignment, arrange for fields that are not explicitly
> > initialized to be guaranteed zero. Bump the minor version to indicate it
> > is safe to assume the 'padding' and 'flags' are zero. Otherwise, this
> > corruption is expected to benign since all other critical fields are
> > explicitly initialized.
> >
> > Fixes: 32ab0a3f5170 ("libnvdimm, pmem: 'struct page' for pmem")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> The cc:stable in [11/12] seems odd.  Is this independent of the other
> patches?  If so, shouldn't it be a standalone thing which can be
> prioritized?
>

The cc: stable is about spreading this new policy to as many kernels
as possible not fixing an issue in those kernels. It's not until patch
12 "libnvdimm/pfn: Stop padding pmem namespaces to section alignment"
as all previous kernel do initialize all fields.

I'd be ok to drop that cc: stable, my concern is distros that somehow
pickup and backport patch 12 and miss patch 11.
