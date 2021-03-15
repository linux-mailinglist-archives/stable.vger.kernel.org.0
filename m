Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EA333AEF0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 10:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCOJiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 05:38:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14247 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhCOJiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 05:38:22 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210315093819epoutp02dd3cba83a71eb6fc5a946f9419231fd9~seon6F4hx0045000450epoutp02V
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 09:38:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210315093819epoutp02dd3cba83a71eb6fc5a946f9419231fd9~seon6F4hx0045000450epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615801099;
        bh=3qlOT5uUZ+YLrom4qb6ld9dq4tKFakPJF6PM6+FP08Y=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=KRZSuGKR/4K3Q23RxNroyHLVDtbixG7PDvDknUNYJVEwjyBq0K3AVklrXQmR9CPOf
         LBoHspMeICKERWR1PttA2hVvv+1sZHMrFRuKz0TimZwQVkf1dIhRWKhSuc7nGYKOra
         oXOnLV24toMzDOJIRgZ723TJxWYXAOodLq2qBkfg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210315093818epcas1p22c58560b57adb4f0b3bacb71c100dc02~seonZWTl12044420444epcas1p2z;
        Mon, 15 Mar 2021 09:38:18 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.153]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DzWZ03Gpwz4x9Q0; Mon, 15 Mar
        2021 09:38:16 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.C9.63458.80B2F406; Mon, 15 Mar 2021 18:38:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210315093815epcas1p32308b5dd2a04df776bdac997e20ce094~seoki7kcz2884728847epcas1p3r;
        Mon, 15 Mar 2021 09:38:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210315093815epsmtrp1fcc3643f1e2f4e74108bc34993012487~seokiKwp_0925109251epsmtrp1R;
        Mon, 15 Mar 2021 09:38:15 +0000 (GMT)
X-AuditID: b6c32a36-6c9ff7000000f7e2-80-604f2b08c298
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.DF.13470.70B2F406; Mon, 15 Mar 2021 18:38:15 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210315093815epsmtip1101d5f3d12dda5bf2f6fefb917648e48~seokVao4y0057100571epsmtip1o;
        Mon, 15 Mar 2021 09:38:15 +0000 (GMT)
Subject: Re: [PATCH v2] PM / devfreq: Unlock mutex and free devfreq struct
 in error path
