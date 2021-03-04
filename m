Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E1532CAF6
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 04:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhCDDne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 22:43:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44278 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbhCDDnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 22:43:07 -0500
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210304034225epoutp03a7d22fa68266308a234e8f96fe57b7a3~pBrvvVNlI0471904719epoutp03u
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 03:42:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210304034225epoutp03a7d22fa68266308a234e8f96fe57b7a3~pBrvvVNlI0471904719epoutp03u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614829345;
        bh=B+6dMBxtcSUu6W/9okaioUJOpO8DxXMXNSJCTv2oFbY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=CJKt2EioxIG0LQiX2TZCspntYxc9r41oeSUkkN0ReeOxFRLc2XXIO3QWsPFnf6udR
         rxTHds8v4WdVoEQRFDoB7gh4SaNTUuN7LO6UOM6O1BezKQXfFDCvG5ZTkONYNjzRMc
         XE1YEysbu/8fGDrtRYh+B/sl0yZ4Hpo/Ns8mP40o=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210304034225epcas1p138bb275b600ecf45204f3fefb85cea22~pBrvMgqVn2304223042epcas1p1R;
        Thu,  4 Mar 2021 03:42:25 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.163]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DrcBQ4wqvz4x9QM; Thu,  4 Mar
        2021 03:42:22 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3F.32.63458.E1750406; Thu,  4 Mar 2021 12:42:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210304034222epcas1p35c7ae7b4baae4b6c28d32ade4fe00e62~pBrseZIzG1695416954epcas1p3l;
        Thu,  4 Mar 2021 03:42:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210304034222epsmtrp296082612ef95e070ed0c7a7da79482a9~pBrsduer_2714327143epsmtrp2C;
        Thu,  4 Mar 2021 03:42:22 +0000 (GMT)
X-AuditID: b6c32a36-c6d65a800000f7e2-04-6040571e4b12
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.89.08745.D1750406; Thu,  4 Mar 2021 12:42:21 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210304034221epsmtip2c45d0f3ea02e5a5d07fdafc1ce700c6d~pBrsR2JJK2508525085epsmtip25;
        Thu,  4 Mar 2021 03:42:21 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Hyeongseok Kim'" <hyeongseok@gmail.com>, <sj1557.seo@samsung.com>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
In-Reply-To: <20210302052020.63598-1-hyeongseok@gmail.com>
Subject: RE: [PATCH v2] exfat: fix erroneous discard when clear cluster bit
Date:   Thu, 4 Mar 2021 12:42:21 +0900
Message-ID: <002f01d710a8$624be490$26e3adb0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG+mIOZmBktm/oL05f7SJkQ+BJOQgN+CcSTqogt6BA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTT1cu3CHBYNIlBYu/Ez8xWezZe5LF
        4vKuOWwWW/4dYbVYsPERowOrx85Zd9k9+rasYvT4vEkugDkqxyYjNTEltUghNS85PyUzL91W
        yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ386mKL+0JFUh
        I7+4xFYptSAlp8DQoECvODG3uDQvXS85P9fK0MDAyBSoMiEnY/fC5awFXwUr5j17ytbAOI+v
        i5GTQ0LAROLTo4uMXYxcHEICOxglbp1+zw7hfGKUaF13hhnC+cwo8evtNFaYloU3X0O17GKU
        uHDkECuE85JR4t731SwgVWwCuhL//uxnA7FFBNwldr3rYQSxmQXiJd4v+QdWwylgJbH/3g6w
        uLCAt8TWXdeZQGwWARWJq2s+gsV5BSwlns5axgxhC0qcnPmEBWKOvMT2t3OYIS5SkPj5dBkr
        xC4riXd7dzBD1IhIzO5sA3tBQuAnu8S2bWuBnuMAclwklm1yhugVlnh1fAs7hC0l8fndXjaI
        kmqJj/uhxncwSrz4bgthG0vcXL+BFaSEWUBTYv0ufYiwosTO33OhPuSTePe1hxViCq9ER5sQ
        RImqRN+lw0wQtrREV/sH9gmMSrOQ/DULyV+zkNw/C2HZAkaWVYxiqQXFuempxYYFRshxvYkR
        nBq1zHYwTnr7Qe8QIxMH4yFGCQ5mJRFe8Ze2CUK8KYmVValF+fFFpTmpxYcYTYEhPZFZSjQ5
        H5ic80riDU2NjI2NLUzMzM1MjZXEeRMNHsQLCaQnlqRmp6YWpBbB9DFxcEo1MBWeEb90d9f6
        i3duz+uy0Zq7ZNKzxuff3B6IRn4RuhBqb1q73DnkBdf0VX+zT+SaRG4xOuT2xuOix9Lc+jD7
        3pjjB/RkMl31J0su2qFR8POsCNdjZ6OAxAVrQwv0J/s1dn22bdrxPsX5V0aPx6OvqlbMHRt0
        K70Xh8nx3vnzJqLQXNE1Z29a7d7ZwQ7ufUaSVjtjw5hLq1JFPsnMMj31ZJGzzsLn9ndrrc7e
        LvZgaOKwFjpkk/020bXV6Rn/192cgev26aQc8i945nZGwYNnSmvv7LvPTif4CXbNZRDc1GN9
        6P7ZN1araz2/f31r4PrK1M/bYM3OrOoki9/OjmlMMc91nJYJc+SGmByb3sSvxFKckWioxVxU
        nAgAIVtpBRYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvK5cuEOCQV+wxd+Jn5gs9uw9yWJx
        edccNost/46wWizY+IjRgdVj56y77B59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVsXvhctaC
        r4IV8549ZWtgnMfXxcjJISFgIrHw5mvGLkYuDiGBHYwSO1fuYoJISEscO3GGuYuRA8gWljh8
        uBii5jmjxKXXyxlBatgEdCX+/dnPBmKLCHhKrDi4ggmknlkgUeLoaweI+m5Gial/VrKC1HAK
        WEnsv7cDrFdYwFti667rYLtYBFQkrq75CBbnFbCUeDprGTOELShxcuYTFoiZehJtG8FKmAXk
        Jba/ncMMcaaCxM+ny1ghTrCSeLd3BzNEjYjE7M425gmMwrOQTJqFMGkWkkmzkHQsYGRZxSiZ
        WlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHB9aWjsY96z6oHeIkYmD8RCjBAezkgiv+Evb
        BCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYhCOiXFhe
        R4i/eFbMlKm1b5bcpKhn+nsuvNJY4HW6qtk6VUJx7T2Og1WBlxTXmG7fax96tNcsdqW49RuL
        X36LPuSpxxqasQXHNEhWhcT4vy3ray/mlSxa+PfNCT3zaXbG1zOXHFieOLOGgzU29dnvP2s4
        n/zcdJKd88uuhTFnj02fdFng05xPMw49VNDMrdhTaJu9ese15+8FY01Pb5mkLnJX+kxIhcMH
        q7K2Ey7W6rFpem0tybHNt/QM1rmWJHc2TXv2I/m8y5YtCp3Le+wYSmerbwhb78e+3mOtpI+f
        le8Xk2sum7ym/2lIXKMs034265uS+6Hfl9+LhzEc2KNu1j9Hfc8Cgyk3zrxTP1asxFKckWio
        xVxUnAgAMddktf4CAAA=
