Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E463B2477
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 03:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFXBVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 21:21:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45211 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFXBVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 21:21:23 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210624011903epoutp0217d54c4b33bd204061ca774002c4b16c~LX_ipRF8h3057330573epoutp02U
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 01:19:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210624011903epoutp0217d54c4b33bd204061ca774002c4b16c~LX_ipRF8h3057330573epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624497543;
        bh=kjqbBMYU19ZuvfcBL9SbR1fKTqsKUcM3Y5gBdZlc5Kc=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=VOS7VPGbplK1MlSVHx6Oax8cOvXGIMTpb91WWDKRM0w6QnP8WhZ3GjPIUqmX47Uuk
         W+DvvsbKnDhOYMPcz+XP0ij8PXRc7bMXPjmirWJ1/MbGfNVwiaDp4OOeJzqSzU5wqc
         iC5qYww9kz2R6/Pcehs/FsUijHi93h1aYCjXcarQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210624011902epcas1p3e784d3d0b6f481a8f371b52657c68f2c~LX_iFCUbm2489024890epcas1p3K;
        Thu, 24 Jun 2021 01:19:02 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.152]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G9MjJ2vxvz4x9Q2; Thu, 24 Jun
        2021 01:19:00 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.D0.09586.38DD3D06; Thu, 24 Jun 2021 10:19:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210624011859epcas1p390ec01297a393af00f86f4fc3371e7ab~LX_e4hyT81787717877epcas1p3s;
        Thu, 24 Jun 2021 01:18:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210624011859epsmtrp1cfcd8e35dbaa91bf8547429f6a591097~LX_e3AidS2345723457epsmtrp1L;
        Thu, 24 Jun 2021 01:18:59 +0000 (GMT)
X-AuditID: b6c32a39-86dff70000002572-6a-60d3dd839e99
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        39.D4.08289.38DD3D06; Thu, 24 Jun 2021 10:18:59 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210624011859epsmtip2e6042107d7f2ce8aaa8195438c879295~LX_emtasa0208502085epsmtip2V;
        Thu, 24 Jun 2021 01:18:59 +0000 (GMT)
Subject: Re: [PATCH 1/4] PM / devfreq: passive: Fix get_target_freq when not
 using required-opp