To:     Lukasz Luba <lukasz.luba@arm.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc:     myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <a73d618f-2369-0d80-f8c6-22ddd9a9a716@samsung.com>
Date:   Mon, 15 Mar 2021 18:54:52 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20210315093123.20049-1-lukasz.luba@arm.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTX5dD2z/B4MVhEYuzTW/YLS7vmsNm
        8bn3CKPFwqYWdovbjSvYLBZsfMTowOaxZt4aRo++LasYPT5vkgtgjsq2yUhNTEktUkjNS85P
        ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaq6RQlphTChQKSCwuVtK3synK
        Ly1JVcjILy6xVUotSMkpsCzQK07MLS7NS9dLzs+1MjQwMDIFKkzIztj7fjNjwXnOiuWzPrA2
        MN5l72Lk5JAQMJFY+2EhaxcjF4eQwA5GiaXbnjNDOJ8YJbZ+PMEI4XxjlJh6awIbTMuTd2ug
        qvYySkyZdQfKec8o0d+znxmkSlggSuLKhP1gS0QE4iUWHvoAZjMLBErMaD3HCmKzCWhJ7H9x
        A2wqv4CixNUfjxlBbF4BO4mZ2yYwgdgsAqoS6xb/B5spKhAmcXJbC1SNoMTJmU9YQGxOAUuJ
        ucdXsEDMF5e49WQ+E4QtL7H97Ryw4yQEGjkkpvX9Y4J4wUXi/s75jBC2sMSr41ugoSEl8bK/
        Dcqullh58ggbRHMHo8SW/RdYIRLGEvuXTgYaxAG0QVNi/S59iLCixM7fcxkhFvNJvPvawwpS
        IiHAK9HRJgRRoixx+cFdqBMkJRa3d7JNYFSaheSdWUhemIXkhVkIyxYwsqxiFEstKM5NTy02
        LDBCju5NjOBEqWW2g3HS2w96hxiZOBgPMUpwMCuJ8H7W8U0Q4k1JrKxKLcqPLyrNSS0+xGgK
        DOCJzFKiyfnAVJ1XEm9oamRsbGxhYmhmamioJM6baPAgXkggPbEkNTs1tSC1CKaPiYNTqoGJ
        5fyUhOKcVhZOvgBNqfq3ghvk+2VVN9S6ZH7srBXSNHXo23Dks8Sq5lXKC71Vj3HUfpy6pO31
        xy+mB0vPeM1TWMV1b3nYKp3Jfk1TJz5huZ36IvMv7/5JvqLLb8XK6Vhrf/+qpPt6+Vbnh5+K
        CmuXfaiukjBzv5VU2y6ZpBse9KlVxjn+Itdy79opzkLXXotIXpn3b/EMrTnszVurq/++at90
        4ubCdRwXD10UbL/Rpt64bdr2qQvZblTq5hh/3vQyYm5L/kFe2fP8lrw9S0rjXx1Z0vmm1XPn
        3it3XR6FKB5wd427F65QOE1+UlKx5dPH2z4tLb3KoiH+cLkDZ1vh3tfFuyp5/2bxeqetNrFW
        YinOSDTUYi4qTgQAD4S38x0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSnC67tn+CQddvVYuzTW/YLS7vmsNm
        8bn3CKPFwqYWdovbjSvYLBZsfMTowOaxZt4aRo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK
        2Pt+M2PBec6K5bM+sDYw3mXvYuTkkBAwkXjybg1zFyMXh5DAbkaJTRtnQyUkJaZdPAqU4ACy
        hSUOHy6GqHnLKHHo/moWkLiwQJTE+ivCIOUiAvESEx5cZwcJMwsESlx6YANR3sMocenAJkaQ
        GjYBLYn9L26wgdj8AooSV388BovzCthJzNw2gQnEZhFQlVi3+D8ziC0qECaxc8ljJogaQYmT
        M5+wgNicApYSc4+vALOZBdQl/sy7xAxhi0vcejKfCcKWl9j+dg7zBEbhWUjaZyFpmYWkZRaS
        lgWMLKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYKjRUtzB+P2VR/0DjEycTAeYpTg
        YFYS4f2s45sgxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dU
        A9N0x3lyoSennPFrfNx0YsmKpIrz6sliviniRkKKG6WFvsafV7RrvC/OGX7Ttbdh/VM5nty1
        3943eP/4zTrj0UPduxU9t8pW8RQwSbZpB2ZPajmkkn0zSYSXeYbARGm2hfkxJQvtU+/NPBCs
        kMTFtywjv6pEXMhv5s9Zf/tuvJsWszzf6emtVMkO93R/Xu25ysxTn01l+JbO5aPcINU3k8XN
        cOL/Hp+P5RtfJV/6V7RicXJcw8P2K8VxXNIlXNdkz4t27AgU5k1qZsg6/+PqrxaF35eKlKWr
        Aip3i/Rv715faWzrcu+T6Z/PVw19TTn1K2+lNl68X2Wj0fh1T8It/cd7r7zbOaMlSHPpbfk1
        SizFGYmGWsxFxYkAFukFzgUDAAA=
X-CMS-MailID: 20210315093815epcas1p32308b5dd2a04df776bdac997e20ce094
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210315093239epcas1p4516341a9f5614f59bfeb6af66e146540
References: <CGME20210315093239epcas1p4516341a9f5614f59bfeb6af66e146540@epcas1p4.samsung.com>
        <20210315093123.20049-1-lukasz.luba@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/21 6:31 PM, Lukasz Luba wrote:
> The devfreq->lock is held for time of setup. Release the lock in the
> error path, before jumping to the end of the function.
> 
> Change the goto destination which frees the allocated memory.
> 
> Cc: v5.9+ <stable@vger.kernel.org> # v5.9+
> Fixes: 4dc3bab8687f ("PM / devfreq: Add support delayed timer for polling mode")
> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
> ---
> v2:
> - added fixes tag and CC stable v5.9+
> - used capital letter in commit header
> 
> 
>  drivers/devfreq/devfreq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index b6d3e7db0b09..99b2eeedc238 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -822,7 +822,8 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  
>  	if (devfreq->profile->timer < 0
>  		|| devfreq->profile->timer >= DEVFREQ_TIMER_NUM) {
> -		goto err_out;
> +		mutex_unlock(&devfreq->lock);
> +		goto err_dev;
>  	}
>  
>  	if (!devfreq->profile->max_state && !devfreq->profile->freq_table) {
> 


Applied it. Thanks.

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
