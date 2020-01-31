Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E696214F065
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 17:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgAaQIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 11:08:24 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5621 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbgAaQIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 11:08:24 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e3450e20000>; Fri, 31 Jan 2020 08:08:02 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 31 Jan 2020 08:08:23 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 31 Jan 2020 08:08:23 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 31 Jan
 2020 16:08:20 +0000
Subject: Re: [PATCH] Revert "ASoC: tegra: Allow 24bit and 32bit samples"
To:     Dmitry Osipenko <digetx@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
CC:     <alsa-devel@alsa-project.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200131091901.13014-1-jonathanh@nvidia.com>
 <2bb53d7d-2d36-e16e-5858-24360b19f936@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7fafb8d2-8754-e5c0-8952-0253ba8b656a@nvidia.com>
Date:   Fri, 31 Jan 2020 16:08:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2bb53d7d-2d36-e16e-5858-24360b19f936@gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580486882; bh=vjVTrlbwSymcOfbnfHt1GCkOMf6AQ7FxsbKWPEoP0Yc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=iH4ZZfGZMTm9UMvyjN9G3vnTaBhURSOyEL+B0fFGDKJogY2P9qSTaAZLQkyzuo5QH
         Qxps5Wt/JCiW2VPPPEGbjIqnu7SsgyF8RShVivMc6NFDObggDJ7Aa9E7VBDEXhLva+
         6ERWIsvhTQzmNiRlYHDmwV4cC9BMObCVkefclTjXkqhXnRnNshuR75RLyD7RV6KHEK
         PoMuI6+gR1uShSMKmNYskuUtcy10eZQa2zPDIXa9mY7jF2LltP+EjDWRhbXNJjTAgh
         nzsTaBGSWhj+LOCKuOfHFE7aBGENOMoKkwuIPn/NQRfq0VaJgv8znNbpBfM2/35rkJ
         IPOURsN1IYSoQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 31/01/2020 15:38, Dmitry Osipenko wrote:
> 31.01.2020 12:19, Jon Hunter =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Commit f3ee99087c8ca0ecfdd549ef5a94f557c42d5428 ("ASoC: tegra: Allow
>> 24bit and 32bit samples") added 24-bit and 32-bit support for to the
>> Tegra30 I2S driver. However, there are two additional commits that are
>> also needed to get 24-bit and 32-bit support to work correctly. These
>> commits are not yet applied because there are still some review comments
>> that need to be addressed. With only this change applied, 24-bit and
>> 32-bit support is advertised by the I2S driver, but it does not work and
>> the audio is distorted. Therefore, revert this patch for now until the
>> other changes are also ready.
>>
>> Furthermore, a clock issue with 24-bit support has been identified with
>> this change and so if we revert this now, we can also fix that in the
>> updated version.
>>
>> Cc: stable@vger.kernel.org
>>
>> Reported-by: Dmitry Osipenko <digetx@gmail.com>
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>> ---
>=20
> Thanks, Jon!
>=20
> Tested-by: Dmitry Osipenko <digetx@gmail.com>

Thanks. I just realised I forgot the fixes-tag ...

Fixes: f3ee99087c8c ("ASoC: tegra: Allow 24bit and 32bit samples")

Mark, let me know if you want me to resend.

Jon

--=20
nvpublic
