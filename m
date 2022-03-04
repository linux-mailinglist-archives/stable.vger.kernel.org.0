Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B994CD5C0
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 14:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbiCDOAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 09:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbiCDOAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 09:00:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDC341987;
        Fri,  4 Mar 2022 05:59:24 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224DvARZ018816;
        Fri, 4 Mar 2022 13:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rJI+W8znlgq3IeuuQK96IK1RIeb4TDW5ujOWEcCPmt4=;
 b=KlKlZReq8u9Vtw9xFXG08RH/hlQuBMylXXtI7dfHNF6Bs1ug9j6wR157qvaYkt6IFM59
 rZj68dGDD/hvpCv9iz6Cq3OAtTBg/1oDka4Kxy3huXy97vje5+CSc1q/xuZq+wEHJLEd
 RTTd+WKcqswbbtb3e1M4kY4NKaOzuWXG1OhJD3CqHQtMzb0XGWux5jb9LW5fG3v81mNN
 kgMjqG0CONSPPX/t9HxpaNSlaJ0zrkuHta+q19CT5DX9vI7aIZc0sb4avY1B/mPzpfN8
 S4pNnca8oa1cBNtgmaoggZcLbVSGksXhdalYU+79Msn3y+VHYMU4nAAPGnuZElw/GdrL yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekb6gt0t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 13:59:09 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224Bg97l007569;
        Fri, 4 Mar 2022 13:59:09 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekb6gt0rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 13:59:09 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224DrZFZ024546;
        Fri, 4 Mar 2022 13:59:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3ek4k81mda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 13:59:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224Dx3UY7536992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 13:59:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AEDFAE051;
        Fri,  4 Mar 2022 13:59:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FC2AAE045;
        Fri,  4 Mar 2022 13:59:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 13:59:03 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 0/2] swiotlb: rework fix info leak with DMA_FROM_DEVICE
Date:   Fri,  4 Mar 2022 14:58:57 +0100
Message-Id: <20220304135859.3521513-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N92PW_cjbVXc--CGf5Nkuep7JfHDooWp
X-Proofpoint-GUID: 6LzP9T3dM405XagGvK82ddQ8-H0bOogf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_06,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=894 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unfortunately, we ended up with the wrong version of the patch "fix info
leak with DMA_FROM_DEVICE" getting merged. We got v4 merged, but the
version we want is v7 with some minor tweaks which were supposed to be
applied by Christoph (swiotlb maintainer). After pointing this out, I
was asked by Christoph to create an incremental fix. 

IMHO the cleanest way to do this is a reverting the incorrect version
of the patch and applying the correct one. I hope that qualifies as
an incremental fix.

The main differences between what we got and what we need are:
* swiotlb_sync_single_for_device is also required to do an extra bounce
* It was decided that we want to defer introducing DMA_ATTR_OVERWRITE,
  until we have exploiters 
* And anyway DMA_ATTR_OVERWRITE must take precedence over
  DMA_ATTR_SKIP_CPU_SYNC, so the v4 implementation of DMA_ATTR_OVERWRITE
  ain't even orrect.


Halil Pasic (2):
  Revert "swiotlb: fix info leak with DMA_FROM_DEVICE"
  swiotlb: fix info leak with DMA_FROM_DEVICE

 Documentation/core-api/dma-attributes.rst |  8 --------
 include/linux/dma-mapping.h               |  8 --------
 kernel/dma/swiotlb.c                      | 23 +++++++++++++++--------
 3 files changed, 15 insertions(+), 24 deletions(-)


base-commit: 38f80f42147ff658aff218edb0a88c37e58bf44f
-- 
2.32.0

