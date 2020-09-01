Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D8E259DB3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgIARzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:55:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIARzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 13:55:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081HraJn045155;
        Tue, 1 Sep 2020 17:55:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YIf9jDDGSbKpQsV/8I3H+CKi/MNgqATmGNYTH4lTdAE=;
 b=Carv/+tMBZhZ8HhsPYYtqupo5qk0AYwgiTvwczladr+37dim1HxBzdtLf0QPQeSBCC+b
 9ZVuel/1qCA5EDadAsDpNQytwpj26ymNpzXhq7EVM16PtLqyxva8ziZsyU0O24n63FpN
 Uideni2VPgAsea5SMs3j8kUZMLPRbg1zFJjEfN2ibineBjoIFW0AIoc31XXhYBUpiRJm
 hCJ/DgLV5ZYv8jYTKdttwSUCj0Mddv0J7ILUA3UlJivA6WdgmWOp++sWIHpDnLsgW/VY
 oQsE4IPpPjoV3GdjH8oul1RDcMsvdaHfN+7tBONGrq9FS/BuAtZEu8g20zJVOKdBKgBf lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 339dmmvf61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 17:55:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081Ht19g071091;
        Tue, 1 Sep 2020 17:55:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3380ss92d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 17:55:26 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 081HtPOb022784;
        Tue, 1 Sep 2020 17:55:25 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 10:55:24 -0700
Subject: Re: [PATCH] scsi: target: iscsi: Fix data digest calculation
To:     Varun Prakash <varun@chelsio.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org, nab@linux-iscsi.org, stable@vger.kernel.org
References: <1598358910-3052-1-git-send-email-varun@chelsio.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <56a124d4-d503-d8b2-332b-99f1c2288463@oracle.com>
Date:   Tue, 1 Sep 2020 12:55:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1598358910-3052-1-git-send-email-varun@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010151
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/25/20 7:35 AM, Varun Prakash wrote:
> Current code does not consider 'page_off' in data digest
> calculation, to fix this add a local variable 'first_sg' and
> set first_sg.offset to sg->offset + page_off.
> 
> Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index c968961..2ec778e 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1389,14 +1389,27 @@ static u32 iscsit_do_crypto_hash_sg(
>  	sg = cmd->first_data_sg;
>  	page_off = cmd->first_data_sg_off;
>  
> +	if (data_length && page_off) {
> +		struct scatterlist first_sg;
> +		u32 len = min_t(u32, data_length, sg->length - page_off);
> +
> +		sg_init_table(&first_sg, 1);
> +		sg_set_page(&first_sg, sg_page(sg), len, sg->offset + page_off);
> +
> +		ahash_request_set_crypt(hash, &first_sg, NULL, len);
> +		crypto_ahash_update(hash);
> +
> +		data_length -= len;
> +		sg = sg_next(sg);
> +	}
> +
>  	while (data_length) {
> -		u32 cur_len = min_t(u32, data_length, (sg->length - page_off));
> +		u32 cur_len = min_t(u32, data_length, sg->length);
>  
>  		ahash_request_set_crypt(hash, sg, NULL, cur_len);
>  		crypto_ahash_update(hash);
>  
>  		data_length -= cur_len;
> -		page_off = 0;
>  		/* iscsit_map_iovec has already checked for invalid sg pointers */
>  		sg = sg_next(sg);
>  	}
> 

Looks ok to me.

Reviewed-by: Mike Christie <michael.christie@oralce.com>
