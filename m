Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C361D4A91
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 12:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgEOKMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 06:12:46 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:44930 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgEOKMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 06:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1589537564; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M/ePh4YMLWBTL9hyhzqUgUQ4fXudSnPsmWQ/+DO/jDI=;
        b=NiQbku4jdQcDOxNquHeMhn1m5LxhL3LJZ2WTO7CcLadmmETPPamlO/NiaFdg9HKSvQ97al
        qqo0OAkpXFMg/k3pf+5hraTU0B0/wJ9h7iLhnKKiflNymqRqCs5ew7ChK3jOnqjr0WBUo6
        gIaV4UPZoQPdphURMUF3/KzzcABU8iM=
Date:   Fri, 15 May 2020 12:12:33 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] drm/etnaviv: fix perfmon domain interation
To:     Christian Gmeiner <christian.gmeiner@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        The etnaviv authors <etnaviv@lists.freedesktop.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Message-Id: <X0BDAQ.L99CTJZCDEJE3@crapouillou.net>
In-Reply-To: <CAH9NwWcJNhUVkzd0KAfJyxNZJ9a71KLzipW+qRwhgEWUmnnxmg@mail.gmail.com>
References: <20200511123846.96594-1-christian.gmeiner@gmail.com>
        <CAH9NwWcJNhUVkzd0KAfJyxNZJ9a71KLzipW+qRwhgEWUmnnxmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christian,

Le ven. 15 mai 2020 =E0 12:09, Christian Gmeiner=20
<christian.gmeiner@gmail.com> a =E9crit :
> Am Mo., 11. Mai 2020 um 14:38 Uhr schrieb Christian Gmeiner
> <christian.gmeiner@gmail.com>:
>>=20
>>  The GC860 has one GPU device which has a 2d and 3d core. In this=20
>> case
>>  we want to expose perfmon information for both cores.
>>=20
>>  The driver has one array which contains all possible perfmon domains
>>  with some meta data - doms_meta. Here we can see that for the GC860
>>  two elements of that array are relevant:
>>=20
>>    doms_3d: is at index 0 in the doms_meta array with 8 perfmon=20
>> domains
>>    doms_2d: is at index 1 in the doms_meta array with 1 perfmon=20
>> domain
>>=20
>>  The userspace driver wants to get a list of all perfmon domains and
>>  their perfmon signals. This is done by iterating over all domains=20
>> and
>>  their signals. If the userspace driver wants to access the domain=20
>> with
>>  id 8 the kernel driver fails and returns invalid data from doms_3d=20
>> with
>>  and invalid offset.
>>=20
>>  This results in:
>>    Unable to handle kernel paging request at virtual address 00000000
>>=20
>>  On such a device it is not possible to use the userspace driver at=20
>> all.
>>=20
>>  The fix for this off-by-one error is quite simple.
>>=20
>>  Reported-by: Paul Cercueil <paul@crapouillou.net>
>>  Tested-by: Paul Cercueil <paul@crapouillou.net>
>>  Fixes: ed1dd899baa3 ("drm/etnaviv: rework perfmon query=20
>> infrastructure")
>>  Cc: stable@vger.kernel.org
>>  Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
>>  ---
>>   drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>>  diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c=20
>> b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
>>  index e6795bafcbb9..35f7171e779a 100644
>>  --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
>>  +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
>>  @@ -453,7 +453,7 @@ static const struct etnaviv_pm_domain=20
>> *pm_domain(const struct etnaviv_gpu *gpu,
>>                  if (!(gpu->identity.features & meta->feature))
>>                          continue;
>>=20
>>  -               if (meta->nr_domains < (index - offset)) {
>>  +               if ((meta->nr_domains - 1) < (index - offset)) {
>>                          offset +=3D meta->nr_domains;
>>                          continue;
>>                  }
>>  --
>>  2.26.2
>>=20
>=20
> ping

I'll merge it tomorrow if there's no further feedback.

-Paul


