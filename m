Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765E2400985
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 06:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhIDD6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 23:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhIDD6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 23:58:34 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665EEC061757
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 20:57:33 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id x11so1984808ejv.0
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 20:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9wSKUuHAWr4vpwA7DvWfQy4iHwJall1hsFO0bvWA1Gk=;
        b=g5ZgZavpMS82d5x3MKckIOUMoVThU0O9Pc2iaxwE5Siwd9gME8cqe12L/cgHAht1xz
         Kpn1Wu/RctOVNROQ3TSjtk5IFHTuzM0Rxl4FB5UvvCPvo1QAHnXSzY5nDejG8PZpj9cN
         Qu+A837DTIHmAzoypyumDU+zHOjcMPHIkv12O4nXEcEzhSnZFfnoyTKRaUJAXpEKnXTe
         8Wc24XJgi3EaybCs/nGQJ0t6mJfEMQzjY/IiknqgpUUxbiLHjuPcLqs8gyO/RWxJgf9f
         t2sJPi2kCVu3rTs97c17ENCslFEbJrNZltd7voXyxMDftExkl7SlRA51e5Iz6cSM4uGO
         YKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9wSKUuHAWr4vpwA7DvWfQy4iHwJall1hsFO0bvWA1Gk=;
        b=D00pEHYaGpL/lW+WNjhRonhsVkAFqO6iPpXpxz29OJsuIJuXleyHOHASf/En6BHPdk
         xCphUHhCQra9hmFBJANDyzvHwbCtvemLSPjczWSJOur+0DYjU/uRw4Av6Z/ZWWcO37MU
         KzH4en7xQi/XKqMl4zxBXxqOSazlSd02QmSmAdzhgVSQMORziic7Q7q0WKp/EbyJzpbW
         CCxVtXuQzOoUd6szD3mSp+jIco2rh9shURL+3nbhrLUD/Crwvxx3Ub57kugogFym9M0G
         S9xv8DJCxvuO/AEEj5hMme8tzINrJOWaEZtl4/WzoJk5h5B1cnP5EJ/yIuDpNsKNHaXq
         qSMw==
X-Gm-Message-State: AOAM530jbsuW7e096/o52xrhKkpvjHIhksX0jd0g7tSL7yv909kWVvma
        1VEmRbcBz+FqSQlRzH13dpIJ8FcBYNBWaPl4P1zF
X-Google-Smtp-Source: ABdhPJyaqnH2B6SVp5dXUJ0CC3mjVdlnyUkm1Txk4U1ErfpXTAArBaPpsiUCYBWkslQW6icwU0ALNkBdytQ9B/VJhv8=
X-Received: by 2002:a17:906:8802:: with SMTP id zh2mr2359913ejb.344.1630727851799;
 Fri, 03 Sep 2021 20:57:31 -0700 (PDT)
MIME-Version: 1.0
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 3 Sep 2021 23:57:20 -0400
Message-ID: <CAHC9VhTNu8E9WkzUHbQC9xKK5U74L8oqetUtPXGX2RSofMcqgw@mail.gmail.com>
Subject: Re: [PATCH 2/6] cxl/pci: Fix lockdown level
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        alison.schofield@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 3, 2021 at 10:20 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> A proposed rework of security_locked_down() users identified that the
> cxl_pci driver was passing the wrong lockdown_reason. Update
> cxl_mem_raw_command_allowed() to fail raw command access when raw pci
> access is also disabled.
>
> Fixes: 13237183c735 ("cxl/mem: Add a "RAW" send command")
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Cc: <stable@vger.kernel.org>
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Cc: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hi Dan,

Thanks for fixing this up.  Would you mind if this was included in
Ondrej's patchset, or would you prefer to merge it via another tree
(e.g. cxl)?

> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 651e8d4ec974..37903259ee79 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -575,7 +575,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
>         if (!IS_ENABLED(CONFIG_CXL_MEM_RAW_COMMANDS))
>                 return false;
>
> -       if (security_locked_down(LOCKDOWN_NONE))
> +       if (security_locked_down(LOCKDOWN_PCI_ACCESS))
>                 return false;
>
>         if (cxl_raw_allow_all)
>

-- 
paul moore
www.paul-moore.com
