Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474F8340D4D
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 19:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhCRSja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 14:39:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232749AbhCRSi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 14:38:59 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IIWdqL109310;
        Thu, 18 Mar 2021 14:38:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3pXLc1EHvvY6bcYFLNFDof1vErVH0o5UoU0NC2YAHs8=;
 b=SXPkbWjikvUVuCR5v49xNKzBE8pXbYHNhn/xuGw/BZ3pcVa1b+bR1K/UMz6AaFU2j+u+
 G7s9kYR32CyZuLZykG4iex5NnWyhp070D09RG9f8XoWL26o1FqFctnW+iddYF5bE+5cr
 h5UEMtQ1G4YVZlrC2Say+S0DTjg+SNh05E++V2chwgM1Y9jSVlrXNoVTKI16gu9jSWGd
 JNQQXB2a9gvuquxwx0bXkTDwTfhdGZ5iuY/OFaxqwKgMInQnCPPuFw5QkswJFN/TVcCR
 SgUhd/6/AxoXCqGmrVYm4ZOipxnW9RTaNpoTwRugiMfQtVcBEhRCyFnXWk9vEBQB02JH Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37cbxugjn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 14:38:58 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12IIX2H4113779;
        Thu, 18 Mar 2021 14:38:58 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37cbxugjmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 14:38:58 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IIaC6M030601;
        Thu, 18 Mar 2021 18:38:57 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 378n1ajw7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 18:38:57 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IIcugs28049686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 18:38:56 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67C65AE05F;
        Thu, 18 Mar 2021 18:38:56 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90D13AE062;
        Thu, 18 Mar 2021 18:38:54 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.150.254])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 18:38:54 +0000 (GMT)
Subject: Re: [PATCH v4 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
References: <20210310150559.8956-1-akrowiak@linux.ibm.com>
 <20210310150559.8956-2-akrowiak@linux.ibm.com>
 <20210318001729.06cdb8d6.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <ab9d54a1-afe7-caca-4e5e-99fca9ea2972@linux.ibm.com>
Date:   Thu, 18 Mar 2021 14:38:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210318001729.06cdb8d6.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=912 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103180131
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/17/21 7:17 PM, Halil Pasic wrote:
> On Wed, 10 Mar 2021 10:05:59 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> -		ret = vfio_ap_mdev_reset_queues(mdev);
>> +		matrix_mdev = mdev_get_drvdata(mdev);
> Is it guaranteed that matrix_mdev can't be NULL here? If yes, please
> remind me of the mechanism that ensures this.
>
>> +
>> +		/*
>> +		 * If the KVM pointer is in the process of being set, wait until
>> +		 * the process has completed.
>> +		 */
>> +		wait_event_cmd(matrix_mdev->wait_for_kvm,
>> +			       matrix_mdev->kvm_busy == false,
>> +			       mutex_unlock(&matrix_dev->lock),
>> +			       mutex_lock(&matrix_dev->lock));
>> +
>> +		if (matrix_mdev->kvm)
>> +			ret = vfio_ap_mdev_reset_queues(mdev);
>> +		else
>> +			ret = -ENODEV;
> Didn't we agree to make the call to vfio_ap_mdev_reset_queues()
> unconditional again (for reference please take look at
> Message-ID: <64afa72c-2d6a-2ca1-e576-34e15fa579ed@linux.ibm.com>)?

How about this:

static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
                     unsigned int cmd, unsigned long arg)
{
     int ret = 0;
     struct ap_matrix_mdev *matrix_mdev;

     ...
     case VFIO_DEVICE_RESET:
         matrix_mdev = mdev_get_drvdata(mdev);
         WARN(!matrix_mdev, "Driver data missing from mdev!!");

         if (matrix_mdev) {
             /*
              * If the KVM pointer is in the process of being set, wait 
until
              * the process has completed.
              */
             wait_event_cmd(matrix_mdev->wait_for_kvm,
                        matrix_mdev->kvm_busy == false,
mutex_unlock(&matrix_dev->lock),
mutex_lock(&matrix_dev->lock));

             ret = vfio_ap_mdev_reset_queues(mdev);
         }
         break;
     ...

     return ret;
}

>
> Regards,
> Halil