X-CMS-MailID: 20210304034222epcas1p35c7ae7b4baae4b6c28d32ade4fe00e62
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210302052033epcas1p3c1bac591bdd1f94ffbef1272a3df137f
References: <CGME20210302052033epcas1p3c1bac591bdd1f94ffbef1272a3df137f@epcas1p3.samsung.com>
        <20210302052020.63598-1-hyeongseok@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> If mounted with discard option, exFAT issues discard command when clear cluster bit to remove file.
> But the input parameter of cluster-to-sector calculation is abnormally added by reserved cluster size
> which is 2, leading to discard unrelated sectors included in target+2 cluster.
> With fixing this, remove the wrong comments in set/clear/find bitmap functions.
> 
> Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
Cc: stable@vger.kernel.org # v5.7+
> Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
> Acked-by: Sungjong Seo <sj1557.seo@samsung.com>
Applied. Thanks for your patch!

> ---
>  fs/exfat/balloc.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c index 761c79c3a4ba..54f1bcbddb26 100644
> --- a/fs/exfat/balloc.c
> +++ b/fs/exfat/balloc.c
> @@ -141,10 +141,6 @@ void exfat_free_bitmap(struct exfat_sb_info *sbi)
>  	kfree(sbi->vol_amap);
>  }
> 
> -/*
> - * If the value of "clu" is 0, it means cluster 2 which is the first cluster of
> - * the cluster heap.
> - */
>  int exfat_set_bitmap(struct inode *inode, unsigned int clu)  {
>  	int i, b;
> @@ -162,10 +158,6 @@ int exfat_set_bitmap(struct inode *inode, unsigned int clu)
>  	return 0;
>  }
> 
> -/*
> - * If the value of "clu" is 0, it means cluster 2 which is the first cluster of
> - * the cluster heap.
> - */
>  void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)  {
>  	int i, b;
> @@ -186,8 +178,7 @@ void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
>  		int ret_discard;
> 
>  		ret_discard = sb_issue_discard(sb,
> -			exfat_cluster_to_sector(sbi, clu +
> -						EXFAT_RESERVED_CLUSTERS),
> +			exfat_cluster_to_sector(sbi, clu),
>  			(1 << sbi->sect_per_clus_bits), GFP_NOFS, 0);
> 
>  		if (ret_discard == -EOPNOTSUPP) {
> @@ -197,10 +188,6 @@ void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
>  	}
>  }
> 
> -/*
> - * If the value of "clu" is 0, it means cluster 2 which is the first cluster of
> - * the cluster heap.
> - */
>  unsigned int exfat_find_free_bitmap(struct super_block *sb, unsigned int clu)  {
>  	unsigned int i, map_i, map_b, ent_idx;
> --
> 2.27.0.83.g0313f36


