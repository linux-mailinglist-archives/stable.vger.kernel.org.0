Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F953D5CEF
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhGZOpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 10:45:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24660 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234710AbhGZOpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 10:45:51 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QFHfwD021448;
        Mon, 26 Jul 2021 11:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1sFHS5zJLlrMstVK/2aj2Ztpod8AixmHr4YcumEDeN8=;
 b=BLmHJHHKVeJ7IJsLfOxF1ztyHIpconmdEn6Den5lhv5f7Wd/SedRdfhl8N/HqQRBpzL9
 MOa9TSLrqg0eFmhuN4/UIldU7Rbw2oe9ghBBcsTF7KF/yw565cG33i1cPx8afVByHptr
 R07pPJFwrWAFEIta1m8rcnY3RKOK5wS9ZmCIzt01gT/G2ZPtgkftjUuNb0jeXfrEi24X
 /kOZCVbBT+wYJHH8saytxY7CIPsgSGhvFgH+M0XstdcNSr2YfIzT0w/jfYYVW7IOmG+D
 mqm3Vt2sDbkYX/02hf2EoXReJCwPMoibHNNfZDAY+j0/wNQD+Xz+48fYG4WMm91yxsqw Zg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a1y2hsgp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 11:25:39 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16QFNrV8027759;
        Mon, 26 Jul 2021 15:25:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3a0ag8rrmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 15:25:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16QFMxFQ27984156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 15:22:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BD1BA405F;
        Mon, 26 Jul 2021 15:25:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D80B2A4062;
        Mon, 26 Jul 2021 15:25:32 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.33.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 26 Jul 2021 15:25:32 +0000 (GMT)
Date:   Mon, 26 Jul 2021 17:25:23 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Heiko Carstens <hca@linux.ibm.com>, stable@vger.kernel.org,
        Claire Chang <tientzu@chromium.org>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/1] s390/pv: fix the forcing of the swiotlb
Message-ID: <20210726172523.0fbdda60.pasic@linux.ibm.com>
In-Reply-To: <YPtejB62iu+iNrM+@fedora>
References: <20210723231746.3964989-1-pasic@linux.ibm.com>
        <YPtejB62iu+iNrM+@fedora>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ldcOjuF41nHbAb-Cj17FjrUVXmxMMXk9
X-Proofpoint-ORIG-GUID: ldcOjuF41nHbAb-Cj17FjrUVXmxMMXk9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_10:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 phishscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260086
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 23 Jul 2021 20:27:56 -0400
Konrad Rzeszutek Wilk <konrad@darnok.org> wrote:

> On Sat, Jul 24, 2021 at 01:17:46AM +0200, Halil Pasic wrote:
> > Since commit 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for
> > swiotlb data bouncing") if code sets swiotlb_force it needs to do so
> > before the swiotlb is initialised. Otherwise
> > io_tlb_default_mem->force_bounce will not get set to true, and devices
> > that use (the default) swiotlb will not bounce despite switolb_force
> > having the value of SWIOTLB_FORCE.
> > 
> > Let us restore swiotlb functionality for PV by fulfilling this new
> > requirement.
> > 
> > This change addresses what turned out to be a fragility in
> > commit 64e1f0c531d1 ("s390/mm: force swiotlb for protected
> > virtualization"), which ain't exactly broken in its original context,
> > but could give us some more headache if people backport the broken
> > change and forget this fix.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Fixes: 903cd0f315fe ("swiotlb: Use is_swiotlb_force_bounce for swiotlb data bouncing")
> > Fixes: 64e1f0c531d1 ("s390/mm: force swiotlb for protected virtualization")
> > Cc: stable@vger.kernel.org #5.3+
> > 
> > ---  
> 
> Picked it up and stuck it in linux-next with the other set of patches (Will's fixes).

Thanks!

