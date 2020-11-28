Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F462C769A
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 00:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgK1X2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 18:28:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28958 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgK1X2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 18:28:10 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ASN1XG5082691;
        Sat, 28 Nov 2020 18:27:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=bCG8G51Iyk2zmq31048W8a7dnAA9tSi/D4nkld4h+Y4=;
 b=FzrKYdy6CY28etVmfrzYxyhMiNZ6WKS07WBmHEMwBx9126W0fzmGl1bOgN4uQ+DCaLg+
 +Xzy12rw6bRfymYxdnzf3+UwT7dsFooGMEwicM+2fI78fv6rh9V2lFGibGGQIRBZglyR
 NJXdTAWttoo7ufcldHC9YGkjl3w7PQOC7I9qD0K75MTw1Uu/hG8Y887P1+i8OGzzXMT4
 Lw5qtAxjqfeYEvD/nINdfq6adO9dtxHEkdN9OAfg/26bD6p2onpoAju5QW9/m+e8o2s7
 Vi4zDpkw4IpfpbHACRmplTkf2RGrpr08sQm02RHSS3stuRGfJOQxoDY/RQAJ3gG9xnAW /g== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 353xvv1b6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 18:27:24 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ASNROUT012005;
        Sat, 28 Nov 2020 23:27:24 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 353e68d5jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 23:27:24 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ASNRNcr49283466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Nov 2020 23:27:23 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F50F7805E;
        Sat, 28 Nov 2020 23:27:23 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BD1B7805C;
        Sat, 28 Nov 2020 23:27:22 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.201.242])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 28 Nov 2020 23:27:22 +0000 (GMT)
Message-ID: <c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: ses: Fix crash caused by kfree an invalid pointer
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Ding Hui <dinghui@sangfor.com.cn>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Date:   Sat, 28 Nov 2020 15:27:21 -0800
In-Reply-To: <20201128122302.9490-1-dinghui@sangfor.com.cn>
References: <20201128122302.9490-1-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-28_17:2020-11-26,2020-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 bulkscore=0 suspectscore=4
 priorityscore=1501 mlxscore=0 malwarescore=0 phishscore=0 clxscore=1011
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011280144
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2020-11-28 at 20:23 +0800, Ding Hui wrote:
> We can get a crash when disconnecting the iSCSI session,
> the call trace like this:
> 
>   [ffff00002a00fb70] kfree at ffff00000830e224
>   [ffff00002a00fba0] ses_intf_remove at ffff000001f200e4
>   [ffff00002a00fbd0] device_del at ffff0000086b6a98
>   [ffff00002a00fc50] device_unregister at ffff0000086b6d58
>   [ffff00002a00fc70] __scsi_remove_device at ffff00000870608c
>   [ffff00002a00fca0] scsi_remove_device at ffff000008706134
>   [ffff00002a00fcc0] __scsi_remove_target at ffff0000087062e4
>   [ffff00002a00fd10] scsi_remove_target at ffff0000087064c0
>   [ffff00002a00fd70] __iscsi_unbind_session at ffff000001c872c4
>   [ffff00002a00fdb0] process_one_work at ffff00000810f35c
>   [ffff00002a00fe00] worker_thread at ffff00000810f648
>   [ffff00002a00fe70] kthread at ffff000008116e98
> 
> In ses_intf_add, components count could be 0, and kcalloc 0 size
> scomp,
> but not saved in edev->component[i].scratch
> 
> In this situation, edev->component[0].scratch is an invalid pointer,
> when kfree it in ses_intf_remove_enclosure, a crash like above would
> happen
> The call trace also could be other random cases when kfree cannot
> catch
> the invalid pointer
> 
> We should not use edev->component[] array when the components count
> is 0
> We also need check index when use edev->component[] array in
> ses_enclosure_data_process
> 
> Tested-by: Zeng Zhicong <timmyzeng@163.com>
> Cc: stable <stable@vger.kernel.org> # 2.6.25+
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>

This doesn't really look to be the right thing to do: an enclosure
which has no component can't usefully be controlled by the driver since
there's nothing for it to do, so what we should do in this situation is
refuse to attach like the proposed patch below.

It does seem a bit odd that someone would build an enclosure that
doesn't enclose anything, so would you mind running

sg_ses -e 

on it and reporting back what it shows?  It's possible there's another
type that the enclosure device should be tracking.

Regards,

James

---8>8>8><8<8<8--------
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: ses: don't attach if enclosure has no components

An enclosure with no components can't usefully be operated by the
driver (since effectively it has nothing to manage), so report the
problem and don't attach.  Not attaching also fixes an oops which
could occur if the driver tries to manage a zero component enclosure.

Reported-by: Ding Hui <dinghui@sangfor.com.cn>
Cc: stable@vger.kernel.org
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ses.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..9624298b9c89 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -690,6 +690,11 @@ static int ses_intf_add(struct device *cdev,
 		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components += type_ptr[1];
 	}
+	if (components == 0) {
+		sdev_printk(KERN_ERR, sdev, "enclosure has no enumerated components\n");
+		goto err_free;
+	}
+
 	ses_dev->page1 = buf;
 	ses_dev->page1_len = len;
 	buf = NULL;
-- 
2.26.2



