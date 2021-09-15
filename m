Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE9240C56E
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 14:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhIOMmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:42:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233094AbhIOMmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 08:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631709695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tEfV1/DYZkGpxw3ayA2oBkkT4tRl5bPyLJkShMw/OD8=;
        b=LevlbvVeFGfsubDMLiSE747tdMHSMQUH3ZXQplr2dpJ0oJixjsjh+1cRiyjxdaJcdelaTY
        IqAtydXQTn8102t+KrePrUEPvbUWSQkd3LyQ9I1a48nxBt5pxb6i6PrzKKjTVrcvxHsdEo
        oCpeAMTdnzTkRHD+cja//DKcnzm9MMI=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-3T2ju2s4PtefJfsRSe6J2Q-1; Wed, 15 Sep 2021 08:41:34 -0400
X-MC-Unique: 3T2ju2s4PtefJfsRSe6J2Q-1
Received: by mail-yb1-f199.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso3278930ybq.10
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 05:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tEfV1/DYZkGpxw3ayA2oBkkT4tRl5bPyLJkShMw/OD8=;
        b=bAQ8snkE84EudBwIOF/qgRvr7Ns+VntD2c2LMj5QPntXXz/4zvtBUUYNWneiPBY1no
         yUbMH+kd7t5NsREQIsOo4HSrvEyumEx1G83wstWb9InpLFs1U63ud6oHN1K8eSDc28u1
         1ZrOPXEPwhgNHy7McrGiivVX5EYSyVlnWj+yeGwp1UXTDCFs4Qnw7PmQUKmpI4kY7aSM
         TvQDDrUCnzB2nqeu4hTzQQ/aGBkUr3zFIAUrR+89+uumyV3PF/eXeF2bdlZ0ipAx0nkF
         40vpWgMAn/i31wBBRynyxrg63bzBPL1G7B651tgEjbMrTwo+h3NSIat4OjPvWhx/83gh
         5W8A==
X-Gm-Message-State: AOAM531uttwDfpVGBdgJaaghrnBrWxFa6GNbN6fygHXPKmkseb8G6rpK
        /ADfXeDa2fiVvEoDIbEiQnQ1uVDUPt6Tx1xH06CO/W+ge3hL/OTWHh7IIgh3L+GvyK9zjVEh+29
        VrVQDFMjmV2wfpr5H9S9ySzjmusRXQRlu
X-Received: by 2002:a25:6e05:: with SMTP id j5mr6060596ybc.86.1631709693601;
        Wed, 15 Sep 2021 05:41:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYXfmKAL8J/kdJ6tVlq03ShaucMeQ1AyAxuj3HLKQJr7h2PEgsEt4QwRhS8cM1Vk81Nswx3FwdUgYPdMTmyWc=
X-Received: by 2002:a25:6e05:: with SMTP id j5mr6060566ybc.86.1631709693413;
 Wed, 15 Sep 2021 05:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAHj4cs94pDUfSSfij=ENQxL-2PaGrHJSnhn_mHTC+hqSvPzBTQ@mail.gmail.com>
 <ca405578-5462-0ab9-91ab-de9d42ee0570@grimberg.me>
In-Reply-To: <ca405578-5462-0ab9-91ab-de9d42ee0570@grimberg.me>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Wed, 15 Sep 2021 20:41:21 +0800
Message-ID: <CAHj4cs8_382bLtbcR4F8RBJSmwMAdW22EiRycDjdLa0QtY2vnw@mail.gmail.com>
Subject: Re: [bug report] nvme0n1 node still exists after blktests
 nvme-tcp/014 on 5.13.16-rc1
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 10:28 PM Sagi Grimberg <sagi@grimberg.me> wrote:
>
>
> > Hello
> > I found this failure on stable 5.13.16-rc1[1] and cannot reproduce it
> > on 5.14, seems we are missing commit[2] on 5.13.y, could anyone help
> > check it?
>
> Was it picked up and didn't apply correctly?
>

Hi Sagi
I tried apply that patch to stable branch, but failed to do that,
would you or Hannes mind help backport it, thanks.

[linux-stable-rc ((daeb634aa75f...))]$ git am
0001-nvme-fix-refcounting-imbalance-when-all-paths-are-do.patch
Applying: nvme: fix refcounting imbalance when all paths are down
error: patch failed: drivers/nvme/host/nvme.h:716
error: drivers/nvme/host/nvme.h: patch does not apply
Patch failed at 0001 nvme: fix refcounting imbalance when all paths are down
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

[linux-stable-rc ((daeb634aa75f...))]$ patch -p1 <
0001-nvme-fix-refcounting-imbalance-when-all-paths-are-do.patch
patching file drivers/nvme/host/core.c
Hunk #1 succeeded at 3761 (offset -46 lines).
Hunk #2 succeeded at 3771 (offset -46 lines).
Hunk #3 succeeded at 3790 (offset -46 lines).
patching file drivers/nvme/host/multipath.c
Hunk #1 succeeded at 757 (offset -3 lines).
patching file drivers/nvme/host/nvme.h
Hunk #1 FAILED at 716.
Hunk #2 succeeded at 775 (offset 3 lines).
1 out of 2 hunks FAILED -- saving rejects to file drivers/nvme/host/nvme.h.rej

-- 
Best Regards,
  Yi Zhang

