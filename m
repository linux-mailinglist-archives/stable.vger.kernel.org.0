Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392B24391BC
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhJYIwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:52:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232099AbhJYIwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 04:52:15 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P7oSEg002988;
        Mon, 25 Oct 2021 04:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=gzUTmA1exULffyIsvanPN5mvqhyS5RnYQ99bJ+ZV0Ns=;
 b=rucDEZNdWI5loipilskJ+2Wrz+TPQeCQg0XoOTPBgjvsN37o1E1B5KulQwZ+ofgyaI5v
 fmLGUHCVn0/CPawLVRQUv8RprLKNk9jP9SF0R9eZogl9QZXkQITVrZd7nJIu+Vc0vnL1
 RZMnNGnwr2Pab5Y4dwdNM3xoz67WKlIhoRKXATnyCCreHBXoWedTR/QDaQfVw2c+wBb0
 Sd5mRUNZqBy5+E/dV/8pNVRODEdi5BuRcsPNOBVlwuGeIKDkuugw1sQxF5fp/rZCRe77
 tFHLLI+xNU4HMdJgAdABF+ryAv7aEaNza2C850K1yTR8mGcSWF5lyCkVv/dhupJR+U6x +A== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bvydfvvh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 04:49:50 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P8mlaP028851;
        Mon, 25 Oct 2021 08:49:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3bva19j718-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 08:49:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P8nkxl50659752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 08:49:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB26611C05E;
        Mon, 25 Oct 2021 08:49:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B050811C058;
        Mon, 25 Oct 2021 08:49:45 +0000 (GMT)
Received: from sig-9-145-154-249.de.ibm.com (unknown [9.145.154.249])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 08:49:45 +0000 (GMT)
Message-ID: <ccfa3f580b8b45f3d6bfd881a2fa5e37d1c2191e.camel@linux.ibm.com>
Subject: Re: [PATCH 5.14 2/2] s390/pci: fix zpci_zdev_put() on reserve
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Date:   Mon, 25 Oct 2021 10:49:45 +0200
In-Reply-To: <YXZhf5c0iFleZfqs@kroah.com>
References: <20211021141341.344756-1-schnelle@linux.ibm.com>
         <20211021141341.344756-3-schnelle@linux.ibm.com>
         <YXZhf5c0iFleZfqs@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -uqE8jedxQUVL38wk1NtxbsgaP9iDhFO
X-Proofpoint-GUID: -uqE8jedxQUVL38wk1NtxbsgaP9iDhFO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=962
 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250050
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-10-25 at 09:49 +0200, Greg KH wrote:
> On Thu, Oct 21, 2021 at 04:13:41PM +0200, Niklas Schnelle wrote:
> > commit a46044a92add6a400f4dada7b943b30221f7cc80 upstream.
> > 
> > Since commit 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
> > the reference count of a zpci_dev is incremented between
> > pcibios_add_device() and pcibios_release_device() which was supposed to
> > prevent the zpci_dev from being freed while the common PCI code has
> > access to it. It was missed however that the handling of zPCI
> > availability events assumed that once zpci_zdev_put() was called no
> > later availability event would still see the device. With the previously
> > mentioned commit however this assumption no longer holds and we must
> > make sure that we only drop the initial long-lived reference the zPCI
> > subsystem holds exactly once.
> > 
> > Do so by introducing a zpci_device_reserved() function that handles when
> > a device is reserved. Here we make sure the zpci_dev will not be
> > considered for further events by removing it from the zpci_list.
> > 
> > This also means that the device actually stays in the
> > ZPCI_FN_STATE_RESERVED state between the time we know it has been
> > reserved and the final reference going away. We thus need to consider it
> > a real state instead of just a conceptual state after the removal. The
> > final cleanup of PCI resources, removal from zbus, and destruction of
> > the IOMMU stays in zpci_release_device() to make sure holders of the
> > reference do see valid data until the release.
> > 
> > Fixes: 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> 
> This is also needed for 5.10.y, can you please provide a working
> backport for that tree too?
> 
> thanks,
> 
> greg k-h

Hi Greg,

Sorry again for the confusion. For v5.10.y the backport I sent
originally is the correct one. I had replied there explaining that
backporting the prerequisite commit to v5.10.y makes little sense
because the flag it checks isn't there yet. The backport for v5.10 also
doesn't subsume the prerequisite commits change. I guess this reply was
missed. I'll resent anyway then we have both v5.14.y and v5.10.y sent
today and easier to find.

Thanks,
Niklas

