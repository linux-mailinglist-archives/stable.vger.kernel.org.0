Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F35402DC9
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 19:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhIGRkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 13:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhIGRkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 13:40:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79C1C061757
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 10:39:02 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k23so1979424pji.0
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 10:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nb1QdhQIZxRidJbjvk6oUIPprkF08p70/cAJW4OCztU=;
        b=wyx6j2Ke6KGH1+GtS+FmBBw8MIn8UfqsMQ88d9I56GsJSjx9rLSuUQYilcU91ysLl6
         MPc7OLra+HW+o3JnvRz3z0iDXklV2gphDLs/X5NGtGuTjgfrxTHO6DdZh+DNXdW3mJv+
         T3IHwSj7tA9twpptY5hArVuBDozo1P1kZ+V4uRUcQ7e6Et+hpgCKiiWX4V7yJB5WAuHY
         Ds2tnuOV4MutR76CKU+BR5rxSFjkSXrCDANGtNhZb+Kmakp9RdncK1pQu4SEYvaVZ8mn
         oGQAJRAv22snd1O04oQrp9hpIyfhgKZ3IFKm57DPcnH3SK2/Hz2ZOFTL2eQgIDavTBh0
         vOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nb1QdhQIZxRidJbjvk6oUIPprkF08p70/cAJW4OCztU=;
        b=Ae2Dj9Hhl/XoLOrCuJnftpvhiWxl9Gt0MuWckTcTT4sQdCVKLQXHjOy6a907HMxoIk
         BpTGOYqMjaEY9+whSGD01PWv56Fiw8QDRu+w5HEpFSHU6XyGjLvfg70e8/rdpF8/OygA
         xCEaNh+i1JggHX/iSxG9gyqzEQNA6FusOM02bjkqMRU1tw+pN09UNrCpEmfQBvZmwiX+
         zJg3EEjawhgA223HmvkqC/weoNZPT8EE4j7nWjW3hrN2v7yEWrsz58WfIB/nOsm/BH+D
         e7zu6wj52OF0Fu1IaHELvCcUeRwQ0wOTDIMLWHQAEANxY1oe+idCmYGSj0YiRU8Kk1Bs
         FGRg==
X-Gm-Message-State: AOAM531x77OGrvngMB0ZgU+Lte4yzH8jVN35Oaze8hmDDCfgNEx8lPL5
        Y8Fm1jxnfKAKovkmR1k98mzDWgAyG9TtwghGTNNLRg==
X-Google-Smtp-Source: ABdhPJyxjdmxx5YwqE43UTOGkU0EiBDhIhoi4uVrUHQxTpBgtVsICiCkVI6pIqc3GLqMDepUzeTMoKF25Yw0c3D9K7s=
X-Received: by 2002:a17:90b:3b84:: with SMTP id pc4mr4799709pjb.220.1631036341937;
 Tue, 07 Sep 2021 10:39:01 -0700 (PDT)
MIME-Version: 1.0
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHC9VhTNu8E9WkzUHbQC9xKK5U74L8oqetUtPXGX2RSofMcqgw@mail.gmail.com>
In-Reply-To: <CAHC9VhTNu8E9WkzUHbQC9xKK5U74L8oqetUtPXGX2RSofMcqgw@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 7 Sep 2021 10:38:51 -0700
Message-ID: <CAPcyv4gR+WbYf-dT0niT23UY8jZZVBXMk4R-1_0exPcbHrs=0Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] cxl/pci: Fix lockdown level
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable <stable@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        "Schofield, Alison" <alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 3, 2021 at 8:57 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Fri, Sep 3, 2021 at 10:20 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > A proposed rework of security_locked_down() users identified that the
> > cxl_pci driver was passing the wrong lockdown_reason. Update
> > cxl_mem_raw_command_allowed() to fail raw command access when raw pci
> > access is also disabled.
> >
> > Fixes: 13237183c735 ("cxl/mem: Add a "RAW" send command")
> > Cc: Ben Widawsky <ben.widawsky@intel.com>
> > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Cc: <stable@vger.kernel.org>
> > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > Cc: Paul Moore <paul@paul-moore.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/pci.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Hi Dan,
>
> Thanks for fixing this up.  Would you mind if this was included in
> Ondrej's patchset, or would you prefer to merge it via another tree
> (e.g. cxl)?

I was planning to merge this via the cxl tree for v5.15-rc1.
