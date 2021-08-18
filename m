Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355643F046A
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 15:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhHRNQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 09:16:28 -0400
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:47876 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233634AbhHRNQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 09:16:28 -0400
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17IDAl0S027040;
        Wed, 18 Aug 2021 08:15:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=RT10YEEl56y+8zUe9U6xjHrzQdqClkYbLj6Atk7GYAo=;
 b=HjNMFg39N0Q0J+3so/7kGFLXm4GG0+NFLyUv33EyDGRLypVvftP1ApSCavCWiLl2L70I
 uRgfn+ERzZEOFtZbi4rwJJ4acQkDA4VYyN2VqD+b3dj02uZ/owsIWp9/mhNVOsV2egSE
 Tv408e7Kd5G5y/3pTKRns6qZKVjvs1rdej5TNXk32ADZruWDxum1tnsszstN/BmhGI9B
 HeXPXilVQAlYoZ21O4a0DgK+uVkVjoyKWn+Jbr5W/CRPOmVvjEx2g4ChLcWkU+pDD/kS
 GJSBL/Gfd1QuQmjQBgwgqPiTxwJLo92RSdSB4ECOmfu4bzJiTr2dMYmmVutcaEf4foSG ow== 
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 3agtd4gp6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Aug 2021 08:15:47 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Wed, 18 Aug
 2021 14:15:45 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2242.12 via Frontend
 Transport; Wed, 18 Aug 2021 14:15:45 +0100
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id DFED445D;
        Wed, 18 Aug 2021 13:15:44 +0000 (UTC)
Date:   Wed, 18 Aug 2021 13:15:44 +0000
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        <patches@opensource.cirrus.com>, <alsa-devel@alsa-project.org>
Subject: Re: [PATCH AUTOSEL 5.13 03/12] ASoC: wm_adsp: Let
 soc_cleanup_component_debugfs remove debugfs
Message-ID: <20210818131544.GL9223@ediswmail.ad.cirrus.com>
References: <20210817003536.83063-1-sashal@kernel.org>
 <20210817003536.83063-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210817003536.83063-3-sashal@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-ORIG-GUID: 07ovo_PiZY4C71smc856evkHyhsV5zae
X-Proofpoint-GUID: 07ovo_PiZY4C71smc856evkHyhsV5zae
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1031 suspectscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180083
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 08:35:27PM -0400, Sasha Levin wrote:
> From: Lucas Tanure <tanureal@opensource.cirrus.com>
> 
> [ Upstream commit acbf58e530416e167c3b323111f4013d9f2b0a7d ]
> 
> soc_cleanup_component_debugfs will debugfs_remove_recursive
> the component->debugfs_root, so adsp doesn't need to also
> remove the same entry.
> By doing that adsp also creates a race with core component,
> which causes a NULL pointer dereference
> 
> Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
> Link: https://lore.kernel.org/r/20210728104416.636591-1-tanureal@opensource.cirrus.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/soc/codecs/wm_adsp.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
> index cef05d81c39b..6698b5343974 100644
> --- a/sound/soc/codecs/wm_adsp.c
> +++ b/sound/soc/codecs/wm_adsp.c
> @@ -746,7 +746,6 @@ static void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
>  static void wm_adsp2_cleanup_debugfs(struct wm_adsp *dsp)
>  {
>  	wm_adsp_debugfs_clear(dsp);
> -	debugfs_remove_recursive(dsp->debugfs_root);
>  }

It might be better not to backport this patch to the stable
kernels. The issue has only been seen on one out of tree driver
and the patch looks a little off to me. This
debugfs_remove_recursive should run before the
soc_cleanup_component_debugfs one, and as such it's hard to see
what is actually going on. We are currently investigating internally
but we might end up reverting the change, and it only seems to be
causing issues on the one not upstreamed part.

Apologies for missing the review of this one when it went up
Mark, I was on holiday at the time.

Thanks,
Charles
