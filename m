Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0B435902
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 05:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJUDm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 23:42:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27770 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231327AbhJUDmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 23:42:39 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2ffra029728;
        Thu, 21 Oct 2021 03:40:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=2BhrUzawBVGxRPs51RCpkAkG8Dce5F1o5cEgs3Na3vU=;
 b=ZkzJQCD+Gm6hxIfhh1lgW/Yi+iEaPNaFyUGEyAuSV955zSnlUZ+y1TC9eSPNr3hRxJJb
 ZiMhNlSKWiPWb3jwwJNFDhdoWfB6Yl+yiV8BEjsdyz713cQ5Xib+jMLQ98daaqriOG7a
 PwiYzR0EqvSvTWLbYViQHznzdKy+rM3lTcloi27YG3rNCgDl6jCJiy/7jAsodGF5pvo4
 cwzP7e4iyxUhjatCjwcWXjycpUtz0DqDTZLR+7rL5/jubfDfOQkc2Rlub2DSkD1GE98B
 pFYvGsBIdIEEKoJCs6/x6aa75b+l+KMtzkNaeptqj/bHS1kHHtUX68XDl4Y9Lq9tVAft wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3wn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:40:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3Lbms083729;
        Thu, 21 Oct 2021 03:40:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3br8gv83kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:40:20 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3eJZ9135272;
        Thu, 21 Oct 2021 03:40:19 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3br8gv83k1-1;
        Thu, 21 Oct 2021 03:40:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     tyreld@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, stable@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ibmvfc: Fixup duplicate response detection
Date:   Wed, 20 Oct 2021 23:40:17 -0400
Message-Id: <163478760938.6923.3676022721184133016.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211019152129.16558-1-brking@linux.vnet.ibm.com>
References: <20211019152129.16558-1-brking@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: BmCz4eKJBPLl4asColEiKQ7x0YdvUMjv
X-Proofpoint-GUID: BmCz4eKJBPLl4asColEiKQ7x0YdvUMjv
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Oct 2021 10:21:29 -0500, Brian King wrote:

> Commit a264cf5e81c7 ("scsi: ibmvfc: Fix command state accounting and stale response detection")
> introduced a regression in detecting duplicate responses. This was observed
> in test where a command was sent to the VIOS and completed before
> ibmvfc_send_event set the active flag to 1, which resulted in the
> atomic_dec_if_positive call in ibmvfc_handle_crq thinking this was a
> duplicate response, which resulted in scsi_done not getting called, so we
> then hit a scsi command timeout for this command once the timeout expires.
> This simply ensures the active flag gets set prior to making the hcall to
> send the command to the VIOS, in order to close this window.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] ibmvfc: Fixup duplicate response detection
      https://git.kernel.org/mkp/scsi/c/e20f80b9b163

-- 
Martin K. Petersen	Oracle Linux Engineering
