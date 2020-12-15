Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0E92DAACB
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 11:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgLOKYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 05:24:17 -0500
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:64588 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725535AbgLOKYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 05:24:13 -0500
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFAMkmt031377;
        Tue, 15 Dec 2020 04:23:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=tvQrv/ItfE78XRSohMF/HJEtdwtZZi+AiD3Wfw82lT4=;
 b=PwGRccYFmlBlAWmufhrIJD0yvLKqLJi0MosBRl7FsXhox0AL77Mj9nDPm+HrBmxW8NZr
 W/wWLESYPYtqcdwwjvrURPsowQZubuqAwUhI1x7BHbiWL3KRdWy6p5GGhfcgggDU56xP
 8pklTAy9DLO8sDeR2gZPUCPB3IsOkue8RF7hn3jD2gMxZmrG8ixal13ijvbNjJBy851a
 tFF7kbo/tKjBFrzll31oM2audzjTuZkdg3WI4F3G7SDtWYG7tGfrzPXgBe4R0R/PE4Qu
 NZqTrBHWMsujwiturDSQtVlsz7RhxsCmDALiCpRAY1XvHZx9RxWg7OWtE+uxjFYT5KTX PA== 
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 35cv56kkmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Dec 2020 04:23:15 -0600
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 15 Dec
 2020 10:23:13 +0000
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Tue, 15 Dec 2020 10:23:13 +0000
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 881E811CC;
        Tue, 15 Dec 2020 10:23:13 +0000 (UTC)
Date:   Tue, 15 Dec 2020 10:23:13 +0000
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     Thomas Hebb <tommyhebb@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        <alsa-devel@alsa-project.org>, Takashi Iwai <tiwai@suse.com>,
        <stable@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] ASoC: dapm: remove widget from dirty list on free
Message-ID: <20201215102313.GD9673@ediswmail.ad.cirrus.com>
References: <f8b5f031d50122bf1a9bfc9cae046badf4a7a31a.1607822410.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f8b5f031d50122bf1a9bfc9cae046badf4a7a31a.1607822410.git.tommyhebb@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 clxscore=1011 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150073
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 12, 2020 at 05:20:12PM -0800, Thomas Hebb wrote:
> A widget's "dirty" list_head, much like its "list" list_head, eventually
> chains back to a list_head on the snd_soc_card itself. This means that
> the list can stick around even after the widget (or all widgets) have
> been freed. Currently, however, widgets that are in the dirty list when
> freed remain there, corrupting the entire list and leading to memory
> errors and undefined behavior when the list is next accessed or
> modified.
> 
> I encountered this issue when a component failed to probe relatively
> late in snd_soc_bind_card(), causing it to bail out and call
> soc_cleanup_card_resources(), which eventually called
> snd_soc_dapm_free() with widgets that were still dirty from when they'd
> been added.
> 
> Fixes: db432b414e20 ("ASoC: Do DAPM power checks only for widgets changed since last run")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> ---
> 
>  sound/soc/soc-dapm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> index 7f87b449f950..148c095df27b 100644
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -2486,6 +2486,7 @@ void snd_soc_dapm_free_widget(struct snd_soc_dapm_widget *w)
>  	enum snd_soc_dapm_direction dir;
>  
>  	list_del(&w->list);
> +	list_del(&w->dirty);

I can't help but wonder if we should be taking the DAPM lock for
snd_soc_dapm_free_widgets. However your patch doesn't look like it
is making that any more scary and looks like we should be making
sure we remove the widget from the dirty list.

Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>

Thanks,
Charles
