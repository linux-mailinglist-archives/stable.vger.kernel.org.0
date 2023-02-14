Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8023696A7A
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 17:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjBNQ6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 11:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjBNQ54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 11:57:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F18455BC;
        Tue, 14 Feb 2023 08:57:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EGYEos020143;
        Tue, 14 Feb 2023 16:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=IqlobWYvmWPrvWZTU2e2fAXIdeYj2OGmeRqyvvCSQpE=;
 b=FzbT86fH5bE+/3SZuXlo86oPJYcLF6o3Tyowc9D+Y8WDb1Z+cIYtzHhkZWNEg+ae/SpH
 g0Q152QaR/C9+Y7lL1Yu9r5l7cmH8tNn6zbrRH+8yVp+KcYAb5d3jgSB0W9bLxmzlaGY
 iETi0a/tsye6Ox8rrMeRlrfYEblQ73zNlRdpomglu2SVAdEZfwTbBQxBMkVJihNNohIP
 9l8iooelPLXmu7wFIVvnIm+SK3jPowdVH2IA3FZZFzsRUIlAXUg0aFi31oH5HpIaOrq5
 WFaDCzvyRzZfUcVtIEKck/3kMOZRc4l9TjkYGRIGTxw966vU9FDf0tG2hfv/F7hb9gNt nw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np3jtwwx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 16:57:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31EGtBfA009766;
        Tue, 14 Feb 2023 16:57:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f5uuhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 16:57:43 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31EGuHon039739;
        Tue, 14 Feb 2023 16:57:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3np1f5uuff-7;
        Tue, 14 Feb 2023 16:57:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Kees Cook <keescook@chromium.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: Allocate cmd_priv with scsicmd
Date:   Tue, 14 Feb 2023 11:57:33 -0500
Message-Id: <167639371107.486235.10067171407828975609.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230128000409.never.976-kees@kernel.org>
References: <20230128000409.never.976-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_11,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=838 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140144
X-Proofpoint-ORIG-GUID: pGBas5kpAoXa69N5bKbXhYDo1PvarHjU
X-Proofpoint-GUID: pGBas5kpAoXa69N5bKbXhYDo1PvarHjU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 27 Jan 2023 16:04:13 -0800, Kees Cook wrote:

> The aac_priv() helper assumes that the private cmd area immediately
> follows struct scsi_cmnd. Allocate this space as part of scsicmd,
> else there is a risk of heap overflow. Seen with GCC 13:
> 
> ../drivers/scsi/aacraid/aachba.c: In function 'aac_probe_container':
> ../drivers/scsi/aacraid/aachba.c:841:26: warning: array subscript 16 is outside array bounds of 'void[392]' [-Warray-bounds=]
>   841 |         status = cmd_priv->status;
>       |                          ^~
> In file included from ../include/linux/resource_ext.h:11,
>                  from ../include/linux/pci.h:40,
>                  from ../drivers/scsi/aacraid/aachba.c:22:
> In function 'kmalloc',
>     inlined from 'kzalloc' at ../include/linux/slab.h:720:9,
>     inlined from 'aac_probe_container' at ../drivers/scsi/aacraid/aachba.c:821:30:
> ../include/linux/slab.h:580:24: note: at offset 392 into object of size 392 allocated by 'kmalloc_trace'
>   580 |                 return kmalloc_trace(
>       |                        ^~~~~~~~~~~~~~
>   581 |                                 kmalloc_caches[kmalloc_type(flags)][index],
>       |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   582 |                                 flags, size);
>       |                                 ~~~~~~~~~~~~
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[1/1] scsi: aacraid: Allocate cmd_priv with scsicmd
      https://git.kernel.org/mkp/scsi/c/7ab734fc7598

-- 
Martin K. Petersen	Oracle Linux Engineering
