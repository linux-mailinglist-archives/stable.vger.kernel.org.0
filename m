Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B959D114A13
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 01:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbfLFAEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 19:04:11 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15992 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfLFAEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 19:04:10 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de99afe0000>; Thu, 05 Dec 2019 16:04:14 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 05 Dec 2019 16:04:10 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 05 Dec 2019 16:04:10 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec
 2019 00:04:09 +0000
Received: from [10.110.48.28] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec 2019
 00:04:09 +0000
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Qian Cai <cai@lca.pw>
CC:     Yang Shi <yang.shi@linux.alibaba.com>, <fabecassis@nvidia.com>,
        <mhocko@suse.com>, <cl@linux.com>, <vbabka@suse.cz>,
        <mgorman@techsingularity.net>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <a7f354b7-d2f9-71c0-7311-97255933b9a2@nvidia.com>
 <2139CED9-6C12-48A5-BF61-F36923EB948E@lca.pw>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <22b5bfde-45be-95bd-5c98-2ab13302c107@nvidia.com>
Date:   Thu, 5 Dec 2019 16:04:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <2139CED9-6C12-48A5-BF61-F36923EB948E@lca.pw>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575590654; bh=HDeKv827CiSQ8RzNL5TATYMtNjIBTbYkbw7NU4jWVmc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=e4500oBYXGcC8/koWSWB6iUl1ZFKQ4hL8OjrgxarlmjN3W3BViEVFRWaojft72r6L
         hQ6AOW5/XOYcPNF5NN+IXSM8oiN5AW8G2lcmXuIVwVuYThty7VJnJH9Urj1pbrwJh+
         KPUFCPxXk6/ydWrdWtKS/WxIPbTHPVdj8IAGRAt1m5sHpqe4/aeYquIJK4YctH2Kvf
         WQ3wBtGo3e4IF6k09tVlTbaLO+9vY0vONgSfhnHIYykDP0w3kcfY+TnluubN9eov7b
         2xpZkdqgepyjgEU2AilCc/axH7i+s6jq8CZvE2olsutb7UUchierqqoz6SkVlRiV6m
         RJ6UWykhSVDMg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/19 3:58 PM, Qian Cai wrote:
>=20
>=20
>> On Dec 5, 2019, at 6:24 PM, John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> Let's check in the fix that is clearly correct and non-controversial, in=
 one
>> patch. Then another patch can be created for the other case. This allows=
 forward
>> progress and quick resolution of the user's bug report, while still deal=
ing
>> with all the problems.
>>
>> If you try to fix too many problems in one patch (and remember, sometime=
s ">1"
>> is too many), then things bog down. It's always a judgment call, but wha=
t's=20
>> unfolding here is quite consistent with the usual judgment calls in this=
 area.
>>
>> I don't think anyone is saying, "don't work on the second problem", it's=
 just
>> that it's less urgent, due to no reports from the field. If you are pass=
ionate
>> about fixing the second problem (and are ready and willing to handle the=
 fallout
>> from user space, if it occurs), then I'd encourage you to look into it.
>>
>> It could turn out to be one of those "cannot change this because user sp=
ace expectations
>> have baked and hardened, and changes would break user space" situations,=
 just to
>> warn you in advance, though.
>=20
> There is no need to paper over the underlying issue. One can think there =
is only one problem. The way move_pages() deal with pages are already in th=
e desired node. Then, I don=E2=80=99t see there is any controversy that it =
was broken for so long and just restore it to according to the manpage. If =
you worried about people has already depended on the broken behavior, it co=
uld stay in linux-next for many releases to gather feedback. In any case, I=
 don=E2=80=99t see it need to hurry to fix this until someone can show the =
real world use case for it apart from some random test code.
>=20

Felix's code is not random test code. It's code he wrote and he expected it=
 to work.

Anyway, I've explained what I want here, and done my best to explain it. So=
 I'm=20
dropping off now. :)

thanks,
--=20
John Hubbard
NVIDIA
