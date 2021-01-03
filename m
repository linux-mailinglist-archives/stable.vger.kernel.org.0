Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8FE2E8D5D
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 18:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbhACRBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jan 2021 12:01:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27196 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727471AbhACRBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jan 2021 12:01:47 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 103GVVUX064786;
        Sun, 3 Jan 2021 12:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=JaYwZjj+N1TBPFfLo+tdnAXQJ2UtAmbmjAg6urTItNE=;
 b=q9JoDwdjwG1VrLov4dtul/vmiXs8gfIJRDy/PVHunmXi6gsvsLks/BVmNDrwkhOfXuCA
 J2Hfd3k5vPmC7D/zyWfNen75NiJT7/ODhSyM1TtzU5TxglY14B016Mvg3JN731qwqUiq
 ebSJxevAM1KJhKab67oqg0vA5dxf2Z3mS/pKT3BR09idAlfL5AuAKgYUBMIQQA2Da8wm
 HtCYTppjau/MXGeZpyQs2FzY9+UIMDpkuqvy8jreOkLbyH1ToZ7RmAFpgIUIM0wLTbNZ
 GnryiB3AJbml4ts4FdE4DA7LI3X60TnTdkI2Onk6Mqh5FHivvdZOhBowb7b0dXcDH8SW Pw== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ubk3csmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 Jan 2021 12:00:52 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 103GvF7A016715;
        Sun, 3 Jan 2021 17:00:51 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 35tgf8gvjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 Jan 2021 17:00:51 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 103H0oOA20578790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 Jan 2021 17:00:50 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B61378064;
        Sun,  3 Jan 2021 17:00:50 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D6E878060;
        Sun,  3 Jan 2021 17:00:46 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.172.80])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  3 Jan 2021 17:00:46 +0000 (GMT)
Message-ID: <739a3639944f099a76d145eb119b77701f13444d.camel@linux.ibm.com>
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Arnd Bergmann <arnd@kernel.org>, Phil Oester <kernel@linuxace.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sun, 03 Jan 2021 09:00:45 -0800
In-Reply-To: <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
References: <20200908213715.3553098-1-arnd@arndb.de>
         <20200908213715.3553098-2-arnd@arndb.de>
         <20201231001553.GB16945@home.linuxace.com>
         <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-03_07:2020-12-31,2021-01-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 mlxscore=0 phishscore=0 mlxlogscore=854
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101030101
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-01-03 at 17:26 +0100, Arnd Bergmann wrote:
[...]
> @@ -8209,7 +8208,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance
> *instance,
>                 if (instance->consistent_mask_64bit)
>                         put_unaligned_le64(sense_handle, sense_ptr);
>                 else
> -                       put_unaligned_le32(sense_handle, sense_ptr);
> +                       put_unaligned_le64(sense_handle, sense_ptr);
>         }

This hunk can't be right.  It effectively means removing the if.
However, the if is needed because sense_handle is a dma_addr_t which
can be either 32 or 64 bit.  What about changing the if to 

if (sizeof(dma_addr_t) == 8)

instead?

James


