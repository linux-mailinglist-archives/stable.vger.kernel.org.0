Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAB2366284
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 01:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhDTXi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 19:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbhDTXi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 19:38:59 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8115C06174A
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 16:38:27 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id v19-20020a0568300913b029028423b78c2dso28766941ott.8
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 16:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kebUVEk8pgucyxIFOgl+WImnSC2PnPl/SW0Ruljz75Y=;
        b=t3+TAhhgc3+GOtOgpJmxiYKdb4yTa80DiAjXVhXJ4R/2QfgYGS9Mzdxf9omT2PXVgn
         syhMCNwGn6wCx64e0mhdraQI0eBxUQlf2Dd/qy5rBUrfGl4V2+/MZQxi/dmILI/QVk+0
         DHBd7UNEV1IoKO9q+9+em0PzxmCDAPtSn+SK1XGTT58933P98teA1GyHuCiq65ZYBNIs
         jUN+nluJiiifOIygMRoolJilnRH7iETiy2Bms7ty0QeqSInZJ9D1TPldsBdylGWkRJlr
         w5i5Az1asjK0bIBGJE1U7s84vMPQbmO4lGhxUcxznILea6MeKglg7kvQ7fl2RW+Jm5g/
         depg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kebUVEk8pgucyxIFOgl+WImnSC2PnPl/SW0Ruljz75Y=;
        b=R2r/DLj72xOYlS8grx3rKPZoYesp1/1uQ8YiIHfTviq/VIhEqxi0Qx3Ihnc7fqA/XJ
         +cBaMXu4j22uU5vdGr9urGKxJPmU1mgVKuzb5DKcMTR+e1FhFHZ8EkvGFjnvLJ1Rcm0x
         daohC+vpd37vhbufaVa5ys5QQReF/vUfIUU58c7NYwY4VeUOrSgK69A8o46XokS0ARa9
         69FBSv9Gm4PSkQZhOb4VUlu0YKLNj7VM95IkoEBgQYxlAI5Xotws0nqaYaExlIZ/tjet
         MkFHU2RSIDTK5vxoOz9nFmnjILXSz/yH3asw27uJzS0gGeKYUpaizJdKu35UrbRv0Ez3
         zJyg==
X-Gm-Message-State: AOAM530IH70S9gxpeNKsvpjwH61rMeP3OKy1sU66JrX3K3KfqTOK7uGh
        1GJ6vZH84ZvaXLisK25owlAl/AkmTs0Yxedv1Odwv0cvRbKf3w==
X-Google-Smtp-Source: ABdhPJwc9umuY70pWCfZjJCs/slmOBMrjIz735zccRjAVFFK7ERZoK9zr/0LcEhK1oG9E47Z84GwMxzZDxAZQvEH9N8=
X-Received: by 2002:a05:6830:158d:: with SMTP id i13mr21131806otr.8.1618961906963;
 Tue, 20 Apr 2021 16:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com> <YG2q6Tm58tWRBtmK@kroah.com>
In-Reply-To: <YG2q6Tm58tWRBtmK@kroah.com>
From:   Jianxiong Gao <jxgao@google.com>
Date:   Tue, 20 Apr 2021 16:38:13 -0700
Message-ID: <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com>
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 7, 2021 at 5:51 AM Greg KH <greg@kroah.com> wrote:
>
> On Mon, Apr 05, 2021 at 09:02:22PM +0000, Jianxiong Gao wrote:
> > Hi all,
> >
> > This series of backports fixes the SWIOTLB library to maintain the
> > page offset when mapping a DMA address. The bug that motivated this
> > patch series manifested when running a 5.4 kernel as a SEV guest with
> > an NVMe device. However, any device that infers information from the
> > page offset and is accessed through the SWIOTLB will benefit from this
> > bug fix.
>
> But this is 5.10, not 5.4, why mention 5.4 here?
Oops. The cover letter shouldn't mention the kernel version. The bug
is present in both 5.4 and 5.10. Sorry for the confusion.>
> And you are backporting a 5.12-rc feature to 5.10, what happened to
> 5.11?
No. The goal is to backport a bug fix to the LTS releases.
> Why not just use 5.12 to get this new feature instead of using an older
> kernel?  It's not like this has ever worked before, right?
>
It's true, that a new feature (SEV virtualization) is what motivated
the bug fix. However, I still think this makes sense to backport to
the LTS releases because it does fix a pre-existing bug that may be
impacting pre-existing setups.

In particular, while working on these patches, I got the following feedback:
"There are plenty of other hardware designs that rely on dma mapping
not adding offsets that did not exist, e.g. ahci and various RDMA
NICs."

[1] https://lkml.org/lkml/2020/11/24/520
> thanks,
>
> greg k-h



-- 
Jianxiong Gao
