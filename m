Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193E96AFB9E
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 01:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCHA4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 19:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCHA4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 19:56:43 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EE799D51
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:56:39 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id y144so13213202yby.12
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 16:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678236998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2z17zRKFMosP6BmxLJ/3DuXXKXAyRiupSkgseBN6cU=;
        b=Nrci12vOCp3J89fc7u/nniyE27xH7hGSUCDplHpMV9Y6JKXCcNigWzvSRMaLhClu1T
         NVB6CAP2wfPzVTCXvkyXorZ9RP5vcQo7XsQjJ6GsbW2GXKJawPMOV3UvFNyMe00rk974
         eZ8hq7lHZ3y5j1c9+m7FU3pl3ZrKXHhQqZZ5ePxlJ0NpfKwy3ucJWcTTQmhxo23zJFVy
         s8T0534wZVgATFaoOnM5xbPVie8F66tojvsonEKaB7CWzPGmPrzRiu3LjSv/UEVa5Pk2
         /6sBSCtQ8fcVnq+8HipepNdhafzNu8SRefDH8NJo1lMLSUt7LdZ9B8XpJ3H9vO6r0Tu+
         gCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678236998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2z17zRKFMosP6BmxLJ/3DuXXKXAyRiupSkgseBN6cU=;
        b=dfnMQLdMAroU2jCXN6Szipy/8eD4nmMr1k8oe7ud84n9moLpOeiovlcA/9YPAP6gx+
         5dgGV/7qzgPfDXmZPIV0D/FYFFQnjvVgkLS8deHavzw4BGBK5BBG6i2rLib9Ea4jB+f3
         mi1m6qn4KjPzEK5cEbSJODdE4A9GHeP79iW1RwghH/kvi0m5gBYSDgzcTR/hP7WUgcSH
         PuzYAKx/n+4+k76ufwPuRX8qRUJkLh83kveN/zE5GC6226B/fNs/pZbC1ceIuxNbFCg3
         uGRw0Wf+CekBQAuHe5NmHJwza1P0lAp4aCw6IaJNX2pVycqR2zkqLv3EIGJyk/EEr0AM
         0wpw==
X-Gm-Message-State: AO0yUKVx3QahxRotg1/uRjBEd2W39Prwm4p6oLrLjJp/4IazM/dbpc18
        eYPbi4+PNjaueUV6iEEo/PTkFcvjrhudInCnvV81dg==
X-Google-Smtp-Source: AK7set9/fDieulPqxhpOdoJQrExsxumuJ87WCyLgiQG2g+Go3qkI9m0l2+tsGWVLuxsGkP0DEl9tueq8guM7LF4VUao=
X-Received: by 2002:a05:6902:4d1:b0:8dd:4f2c:ede4 with SMTP id
 v17-20020a05690204d100b008dd4f2cede4mr9949667ybs.2.1678236998589; Tue, 07 Mar
 2023 16:56:38 -0800 (PST)
MIME-Version: 1.0
References: <20230201183201.14431-1-len.brown@intel.com> <167706207598.17049.13538001164844345072.kvalo@kernel.org>
In-Reply-To: <167706207598.17049.13538001164844345072.kvalo@kernel.org>
From:   Matthew Wang <matthewmwang@google.com>
Date:   Tue, 7 Mar 2023 16:56:27 -0800
Message-ID: <CAAooHFd4UPitENa76Dvqp3KZSKvwzcX+3mqbKFF4PEs-obKW5g@mail.gmail.com>
Subject: Re: wifi: ath11k: allow system suspend to survive ath11k
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Len Brown <len.brown@intel.com>, rafael@kernel.org,
        kvalo@codeaurora.org, linux-pm@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm a bit of a kernel n00b here, but it's unclear to me that this is
the right thing to do and I just wanted to get some clarity. If the
ath11k device fails to suspend, my understanding is that it might
waste power attempting to talk to the host that's currently asleep.
Are we sure that ath11k can recover from ignored failures/skipped
teardown?



On Wed, Feb 22, 2023 at 2:34=E2=80=AFAM Kalle Valo <kvalo@kernel.org> wrote=
:
>
> Len Brown <len.brown@intel.com> wrote:
>
> > When ath11k runs into internal errors upon suspend,
> > it returns an error code to pci_pm_suspend, which
> > aborts the entire system suspend.
> >
> > The driver should not abort system suspend, but should
> > keep its internal errors to itself, and allow the system
> > to suspend.  Otherwise, a user can suspend a laptop
> > by closing the lid and sealing it into a case, assuming
> > that is will suspend, rather than heating up and draining
> > the battery when in transit.
> >
> > In practice, the ath11k device seems to have plenty of transient
> > errors, and subsequent suspend cycles after this failure
> > often succeed.
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216968
> >
> > Fixes: d1b0c33850d29 ("ath11k: implement suspend for QCA6390 PCI device=
s")
> >
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > Cc: stable@vger.kernel.org
>
> Patch applied to wireless.git, thanks.
>
> 7c15430822e7 wifi: ath11k: allow system suspend to survive ath11k
>
> --
> https://patchwork.kernel.org/project/linux-wireless/patch/20230201183201.=
14431-1-len.brown@intel.com/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches
>
