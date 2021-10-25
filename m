Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E5F439224
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 11:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhJYJSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 05:18:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230146AbhJYJSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 05:18:20 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P7YKgS003484;
        Mon, 25 Oct 2021 05:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0cdTbS4PeAsFScHNRsKQd+hd4cdryclSLNHVOA5e1Mw=;
 b=SjR47TKiCprp8c1zvJLVUFWOom9Fh6lTnskYDYdFDa/lpKXYmjJkQa2dY1syvtyqkAOE
 LFcsCxXOiWNbMC9qz/nI0cYNKeMSThI0qIR0fkVOyHLGD08uhBDXoPa3DnIO/ALjM5wz
 xenrUL6Q9mHmb2E10jPrxNkLE9PkX1UY7KNraBq3T/EJeL948brWUhBkH2n3jXukTc4L
 i/yVhtycupySdPbusvOzNB+jnWlFpQkWpTN/2uU25Ww97Vx9TffzaOCkP7xHiLP8EniB
 mIavdSuqAFHan6YPSABQ4/a/jzwAAlvYTRR/9af1qR/6mjaOJthNYohJOmKwDKJ06hBY eA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bvyk2w7p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 05:15:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P98hxv003772;
        Mon, 25 Oct 2021 09:15:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bv9njc1y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:15:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9FsBe52953522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:15:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 091F311C04A;
        Mon, 25 Oct 2021 09:15:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C285811C058;
        Mon, 25 Oct 2021 09:15:53 +0000 (GMT)
Received: from sig-9-145-154-249.de.ibm.com (unknown [9.145.154.249])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:15:53 +0000 (GMT)
Message-ID: <1f3213f28cba80058e7c66d4e8ab2874b4a1e567.camel@linux.ibm.com>
Subject: Re: [PATCH 5.10 1/1] s390/pci: fix zpci_zdev_put() on reserve
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Date:   Mon, 25 Oct 2021 11:15:53 +0200
In-Reply-To: <YXZ03dkv7UB8l8Il@kroah.com>
References: <20211025090026.3392254-1-schnelle@linux.ibm.com>
         <20211025090026.3392254-2-schnelle@linux.ibm.com>
         <YXZ03dkv7UB8l8Il@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2mC8u9wHnfhBaysGH2zvwNUqmCdUJiNg
X-Proofpoint-ORIG-GUID: 2mC8u9wHnfhBaysGH2zvwNUqmCdUJiNg
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250054
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-10-25 at 11:11 +0200, Greg KH wrote:
> On Mon, Oct 25, 2021 at 11:00:26AM +0200, Niklas Schnelle wrote:
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
> > Link: https://lore.kernel.org/r/20211012093425.2247924-1-schnelle@linux.ibm.com
> > ---
> >  arch/s390/include/asm/pci.h        |  3 ++
> >  arch/s390/pci/pci.c                | 45 ++++++++++++++++++++++++++----
> >  arch/s390/pci/pci_event.c          |  4 +--
> >  drivers/pci/hotplug/s390_pci_hpc.c |  9 +-----
> >  4 files changed, 46 insertions(+), 15 deletions(-)
> 
> Does not apply:
> 
> Applying patch s390-pci-fix-zpci_zdev_put-on-reserve.patch
> patching file arch/s390/include/asm/pci.h
> patching file arch/s390/pci/pci.c
> Hunk #3 FAILED at 835.
> Hunk #4 succeeded at 843 (offset 1 line).
> 1 out of 4 hunks FAILED -- rejects in file arch/s390/pci/pci.c
> patching file arch/s390/pci/pci_event.c
> patching file drivers/pci/hotplug/s390_pci_hpc.c
> 
> 
> What did you make this against?
> 
> Ah, that's due to another patch we have in the queue right now.  I'll go
> fix this up by hand, thanks!
> 
> greg k-h

Yes it's due to "s390/pci: cleanup resources only if necessary" you
need to drop that and keep this one.


