Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D23433E45
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 20:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJSSST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 14:18:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24724 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231783AbhJSSSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 14:18:18 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JHNs6w015964;
        Tue, 19 Oct 2021 14:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3Mhlaj/hfcCOJ5gKZvd05vIt+8q8aE3XEqvFde3WcCs=;
 b=U0W4TeLke1rgYm8/0GDEQFZfulmK2p9rvWc5xrG4M9o8AKtGFvtoXMYQdkVrAtfO0A8i
 URX1vb5EqnP2CV0Bm2y2U8tOXRXy/7nZ0uAxMke6+mIL0ms0B3jmShp7RwzuyMzuQ5BZ
 NbYA7Y5YUznbbgcG0cErv0TPOvHhhvNlrWqtzoEFJR6cvHJk4HcwdoyYV+RjWqeRqpBM
 py2jYeMBfVLqM0aNBTlk+5iZN2Dh5Zv7CvdBDsF+7SbN5krMCanzKd30kGeXWsQmUgAl
 sBVBsYjbeQ03fqdGbEnSNe+rTTz346mUnQ96hZVa7Jqi/gAKoQY+pzQ4a5lFMH2+WyL9 OQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bt2crs0xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 14:16:03 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JI7NRQ017618;
        Tue, 19 Oct 2021 18:16:02 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3bqpcbafm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 18:16:02 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JIG1Zp53346704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 18:16:01 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12DC4C605B;
        Tue, 19 Oct 2021 18:16:01 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD501C6055;
        Tue, 19 Oct 2021 18:15:59 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.235.71])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 18:15:59 +0000 (GMT)
Subject: Re: [PATCH] ibmvfc: Fixup duplicate response detection
To:     Brian King <brking@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, stable@vger.kernel.org
References: <20211019152129.16558-1-brking@linux.vnet.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <e36b7858-0408-e21d-de9f-76284db1dea0@linux.ibm.com>
Date:   Tue, 19 Oct 2021 11:15:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211019152129.16558-1-brking@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MLBmpu0XTfa0uPZjydcfXtDpI5Dlbdi2
X-Proofpoint-GUID: MLBmpu0XTfa0uPZjydcfXtDpI5Dlbdi2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190105
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/21 8:21 AM, Brian King wrote:
> Commit a264cf5e81c7 ("scsi: ibmvfc: Fix command state accounting and stale response detection")
> introduced a regression in detecting duplicate responses. This was observed
> in test where a command was sent to the VIOS and completed before
> ibmvfc_send_event set the active flag to 1, which resulted in the
> atomic_dec_if_positive call in ibmvfc_handle_crq thinking this was a
> duplicate response, which resulted in scsi_done not getting called, so we
> then hit a scsi command timeout for this command once the timeout expires.
> This simply ensures the active flag gets set prior to making the hcall to
> send the command to the VIOS, in order to close this window.
> 
> Fixes: a264cf5e81c7 ("scsi: ibmvfc: Fix command state accounting and stale response detection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index a4b0a12f8a97..d0eab5700dc5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1696,6 +1696,7 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
>  
>  	spin_lock_irqsave(&evt->queue->l_lock, flags);
>  	list_add_tail(&evt->queue_list, &evt->queue->sent);
> +	atomic_set(&evt->active, 1);
>  
>  	mb();
>  
> @@ -1710,6 +1711,7 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
>  				     be64_to_cpu(crq_as_u64[1]));
>  
>  	if (rc) {
> +		atomic_set(&evt->active, 0);
>  		list_del(&evt->queue_list);
>  		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
>  		del_timer(&evt->timer);
> @@ -1737,7 +1739,6 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
>  
>  		evt->done(evt);
>  	} else {
> -		atomic_set(&evt->active, 1);
>  		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
>  		ibmvfc_trc_start(evt);
>  	}
> 

