Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4275C42BCC1
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 12:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhJMK2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 06:28:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239036AbhJMK2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 06:28:53 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D821TW031089;
        Wed, 13 Oct 2021 06:26:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KKIQMhWl2kH6fAjF4q4vYTmJppsR2SjXE0gX5MtAqEg=;
 b=AYScawVikRBL1wMexwGn/rwOaxlTylIqV/vh70DsMpKVfzoeiA25UR4odJTpAcnfaPd0
 0fc2LYNGL5EXAfzfAtqzJkeCObGMFeWlLqiFtv/eXsbZRnXuyIH2IpYL/kn9194BWZju
 9k2B64ZkxuwKKBytaC+16IDVTeAgUM97qUPjYQDosN4IGOQCpDc0R+6VvaTPH9uiY8+i
 jS44C+oSN1Yj5DvmXDkq/kxlFWvnDxyFMZbuIDRBqt8JCtvuzEw2WE7MJ0CvaMpFOMb6
 bWFsu/HOuqrZaJX7IWEqYuqoTB2I5WMB/gH5VW88jMsUHzbG03e9EcT0bIvXy51zpKc8 Ng== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnrncpcr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:26:49 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DAHQld027121;
        Wed, 13 Oct 2021 10:26:46 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2q9skcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 10:26:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DAQZB156557940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 10:26:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE169A4067;
        Wed, 13 Oct 2021 10:26:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68AA8A4062;
        Wed, 13 Oct 2021 10:26:35 +0000 (GMT)
Received: from sig-9-145-155-31.de.ibm.com (unknown [9.145.155.31])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 10:26:35 +0000 (GMT)
Message-ID: <31dcc776244843aa76deebd49f4ba3fbe4819990.camel@linux.ibm.com>
Subject: Re: [PATCH 5.10 STABLE] s390/pci: fix zpci_zdev_put() on reserve
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, gor@linux.ibm.com
Date:   Wed, 13 Oct 2021 12:26:34 +0200
In-Reply-To: <YWaiON5Hw8UnWLIK@kroah.com>
References: <16338613396828@kroah.com>
         <20211012093425.2247924-1-schnelle@linux.ibm.com>
         <YWaiON5Hw8UnWLIK@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IFJ2Ws0UtUdUs4uXKZEOBG-u-VV9yl_7
X-Proofpoint-ORIG-GUID: IFJ2Ws0UtUdUs4uXKZEOBG-u-VV9yl_7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_03,2021-10-13_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130068
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 11:09 +0200, Greg KH wrote:
> On Tue, Oct 12, 2021 at 11:34:25AM +0200, Niklas Schnelle wrote:
> > [ Upstream commit a46044a92add6a400f4dada7b943b30221f7cc80 ]
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
> 
> Same for the 5.14 patch, please submit the series that resolves this,
> not changing individual patches a lot.
> 
> thanks,
> 
> greg k-h

For the 5.14 patch that makes total sense, though these were not
originally a series but just happened to touch the same area. For v5.10
we don't yet have the flag for tracking the PCI resources in the struct
zpci_dev which was introduced as part of a larger non-trivial
refactoring series which landed in mainline as part of 5.13.

This backport patch consequently does not include the change from
commit 023cc3cb1e4b ("s390/pci: cleanup resources only if necessary").
Instead it does an unconditional call to zpci_cleanup_bus_resources()
as done previously on 5.10. This is not releant for fixing the problem
targeted by this patch. Interestingly though due to a difference in
behavior of the common code while the problem exists on 5.10 from code
inspection it seems that at the point of releasing the device common
code does not hold a reference to the pci_dev and so the original crash
doesn't happen in that scenario but could possibly occur under
different circumstances.

Thanks,
Niklas

