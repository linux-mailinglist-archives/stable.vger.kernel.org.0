Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AAA2C94D6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 02:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgLABuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 20:50:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48638 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbgLABuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 20:50:17 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B11XRON164926;
        Mon, 30 Nov 2020 20:49:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=9w48ssY5kQeUjk80ZTcSv7A8bKBI2hfkM2sR65SpDtE=;
 b=VWk/tclbiNOIrYamrYYEU03dD1H8DLuHyqDeTMydEA9YiMW3y1JOPJScXLfe2acNRZ4D
 bnLj3Q5Xrpnl8kwGYt4Uq7GLXwXQxZoRnUs+n0bf5xmcUMC+YxFZYjcNyvXK1Jwlzzq/
 jpH5MhhvtxyFl0GqmjdUNyawjc0eGECB5DYu3jLdEft4XH81Ro3uRnsNb/ycxV2fJq4R
 qEDRkiuwiQd47gRGhIV2MRaRrjyKEN/U2D7OyJIicVFlQ9F4nY5EBRrraKyiiruDjQOu
 o8ohpwJ2GZkyUWPgb13Ml33WImJcdPOUmMVD4ZBGngTWDp3o3owKygRE39oV9P2bbRY3 fA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355c660dm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 20:49:29 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B11hL0J023593;
        Tue, 1 Dec 2020 01:49:29 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 353e69hbgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 01:49:29 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B11nS3a459352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 01:49:28 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF7CB78068;
        Tue,  1 Dec 2020 01:49:27 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B71DD78060;
        Tue,  1 Dec 2020 01:49:26 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.201.242])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 01:49:26 +0000 (GMT)
Message-ID: <10b9d49db1598959f9bc9fc569c128a5ccc5cc5e.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: ses: Fix crash caused by kfree an invalid pointer
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Ding Hui <dinghui@sangfor.com.cn>, dgilbert@interlog.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Date:   Mon, 30 Nov 2020 17:49:25 -0800
In-Reply-To: <8fbbe4de-13f0-6c99-98f9-5c47c8251a9f@sangfor.com.cn>
References: <20201128122302.9490-1-dinghui@sangfor.com.cn>
         <c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com>
         <4b83e264-2a7e-e877-5f52-16b14b563a87@interlog.com>
         <8fbbe4de-13f0-6c99-98f9-5c47c8251a9f@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 suspectscore=1 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010007
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-11-30 at 10:26 +0800, Ding Hui wrote:
[...]
> sg_ses -e
> Diagnostic pages, followed by abbreviation(s) then page code:
>      Supported Diagnostic Pages  [sdp] [0x0]
>      Configuration (SES)  [cf] [0x1]
>      Enclosure Status/Control (SES)  [ec,es] [0x2]
>      Help Text (SES)  [ht] [0x3]
>   
> # sg_ses -p cf /dev/sdu
>    DELL      MD32xxi           0784
>      disk device has EncServ bit set
> Configuration diagnostic page:
>    number of secondary subenclosures: 0
>    generation code: 0x12c
>    enclosure descriptor list
>      Subenclosure identifier: 0 (primary)
>        relative ES process id: 0, number of ES processes: 0
>        number of type descriptor headers: 5
>        enclosure logical identifier (hex): 0000000000000000
>        enclosure vendor: DELL      product: MD32xxi           rev:
> 0784
>        vendor-specific data:
>          30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30
>          00 00 00 00
>    type descriptor header/text list
>      Element type: Device slot, subenclosure id: 0
>        number of possible elements: 12
>      Element type: Power supply, subenclosure id: 0
>        number of possible elements: 2
>      Element type: Cooling, subenclosure id: 0
>        number of possible elements: 4
>      Element type: Temperature sensor, subenclosure id: 0
>        number of possible elements: 4
>      Element type: SCC controller electronics, subenclosure id: 0
>        number of possible elements: 1
> 
> I'm not goot at ses, but it seems that ses does not get the right 
> component count

Actually there is a possible explanation.  Your kernel log has this in
the middle:

> 2020-11-30 09:31:41.360334 notice [kernel:] [425843.704480] sd
> 19:0:0:0: Embedded Enclosure Device
> 2020-11-30 09:31:41.360335 warning [kernel:] [425843.704732] sd 
> 19:0:0:0: Mode parameters changed

That "Mode parameters changed" implies that what the kernel read first
time around may not be the actual configuration of the enclosure.  In
particular, the generation code being 0x12c is also an indicator things
may have changed.    My theory is when the kernel boots the device is
returning 0 for most of the possible elements, but it changes this at a
later stage.  One way to verify would be to compile ses as modular but
blacklist it so it can't be inserted, then do sg_ses -p to get the
enclosure and then insert the ses module to see if the two agree on the
components.  Unfortunately, even if that's successful, figuring out
what we have to do to the enclosure to get it to finish its internal
scanning may not be so easy.

James


