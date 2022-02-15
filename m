Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6610E4B617A
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 04:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiBODSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 22:18:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiBODSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 22:18:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9475320194;
        Mon, 14 Feb 2022 19:18:41 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F2QVst001610;
        Tue, 15 Feb 2022 03:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=FzLigOoeCoSYQPJVi7SvmZnPA5am3fQUToLcfuSejgY=;
 b=d7gfmnkdsSsvGqJKcqqirH26RuLTNEfEQLUpVl7ez7BK2y1FvsQzIOjBDB7ZD2yQg2V5
 cTcrcJb+1LomzUNSDDQfXQTvzN1Qy2lREVLf0li2JsC1dkAu5engKFYB90K3YYIezSnB
 V/9Z7nm33U8TsHsbqE7SfVUCa0vuIBFGW/GLHtrkbAqehVGe/NIVY2LnvL6d/dSI1kNe
 yQYkDgVH7pf25dWqTRIp4A057gBPp2sbzTIyRJmkaixL536YKoVMPrZInYFf1K+8ftUr
 fRs0AX6w9fY8LPqjiFGQptcb2h8CLFZoC83oX7Wzf1+drH8IvEWxCwqEm0p+FeCiN5/m Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63p26hbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:18:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3GUPv094017;
        Tue, 15 Feb 2022 03:18:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3e62xe04g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:18:39 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21F3Ic65101135;
        Tue, 15 Feb 2022 03:18:38 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3e62xe04fq-2;
        Tue, 15 Feb 2022 03:18:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] lpfc: fix pt2pt nvme PRLI reject LOGO loop
Date:   Mon, 14 Feb 2022 22:18:36 -0500
Message-Id: <164489509959.14916.3712591204220342115.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220212163120.15385-1-jsmart2021@gmail.com>
References: <20220212163120.15385-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: iogddlikEIraRtZj3emxdPjXgadCC_zC
X-Proofpoint-GUID: iogddlikEIraRtZj3emxdPjXgadCC_zC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 12 Feb 2022 08:31:20 -0800, James Smart wrote:

> When connected point to point, the driver does not know the FC4's
> supported by the other end. In Fabrics, it can query the nameserver.
> Thus the driver must send PRLI's for the FC4s it supports and enable
> support based on the acc(ept) or rej(ect) of the respective FC4 PRLI.
> Currently the driver supports SCSI and NVMe PRLI's.
> 
> Unfortunately, although the behavior is per standard, many devices
> have come to expect only SCSI PRLI's. In this particular example, the
> NVMe PRLI is properly RJT'd but the target decided that it must LOGO after
> seeing the unexpected NVMe PRLI. The LOGO causes the sequence to restart
> and login is now in an infinite failure loop.
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] lpfc: fix pt2pt nvme PRLI reject LOGO loop
      https://git.kernel.org/mkp/scsi/c/7f4c5a26f735

-- 
Martin K. Petersen	Oracle Linux Engineering
