Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6CF65B776
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 23:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjABWGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 17:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjABWGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 17:06:00 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD29C14
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 14:05:58 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id m18so69290769eji.5
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 14:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JpbWVZRvg9AIaDGOnq/ekC2NRAjd/w9USYSz4UospIY=;
        b=k0Gmyge4hyss3aSEfDDLRNsqrAQWde5Xg5/pFFIVKkqDzEciPYZLwk0hQ2BxMIhkqG
         Ascjm2X3ua2QpN8PGSjpxo89BdR7pkCglq1djyHt4BmXV++UmIurvQNsh10//IdRWJ6U
         /QUuSR7PgMdIACOgMRh2jL4fI2UHMXX6t1K+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JpbWVZRvg9AIaDGOnq/ekC2NRAjd/w9USYSz4UospIY=;
        b=dg73utyhk3fk/ybcBLeb28UYBNVfKlRDUcOHOC/eEmTfNPifVjc+YdvydYeGLS7tU4
         YTKmk6pi3hwdfu5rhsJHfg19Dwah5+y3A/f8RUXfQnstzerx3TxshsReG44JkMvKYoRG
         H7BA8pXWRh04boOBu4RpWDTWhXwqwEn0lmQvK2djSDpxM/sVocrFlWWNZg17YyHyJfKs
         cE1dywy+A36mItn/ykj+/ZYg2nyrKiHv09U2N0WDBy09S9P0yMusI2/q8FGdFq6KIuT7
         iwjtRC7/Jc4WStNcsQYOa1UwopE1tCpMcWlFdrcUXa8JCN+CgULSwjpc2AU9gWEQ50K9
         bPxA==
X-Gm-Message-State: AFqh2kpEzF6K9jENH3AccobeTw9xhhkqV88qIq4SwM5Lgo/BMeH06CrS
        LgvjkZrERIux8PFgLLvHYG84W72Ay2rx1E3s54dcUQ==
X-Google-Smtp-Source: AMrXdXtyf9qByEQ1daXTlW+37rKOM447IPDhQSC085lEdRfvDdD0vPXi1FyRL6R+s4y0WRMydaDPVRc7nHyFllOp2sc=
X-Received: by 2002:a17:906:1153:b0:7ff:796b:93ee with SMTP id
 i19-20020a170906115300b007ff796b93eemr4918125eja.582.1672697157182; Mon, 02
 Jan 2023 14:05:57 -0800 (PST)
MIME-Version: 1.0
References: <20221208072520.26210-1-peter.wang@mediatek.com>
 <yq14jtyekv2.fsf@ca-mkp.ca.oracle.com> <CAONX=-d-LZSV9-R=oLDFKsBG8Zd90wXOcGR44kPaorDH-Y7MnQ@mail.gmail.com>
 <35850d1c8f042d59f14f268502aa30ac497b2d5e.camel@mediatek.com>
In-Reply-To: <35850d1c8f042d59f14f268502aa30ac497b2d5e.camel@mediatek.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Tue, 3 Jan 2023 09:05:46 +1100
Message-ID: <CAONX=-frZnh054ORgp=NB-CM1ZkBM7+ea51rsSjeZS3SBLKdGg@mail.gmail.com>
Subject: Re: [PATCH v6] ufs: core: wlun suspend SSU/enter hibern8 fail recovery
To:     =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?UTF-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 4:59 PM Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B)
<peter.wang@mediatek.com> wrote:
> But if without this patch when purge is onging, system IO will hang,
> this is no better.
Yes, that is why I am just pointing this out as a matter of fact, not as a =
bug.
It is arguable if resetting the controller in the deadlock situation is a p=
roper
thing to do, but it might be the next best thing, so I don't argue that nei=
ther.

> So, with current design, if purge initiator do not want to see rpm
> EBUSY, then he should polling bPurgeStatus.
> What do you think?

I am actually not sure if management operations extend the timeout - they a=
re
going through bsg interface, and I am not sure it properly re-sets the time=
outs
on all possible nexus interfaces, need to check that.
But even if it does, there are two problems:
* If you make kernel be polling that parameter - it will actually make the
  application level to miss the completion code (since after querying
  completion once it will return Not Started afterwards).
* And application polling is race prone. We set runtime suspend to 100ms - =
so
  depending on the scheduling quirks it may miss the event.

--Daniil
