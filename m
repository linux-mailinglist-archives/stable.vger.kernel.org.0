Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E82DA0B5
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502729AbgLNTkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:40:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502451AbgLNTkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 14:40:07 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEJWXLH055980;
        Mon, 14 Dec 2020 14:39:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NfbmMGPGggSntZnV08WpyL7IdWUT25YdQzm8WlnYAO8=;
 b=AQerL53bXzprya9YvkNX4wQpn6WikgNvPSPIqoCyFhlQFtYtOOVTDd5+G32y7ef0hyCN
 k5y+D4z/fvjP/8FD4ZnEiX6/dfE2z7tuGALVYtsG8eRY21mGSFqX6lib8JznXO0uUOaV
 OEV6Ng8sRVaXmnedu69+p5t46UlBD5HAR/UlMRCyhE4eZYLC84RXB6urhdbWSvFz8mjI
 eLUbyfKA+0ApHQZro5n6a4Y1c5YRrkBwEG773gUiwCpOv4WxGMnOddzFl4kXzpr/IwPE
 E0qGl6B1uZcA9LIL0KW4XYY/y4LI+40JDrZ6Vev+iHj3m7ZneV7ieWk82fMy4isHyS4W fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ebcg5hfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:39:20 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BEJWw8a058074;
        Mon, 14 Dec 2020 14:39:20 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ebcg5hfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:39:20 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BEJWm0v002872;
        Mon, 14 Dec 2020 19:39:19 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 35d525h24a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 19:39:19 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BEJdIKA26018208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 19:39:18 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64F82AE064;
        Mon, 14 Dec 2020 19:39:18 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE97CAE05C;
        Mon, 14 Dec 2020 19:39:17 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 19:39:17 +0000 (GMT)
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org, sashal@kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
 <X9ebwKJSSyVP/M9H@kroah.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <237fe6d3-ebcc-1046-b295-a0154ce1158e@linux.ibm.com>
Date:   Mon, 14 Dec 2020 14:39:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <X9ebwKJSSyVP/M9H@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_10:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=797 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140125
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/14/20 12:07 PM, Greg KH wrote:
> On Mon, Dec 14, 2020 at 11:56:17AM -0500, Tony Krowiak wrote:
>> The vfio_ap device driver registers a group notifier with VFIO when the
>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>> event). When the KVM pointer is set, the vfio_ap driver takes the
>> following actions:
>> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>>     of the mediated device.
>> 2. Calls the kvm_get_kvm() function to increment its reference counter.
>> 3. Sets the function pointer to the function that handles interception of
>>     the instruction that enables/disables interrupt processing.
>> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>>     the guest.
>>
>> In order to avoid memory leaks, when the notifier is called to receive
>> notification that the KVM pointer has been set to NULL, the vfio_ap device
>> driver should reverse the actions taken when the KVM pointer was set.
>>
>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
>>   1 file changed, 20 insertions(+), 9 deletions(-)
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>

I read the document on the correct way to submit patches for inclusion in
the stable kernel. I apologize for my ignorance, but I don't see the
problem. Can you help me out here? Does a patch that fixes a memory leak
not qualify or is it something else?


