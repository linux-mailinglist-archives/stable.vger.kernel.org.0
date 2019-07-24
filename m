Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D83E72CC4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 13:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfGXLBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 07:01:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727318AbfGXLBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 07:01:34 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OAvQwG090590
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 07:01:33 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2txmv9k9u2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 07:01:33 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 24 Jul 2019 12:01:30 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 24 Jul 2019 12:01:27 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6OB1PAf47448152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 11:01:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 934A652059;
        Wed, 24 Jul 2019 11:01:25 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 53D9A52052;
        Wed, 24 Jul 2019 11:01:25 +0000 (GMT)
Date:   Wed, 24 Jul 2019 13:01:24 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] virtio/s390: fix race on airq_areas[]
In-Reply-To: <74087255-fdae-01a1-7152-f6fac8e13019@de.ibm.com>
References: <20190723225817.12800-1-pasic@linux.ibm.com>
        <74087255-fdae-01a1-7152-f6fac8e13019@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19072411-0028-0000-0000-000003875644
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072411-0029-0000-0000-00002447919D
Message-Id: <20190724130124.0dcfc5c0.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240124
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Jul 2019 08:44:19 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> 
> 
> On 24.07.19 00:58, Halil Pasic wrote:
> > The access to airq_areas was racy ever since the adapter interrupts got
> > introduced to virtio-ccw, but since commit 39c7dcb15892 ("virtio/s390:
> > make airq summary indicators DMA") this became an issue in practice as
> > well. Namely before that commit the airq_info that got overwritten was
> > still functional. After that commit however the two infos share a
> > summary_indicator, which aggravates the situation. Which means
> > auto-online mechanism occasionally hangs the boot with virtio_blk.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> > Fixes: 96b14536d935 ("virtio-ccw: virtio-ccw adapter interrupt support.")
> > ---
> > * We need definitely this fixed for 5.3. For older stable kernels it is
> > to be discussed. @Connie what do you think: do we need a cc stable?
> 
> Unless you can prove that the problem could never happen on old version
> we absolutely do need cc stable.

No I would not like to make an attempt at proving that. I prefer code
race free anyway. CC-ing stable.
 
> 
> > 
> > * I have a variant that does not need the extra mutex but uses cmpxchg().
> > Decided to post this one because that one is more complex. But if there
> > is interest we can have a look at it as well.
> 
> This is slow path (startup) and never called in hot path. Correct? Mutex should be
> fine.

Right, this is only relevant during device initialization, which is an
infrequent operation.

Thanks,
Halil

> > ---
> >  drivers/s390/virtio/virtio_ccw.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > index 1a55e5942d36..d97742662755 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -145,6 +145,8 @@ struct airq_info {
> >  	struct airq_iv *aiv;
> >  };
> >  static struct airq_info *airq_areas[MAX_AIRQ_AREAS];
> > +DEFINE_MUTEX(airq_areas_lock);
> > +
> >  static u8 *summary_indicators;
> >  
> >  static inline u8 *get_summary_indicator(struct airq_info *info)
> > @@ -265,9 +267,11 @@ static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
> >  	unsigned long bit, flags;
> >  
> >  	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
> > +		mutex_lock(&airq_areas_lock);
> >  		if (!airq_areas[i])
> >  			airq_areas[i] = new_airq_info(i);
> >  		info = airq_areas[i];
> > +		mutex_unlock(&airq_areas_lock);
> >  		if (!info)
> >  			return 0;
> >  		write_lock_irqsave(&info->lock, flags);
> > 
> 