To:     andrew-sh.cheng@mediatek.com, hsinyi@chromium.org
Cc:     sibis@codeaurora.org, saravanak@google.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        chanwoo@kernel.org, cwchoi00@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <ec3412aa-db49-b791-dc93-c15e56f79807@samsung.com>
Date:   Thu, 24 Jun 2021 10:38:12 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20210617060546.26933-2-cw00.choi@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmrm7L3csJBk/+MllsX/+C1WLijSss
        Fs+OaltMaN3ObHG26Q27xeVdc9gsPvceYbS43biCzaLr0F82i2sL37NaLNj4iNGB22N2w0UW
        j8t9vUweO2fdZfdYsKnUY9OqTjaPlpP7WTz6tqxi9Pi8SS6AIyrbJiM1MSW1SCE1Lzk/JTMv
        3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoTiWFssScUqBQQGJxsZK+nU1RfmlJ
        qkJGfnGJrVJqQUpOgWWBXnFibnFpXrpecn6ulaGBgZEpUGFCdsajjQ3sBQ08FatmzGVrYHzA
        2cXIySEhYCLx9OR+5i5GLg4hgR2MEnc+bYRyPjFKPL99jB3C+cwocXxrFxNMy4ZHMC27GCUm
        rZnDBuG8Z5RYOm8pK0iVsECixMXd59hAbBEBU4k9hyeygBQxCzwE6ljeDDaKTUBLYv+LG2BF
        /AKKEld/PGYEsXkF7CSuTTsGZrMIqEpMvnoKbKioQJjEyW0tUDWCEidnPmEBsTkFrCW2ndrJ
        DmIzC4hL3HoynwnClpfY/nYO2KkSAlc4JFpO3GeB+MFFYvmvJkYIW1ji1fEt7BC2lMTL/jYo
        u1pi5ckjbBDNHYwSW/ZfYIVIGEvsXzoZaAMH0AZNifW79CHCihI7f89lhFjMJ/Huaw8rSImE
        AK9ER5sQRImyxOUHd6HBKCmxuL2TbQKj0iwk78xC8sIsJC/MQli2gJFlFaNYakFxbnpqsWGB
        KXJ8b2IEp2Ityx2M099+0DvEyMTBeIhRgoNZSYT3UculBCHelMTKqtSi/Pii0pzU4kOMpsAA
        nsgsJZqcD8wGeSXxhqZGxsbGFiaGZqaGhkrivDvZDiUICaQnlqRmp6YWpBbB9DFxcEo1MDVu
        8BE7+pj/tvq8N/q1+6NP7ixqKf0Wnqzi+tfaxPb6nP1GKz5353X7pYZ4ik9x3H3VeUnMvi/t
        3Edf83XVnfYPuKIqfX1XbILYrYaP1kVxlRJLNh6UuK0gap638ZLazVBr3uY47XfKHT8fd+3R
        cJyazCDyzG/WfiPGXbsK5xsfrF6eefSYU7nEc75me7OZSz5fnBbtd2Cm4nF+qcMfxFrauR0L
        Yy9nF0XHnhPjszvKL8XX0PjuVeaMGYfLSxckFZi+fBSmrSl3K39ePh/PvFhmN+tfD/2k835P
        fu3+Q+pAqK+elJCJ9Qu/R5cON0U5VRhstPbgmHKl6vm/gpvZqT/eGpr2nbq7Zfn0jAsmSizF
        GYmGWsxFxYkAeD3jIE4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSvG7z3csJBvdPCFlsX/+C1WLijSss
        Fs+OaltMaN3ObHG26Q27xeVdc9gsPvceYbS43biCzaLr0F82i2sL37NaLNj4iNGB22N2w0UW
        j8t9vUweO2fdZfdYsKnUY9OqTjaPlpP7WTz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr49HG
        BvaCBp6KVTPmsjUwPuDsYuTkkBAwkdjwaD9zFyMXh5DADkaJTxcaWCESkhLTLh4FSnAA2cIS
        hw8Xg4SFBN4ySkycVgJiCwskSlzcfY4NxBYRMJXYc3giC8gcZoGHjBIb5nxihRi6n1Fi37+X
        TCBVbAJaEvtf3ADr4BdQlLj64zEjiM0rYCdxbdoxMJtFQFVi8tVTYEeICoRJ7FzymAmiRlDi
        5MwnLCA2p4C1xLZTO9lBbGYBdYk/8y4xQ9jiEreezGeCsOUltr+dwzyBUXgWkvZZSFpmIWmZ
        haRlASPLKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4IjU0trBuGfVB71DjEwcjIcY
        JTiYlUR4H7VcShDiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomD
        U6qBaebJrmDnje9KwuadOfgv/g7f+8yLBZbbbD/9mHow63BYffCO+9GXCv489OX6MUvwdMS1
        I58K7tqZ9F7NyDx/tumH1Lu1DzgWL2fM5W/fHbpUqSN4y6NFLzwZJi8w+6WxVfOQY23KoiUT
        ld5naNl9NDWY+IW9wXz9y7/rrlV5MBUZPzQVNl2Y2uK08P5+wfy4twImRhbXn6vMLnwVf33C
        ap0Gv2UcrLbhmrFHeF5Ubgr1NtlXYGdoIFP35te6FiazfU4ruO6rCP/nffRyd+Rrr1/PnRlO
        3Vg+nYdFUubyuis/it+Vbzx3etGKf13Zm+z3auSbxuSpbbrGND8t8tWse68ET658+zJJa8qn
        qHv+mx4psRRnJBpqMRcVJwIAH00X0DcDAAA=
X-CMS-MailID: 20210624011859epcas1p390ec01297a393af00f86f4fc3371e7ab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210617054647epcas1p4d2e5b1fa1ec35487701189808178da18
References: <20210617060546.26933-1-cw00.choi@samsung.com>
        <CGME20210617054647epcas1p4d2e5b1fa1ec35487701189808178da18@epcas1p4.samsung.com>
        <20210617060546.26933-2-cw00.choi@samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/17/21 3:05 PM, Chanwoo Choi wrote:
> The 86ad9a24f21e ("PM / devfreq: Add required OPPs support to passive governor")
> supported the required-opp property for using devfreq passive governor.
> But, 86ad9a24f21e has caused the problem on use-case when required-opp
> is not used such as exynos-bus.c devfreq driver. So that fix the
> get_target_freq of passive governor for supporting the case of when
> required-opp is not used.
> 
> Cc: stable@vger.kernel.org
> Fixes: 86ad9a24f21e ("PM / devfreq: Add required OPPs support to passive governor")
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/governor_passive.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/governor_passive.c b/drivers/devfreq/governor_passive.c
> index b094132bd20b..fc09324a03e0 100644
> --- a/drivers/devfreq/governor_passive.c
> +++ b/drivers/devfreq/governor_passive.c
> @@ -65,7 +65,7 @@ static int devfreq_passive_get_target_freq(struct devfreq *devfreq,
>  		dev_pm_opp_put(p_opp);
>  
>  		if (IS_ERR(opp))
> -			return PTR_ERR(opp);
> +			goto no_required_opp;
>  
>  		*freq = dev_pm_opp_get_freq(opp);
>  		dev_pm_opp_put(opp);
> @@ -73,6 +73,7 @@ static int devfreq_passive_get_target_freq(struct devfreq *devfreq,
>  		return 0;
>  	}
>  
> +no_required_opp:
>  	/*
>  	 * Get the OPP table's index of decided frequency by governor
>  	 * of parent device.
> 

Applied it.

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
