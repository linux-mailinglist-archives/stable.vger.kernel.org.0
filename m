Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B8432C82F
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357080AbhCDAev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376265AbhCCTnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 14:43:03 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123JXHUP016729;
        Wed, 3 Mar 2021 14:42:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IacLFA3LbjrQQztZFwWNWxbRWKqrcud7frA8MSdgJyA=;
 b=ci/LRfIOFF4Ct1fLMiLuVWxzdzuYi9MgpI1+vS9YSz3sR+lbScx0qZ3f+nNQM0bRgvow
 uv6BGQhrCnDvv61pZ2lw9bZN9CrPOK4HtX4tkfbMbVmMRwedk0EdL6nBaN4sguSLAByV
 AliliIs10mCMgO9CwpagO2vx2Jx+fn89KoxUnzRpgjC+E9agYAczPqujh8Mn5UyRmImH
 +hOMGMV221J8zdqlmRALBJ8HIP/AxQs9nbVKGdob02XTcwF7wKb6LAxU08J4dpM3K253
 VSqIiOyU2cceDFeHLPhWzJfUKT6X/i+v4Pv/X37M/11l/cR5fAbLuM0E6GxOzNE3/MZd oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372gpc889n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 14:42:19 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123JYEHY021490;
        Wed, 3 Mar 2021 14:42:19 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372gpc888w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 14:42:19 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 123Jb7X3004532;
        Wed, 3 Mar 2021 19:42:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3712fmj2mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 19:42:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 123JgDYL9372026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Mar 2021 19:42:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D16C45204E;
        Wed,  3 Mar 2021 19:42:13 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.0.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 1FCF15204F;
        Wed,  3 Mar 2021 19:42:13 +0000 (GMT)
Date:   Wed, 3 Mar 2021 20:42:11 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v3 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210303204211.4c021c25.pasic@linux.ibm.com>
In-Reply-To: <e5cc2a81-7273-2b3e-0d4c-c6c17502bdae@linux.ibm.com>
References: <20210302204322.24441-1-akrowiak@linux.ibm.com>
 <20210302204322.24441-2-akrowiak@linux.ibm.com>
 <20210303162332.4d227dbe.pasic@linux.ibm.com>
 <e5cc2a81-7273-2b3e-0d4c-c6c17502bdae@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_06:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=969 phishscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030137
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Mar 2021 11:41:22 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> > How do you exect userspace to react to this -ENODEV?  
> 
> The VFIO_DEVICE_RESET ioctl expects a return code.
> The vfio_ap_mdev_reset_queues() function can return -EIO or
> -EBUSY, so I would expect userspace to handle -ENODEV
> similarly to -EIO or any other non-zero return code. I also
> looked at all of the VFIO_DEVICE_RESET calls from QEMU to see
> how the return from the ioctl call is handled:
> 
> * ap: reports the reset failed along with the rc

And carries on as if nothing happened. There is not much smart
userspace can do in such a situation. Therefore the reset really
should not fail.

Please note that in this particular case, if the userspace would
opt for a retry, we would most likely end up in a retry loop.

> * ccw: doesn't check the rc
> * pci: kind of hard to follow without digging deep, but definitely
>           handles non-zero rc.
> 
> I think the caller should be notified whether the queues were
> successfully reset or not, and why; in this case, the answer is
> there are no devices to reset.

That is the wrong answer. The ioctl is supposed to reset the
ap_matrix_mdev device. The ap_matrix_mdev device still exists. Thus
returning -ENODEV is bugous.

Regards,
Halil
