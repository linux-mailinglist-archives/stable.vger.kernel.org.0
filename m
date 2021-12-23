Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8767247DE7B
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 06:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhLWFJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 00:09:16 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19046 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhLWFJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 00:09:15 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0I01H006035;
        Thu, 23 Dec 2021 05:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=jNyUcZXpDntX62QUPUrDsPuCsX2H88Ob618GR6ZOMpE=;
 b=U1Lcf02Esq1dCy32EGOSdPJyVqYYT8aYjsg2RW31ubfmig0aui7w5n9Qb6Mj9ri2SmBX
 jEkyxHwkHw1iLPGbIdpI6o7rKeZWRMisWFFhkdtmo99WWEkm8UlP7q0mUC5eF/Ti40v8
 uNKqxlRS6BuMzc9vxDqcSQNfDMceTigJ7tHsiCKArwFx7dRlWFPbrXPUJXGrGAZFATvb
 OqdvwVRy/JsH50ZcN/TMLrAnOBPg35VZ7+e67myonY6sXKaOFqDnEPGCSfkiti6KuPYM
 eaKnX7ZvzK1AKfnPkiJ/25rGirWgH8lvf1GeaU1K5jj6jWBw0hmax6pYUVuUg1sVaDmF Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d2udcfs3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:09:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN511WR070342;
        Thu, 23 Dec 2021 05:08:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3d15pfm5su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:08:59 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BN58xaA091703;
        Thu, 23 Dec 2021 05:08:59 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3d15pfm5se-1;
        Thu, 23 Dec 2021 05:08:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alexey Makhalov <amakhalov@vmware.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Matt Wang <wwentao@vmware.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        srivatsa@csail.mit.edu, shmulik.ladkani@gmail.com,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>, namit@vmware.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: vmw_pvscsi: Set residual data length conditionally
Date:   Thu, 23 Dec 2021 00:08:55 -0500
Message-Id: <164023593112.32381.5515310000460334725.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211220190514.55935-1-amakhalov@vmware.com>
References: <20211220190514.55935-1-amakhalov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: mpK0CVGHk4IfDm7Coed0utMZ_V8_EXMI
X-Proofpoint-GUID: mpK0CVGHk4IfDm7Coed0utMZ_V8_EXMI
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021 11:05:14 -0800, Alexey Makhalov wrote:

> PVSCSI implementation in VMware hypervisor under specific configuration
> ("SCSI Bus Sharing" set to "Physical") returns zero dataLen in completion
> descriptor for read_capacity_16. As a result, the kernel can not detect proper
> disk geometry. It can be recognized by the kernel message:
> [    0.776588] sd 1:0:0:0: [sdb] Sector size 0 reported, assuming 512.
> 
> PVSCSI implementation in QEMU does not set dataLen at all keeping it zeroed,
> leading to the boot hang, as was reported by Shmulik Ladkani.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: vmw_pvscsi: Set residual data length conditionally
      https://git.kernel.org/mkp/scsi/c/142c779d05d1

-- 
Martin K. Petersen	Oracle Linux Engineering
