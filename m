Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A69332892
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 15:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhCIO10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 09:27:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229875AbhCIO1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 09:27:22 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129E30h1169765;
        Tue, 9 Mar 2021 09:27:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OgNUMatW/65nKbb9FFG35QRck11HRDtc9fjMst/eTYg=;
 b=H8qsiqL+C/HPv9fWa8rpFPPbEBg1GCI89iXER5fmRLSrMwe5P7w7ndar7xzxaFDU7Vmu
 jU73Sr49lVYEIheBezGMjiSn4KQsoDHkpUQgghKBhKmHF9tYIvEUxT+GpVggDawCWrJR
 UEKdm1dAEa4tQhGD9Yooraob1fIpN3/XxfcAfeNcpLLm05MQVvuSmAtmQAz+7UsI1O7j
 l3Cyapc+61blyR2mWs05uJxpYn3vNARqs/jpYMEviSWs8VmXMGO9xIQBaA0ACrW9ppZ4
 FwR2cVg7Hf1pOVYtGUDZZsFBD+MM3COtpUFDtqDM5hITl2AoDuVAZlQD4UsTVuv34Ayb wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375whqw58g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 09:27:21 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 129E4Ggo183263;
        Tue, 9 Mar 2021 09:27:21 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375whqw582-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 09:27:21 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129EMnPX002983;
        Tue, 9 Mar 2021 14:27:20 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3768s1s2hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 14:27:20 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129ERJ0Q25493762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 14:27:19 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42322AE06A;
        Tue,  9 Mar 2021 14:27:19 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C38CAE060;
        Tue,  9 Mar 2021 14:27:18 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.150.254])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Mar 2021 14:27:18 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20210302204322.24441-1-akrowiak@linux.ibm.com>
 <20210302204322.24441-2-akrowiak@linux.ibm.com>
 <20210303162332.4d227dbe.pasic@linux.ibm.com>
 <14665bcf-2224-e313-43ff-357cadd177cf@linux.ibm.com>
 <20210303204706.0538e84f.pasic@linux.ibm.com>
 <8f5ab6fa-8fd3-27d8-8561-d03ff457df16@linux.ibm.com>
 <20210309112313.4c6e3347.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <64afa72c-2d6a-2ca1-e576-34e15fa579ed@linux.ibm.com>
Date:   Tue, 9 Mar 2021 09:27:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210309112313.4c6e3347.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_11:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=832 spamscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090071
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/9/21 5:23 AM, Halil Pasic wrote:
> On Thu, 4 Mar 2021 12:43:44 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On the other hand, if we don't have ->kvm because something broke,
>> then we may be out of luck anyway. There will certainly be no
>> way to unregister the GISC; however, it may still be possible
>> to unpin the pages if we still have q->saved_pfn.
>>
>> The point is, if the queue is bound to vfio_ap, it can be reset. If we can't
>> clean up the IRQ resources because something is broken, then there
>> is nothing we can do about that.
> Especially since the recently added WARN_ONCE macros calling reset_queues
> unconditionally ain't that bad: we would at least see if there is a
> problem with cleaning up the IRQ resources.
>
> Let's make it unconditional again and observe. Can you send out a v4 with
> this and the other issue fixed.

I agree and I can do that.

>   
>
> Regards,
> Halil

