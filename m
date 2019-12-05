Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF42114A0C
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 00:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbfLEX6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 18:58:24 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38305 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfLEX6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 18:58:23 -0500
Received: by mail-qt1-f194.google.com with SMTP id 14so5357630qtf.5
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 15:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=19Kmz8PlMAAPnYoSfUTwu5grmM6qpP4/2uB2ZZCI+YU=;
        b=T43/BXB2RbU8iqN7uGFJBhgKhlsGzA/O/QZiwcGDE249VIINHNqyDHDBSXSIaieStm
         xia2qhJFBZXTOAe0wAIwJCWGhT2nfhGj5tC4wda1pfr+AZ49yVoWuB6S5wJe7i68j69n
         +nyNzQIzdzUL7ivOWR3HODXcfF9QEtAqM6pCdF/zsq0RRtpEvEls4WbyuMkQGkz4H02h
         ufO8yQG4DxMDVE6v7o6k80JH8zYEVm+BBM0JGwYbU1V7dEVha2ffyfNxit7kR2xqHP/a
         Tnkg88W51Eu4TEMMS5VfrMccHz1/Ozr/239Gv6E7tJbR0qmCqwLctNRni3gYSmuP2Xq6
         +yag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=19Kmz8PlMAAPnYoSfUTwu5grmM6qpP4/2uB2ZZCI+YU=;
        b=ogS98VRV4Zd+eeiClrjD7/leMPR4AujPyCJYFlVxbEXqns8Pyuls+5hbpcQraOnCVi
         6q+v2JrHxYvgk80n1cRv2+efPGkqhJtbvOYuMtGY9v1Qol0nkkWnvGjm8qIhTzcTrxWz
         ewLAFJFejR9JxojRG34aAGrEenwdrgfHounlb1NgTkdw25mcaFDlMA26C4nYaXc54OYt
         5lc9P6e042UriVhs3VCvJf85VoE/EBbG8ZFYnoWrfy/tHPBAiNApvwEY3TlqLo3lEHOv
         oMNPeXhteNDAsn2r1YkSqIVOwpwkDGv+IQGJfbQU/jOjzOa06SjiASJAmJkNWNghtQoU
         MR/A==
X-Gm-Message-State: APjAAAXvrkZjP1GIvcqzqSA+wqq8/Jl+zBLaUhM/1mFDTESRrDMYIJeo
        R42uvMA8u22wBpO3dFx+0MvQKXu4OkE=
X-Google-Smtp-Source: APXvYqyKRq0bhGDnJPvtjgM62dYIgvwyqyyk4HWNEGpHt9JsqMwQ8TkTT/lRXn+Ce3ZXZIYiOYxkyQ==
X-Received: by 2002:aed:2926:: with SMTP id s35mr10543569qtd.220.1575590302083;
        Thu, 05 Dec 2019 15:58:22 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id g64sm5273422qke.43.2019.12.05.15.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 15:58:21 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the page is already on the target node
Date:   Thu, 5 Dec 2019 18:58:20 -0500
Message-Id: <2139CED9-6C12-48A5-BF61-F36923EB948E@lca.pw>
References: <a7f354b7-d2f9-71c0-7311-97255933b9a2@nvidia.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, fabecassis@nvidia.com,
        mhocko@suse.com, cl@linux.com, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <a7f354b7-d2f9-71c0-7311-97255933b9a2@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
X-Mailer: iPhone Mail (17B111)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 5, 2019, at 6:24 PM, John Hubbard <jhubbard@nvidia.com> wrote:
>=20
> Let's check in the fix that is clearly correct and non-controversial, in o=
ne
> patch. Then another patch can be created for the other case. This allows f=
orward
> progress and quick resolution of the user's bug report, while still dealin=
g
> with all the problems.
>=20
> If you try to fix too many problems in one patch (and remember, sometimes "=
>1"
> is too many), then things bog down. It's always a judgment call, but what'=
s=20
> unfolding here is quite consistent with the usual judgment calls in this a=
rea.
>=20
> I don't think anyone is saying, "don't work on the second problem", it's j=
ust
> that it's less urgent, due to no reports from the field. If you are passio=
nate
> about fixing the second problem (and are ready and willing to handle the f=
allout
> from user space, if it occurs), then I'd encourage you to look into it.
>=20
> It could turn out to be one of those "cannot change this because user spac=
e expectations
> have baked and hardened, and changes would break user space" situations, j=
ust to
> warn you in advance, though.

There is no need to paper over the underlying issue. One can think there is o=
nly one problem. The way move_pages() deal with pages are already in the des=
ired node. Then, I don=E2=80=99t see there is any controversy that it was br=
oken for so long and just restore it to according to the manpage. If you wor=
ried about people has already depended on the broken behavior, it could stay=
 in linux-next for many releases to gather feedback. In any case, I don=E2=80=
=99t see it need to hurry to fix this until someone can show the real world u=
se case for it apart from some random test code.=
