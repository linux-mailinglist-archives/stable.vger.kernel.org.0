Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D4C3241E0
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 17:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhBXQOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 11:14:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21010 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235700AbhBXQLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 11:11:44 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11OG3Di0067168;
        Wed, 24 Feb 2021 11:10:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mt66z5SUon43B4XN4SSL9tOftqm41yhSmF8UXK0gtPo=;
 b=iJnSVN3uvfPtaiHg3tcbAoknuu3/5CHYRWgevGnUwlmfYDkXqP0DacPc7e0Tsu52teeQ
 EuhLe/3Qg2E6YgLgATWuIKT5FiZ/k8/D5ASqqF9Y6InhCXp/lCLc0+3wINYz9tWnnriA
 Q5Ir4Zue5lKq96qjMDFX47qzABfzObKcncJeZp/+kqwFPGlydwSTdVT67MF2klcJMTOa
 5YqQetOag18ihaDwVl+4K9PI4f6ykJ9uZ9QuVZaz7HlAvZzmYUkqYhSTmzVXYgkeokZU
 JI5oZBPcexMz9J6rRnYpDCcHKRltj5eSgNYFfmpOHne98ai/NSKjyYDqi5CboP++oDd7 SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36wma7e32f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 11:10:46 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11OG3Me2068351;
        Wed, 24 Feb 2021 11:10:46 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36wma7e31g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 11:10:46 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11OG0UVp015461;
        Wed, 24 Feb 2021 16:10:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt283psy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 16:10:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11OGASSG28836202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 16:10:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EC95A404D;
        Wed, 24 Feb 2021 16:10:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09231A4051;
        Wed, 24 Feb 2021 16:10:41 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.95.10])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Feb 2021 16:10:40 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20210216011547.22277-1-akrowiak@linux.ibm.com>
 <20210216011547.22277-2-akrowiak@linux.ibm.com>
 <20210223104805.6a8d1872.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e07d6f8e-f29e-7c4e-4226-5a5c072e7ae6@de.ibm.com>
Date:   Wed, 24 Feb 2021 17:10:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223104805.6a8d1872.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-24_06:2021-02-24,2021-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 mlxlogscore=858 spamscore=0 clxscore=1011
 priorityscore=1501 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240124
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 23.02.21 10:48, Halil Pasic wrote:
> On Mon, 15 Feb 2021 20:15:47 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> This patch fixes a circular locking dependency in the CI introduced by
>> commit f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
>> pointer invalidated"). The lockdep only occurs when starting a Secure
>> Execution guest. Crypto virtualization (vfio_ap) is not yet supported for
>> SE guests; however, in order to avoid CI errors, this fix is being
>> provided.
>>
>> The circular lockdep was introduced when the masks in the guest's APCB
>> were taken under the matrix_dev->lock. While the lock is definitely
>> needed to protect the setting/unsetting of the KVM pointer, it is not
>> necessarily critical for setting the masks, so this will not be done under
>> protection of the matrix_dev->lock.
> 
> 
> 
> With the one little thing I commented on below addressed: 
> Acked-by: Halil Pasic <pasic@linux.ibm.com>  

Tony, can you comment on Halils comment or send a v3 right away?
