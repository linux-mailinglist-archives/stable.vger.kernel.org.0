Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129B942B915
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 09:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhJMHb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 03:31:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232357AbhJMHbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 03:31:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D5g4pN031343;
        Wed, 13 Oct 2021 03:29:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=D+pfGUFddxTw+8giPKU/vhCwbLlh6G1uJNpbcjqOcok=;
 b=gPKVADMLy+VNL6+kqZdHlk5y2FjqoJ1wHwmzjewoyp+/8ktFMiG16mhTuwEIxdaDXE07
 on9kKPTlWd711T4siE7uT+AVVf6+Xx/KeTE1gGRw64LrmipsxQKMqOmW5ZqWIK+VBJPb
 9JI6NJXiEZynSrfwor1YKzuW9H1fqVYEElMDKuaIUMO9aoIEQHPZpzY50dwaJisUcCBG
 WRvfmxCy1T7HfFxabyOX9kEt7pQZtRolwxpBBc3LRCCwfTa+Os6NzBSXGRjn4exACqiN
 zF7ftBQ2gFRVQzipxrYR8y1EIcaBBysu1Rg4Wm7vR0I/Jn4ZTojVXrpMddFC1dwaXAtt OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bnshha1cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 03:29:51 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19D7CqNT018301;
        Wed, 13 Oct 2021 03:29:51 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bnshha1ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 03:29:51 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19D7RupJ001935;
        Wed, 13 Oct 2021 07:29:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bjg4h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 07:29:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19D7O8xt52953450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 07:24:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B45FE11C066;
        Wed, 13 Oct 2021 07:29:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24BC411C064;
        Wed, 13 Oct 2021 07:29:39 +0000 (GMT)
Received: from li-748c07cc-28e5-11b2-a85c-e3822d7eceb3.ibm.com (unknown [9.171.76.4])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 07:29:38 +0000 (GMT)
Message-ID: <e0a2e8ae07d71eb86499ed37c8acf57f557987fe.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 1/1]  s390/cio: make ccw_device_dma_* more robust
From:   Vineeth Vijayan <vneethv@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, bfu@redhat.com
Date:   Wed, 13 Oct 2021 09:29:37 +0200
In-Reply-To: <20211012233247.63b7a22c.pasic@linux.ibm.com>
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
         <13162b9e48402f306b3f50e6686d76a051138a75.camel@linux.ibm.com>
         <20211012233247.63b7a22c.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zd3C3dosJ_f7Y4RYrU58aTMKQb3Kv5YL
X-Proofpoint-GUID: nmJzi-BiRPegQtOagcH-DxDaM6DxaAn9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_02,2021-10-13_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=914 adultscore=0 clxscore=1015 phishscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130047
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-10-12 at 23:32 +0200, Halil Pasic wrote:
> On Tue, 12 Oct 2021 15:36:36 +0200
> Vineeth Vijayan <vneethv@linux.ibm.com> wrote:
> 
> > Looks good. Thanks.
> > Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com>
> 
> Can I convince you to upgrade to Reviewed-by?
You got it.

Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
> 
> > Some minor questions below.
> > 
> > On Mon, 2021-10-11 at 13:59 +0200, Halil Pasic wrote:
> > > Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw
> > > I/O
> > > and
> > > classic notifiers") we were supposed to make sure that
> > > virtio_ccw_release_dev() completes before the ccw device and the
> > > attached dma pool are torn down, but unfortunately we did
> > > not.  Before
> > > that commit it used to be OK to delay cleaning up the memory
> > > allocated
> > > by virtio-ccw indefinitely (which isn't really intuitive for guys
> > > used
> > > to destruction happens in reverse construction order), but now we
> > > trigger a BUG_ON if the genpool is destroyed before all memory
> > > allocated
> > > form it.  
> > allocated from it ?
> 
> Yes. And I think I should add "is deallocated." to the end as well,
> because we don't destroy memory, we deallocate it ;)

