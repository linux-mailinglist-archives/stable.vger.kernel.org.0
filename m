Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8995311A63D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 09:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfLKIuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 03:50:21 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14016 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfLKIuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 03:50:20 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df0adc50003>; Wed, 11 Dec 2019 00:50:13 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 11 Dec 2019 00:50:19 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 11 Dec 2019 00:50:19 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Dec
 2019 08:50:19 +0000
Received: from tbergstrom-lnx.Nvidia.com (10.124.1.5) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 11 Dec 2019 08:50:19 +0000
Received: by tbergstrom-lnx.Nvidia.com (Postfix, from userid 1000)
        id F060C42797; Wed, 11 Dec 2019 10:50:16 +0200 (EET)
Date:   Wed, 11 Dec 2019 10:50:16 +0200
From:   Peter De Schrijver <pdeschrijver@nvidia.com>
To:     Dmitry Osipenko <digetx@gmail.com>
CC:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
Message-ID: <20191211085016.GW28289@pdeschrijver-desktop.Nvidia.com>
References: <20191210103708.7023-1-jonathanh@nvidia.com>
 <1f2a4f23-5be5-aa7e-6eb4-2aeb4058481d@gmail.com>
 <1fe9cd2d-50a2-aae5-95fa-0329acce4c4c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1fe9cd2d-50a2-aae5-95fa-0329acce4c4c@gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576054213; bh=aT59Us6r+RXBi41ZhK23q+Ubu168i/DTG0ueCLa67nU=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:
         Content-Transfer-Encoding:In-Reply-To:X-NVConfidentiality:
         User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=bBKdljop3uOxvjy/o3pqji1i6rxEkmO8s/acQe1DjLRXVnEhD93410sOvuVOsKaY0
         JenibI3MMdIaGFllcLUf34f4bfqA2730HOi4P39ho0opyk9kJWGx60qiUsvFVUSgjZ
         BIvwwiH7VZPw4IizzuwrjcILMwvSfRTe6Xb5ROTaDI/aLQxkBYqCHwlOoyNIZIymlA
         dz98J/HTvcx2VvUtTnSrormWY/66UDpO6/OElOHSMfL8x271y8ax+p64aprcgMliTT
         uk7bPKfvF84yf/d/RHrqp5kLErqM0H3BYuACr17jRIYPrMt+4t1hIinCddp/u9MxpF
         aMC9nl8Gbf2xA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 11:29:42PM +0300, Dmitry Osipenko wrote:
> External email: Use caution opening links or attachments
>=20
>=20
> 10.12.2019 22:28, Dmitry Osipenko =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Hello Jon,
> >
> > PLLM's enable-status could be defined either by PMC or CaR. Thus at
> > first you need to check whether PMC overrides CaR's enable and then
> > judge the enable state based on PMC or CaR state respectively.
> >
>=20
> Actually, now I think that it doesn't make sense to check PMC WB0 state
> at all. IIUC, PLLM's state of the WB0 register defines whether Boot ROM
> should enable PLLM on resume from suspend. Thus it will be correct to
> check only the CaR's enable-state of PLLM.
>=20
> I'm not sure what's the idea of WB0 overriding, maybe to resume faster.
> Peter, could you please clarify that?

I don't know why these overriding bits exist. The code for them was in
the downstream driver so I implemented the same in the upstream driver
:)

Peter.

