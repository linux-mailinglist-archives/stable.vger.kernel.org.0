Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3895F26B268
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 00:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727583AbgIOWrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 18:47:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgIOWrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 18:47:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FMigO7130557;
        Tue, 15 Sep 2020 22:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=/+BTHMxLvTnC81EoER+MZfj/9snk4062twa1yC4bS60=;
 b=T1D20BafueEydg7zDMpycuaRV7g4AU6UagPQh9E9/TvnrhBMoVpyhCVREOarnsxYxCBm
 knhAF1k1RZJ6KOp6EWljJerKU7PBWt+L+mmH6RSbRYMDMmv41xmaCTQHTacWjYiQTdAf
 kVy3gHxEE+K00wKrlhykNkGE/fWyElITuWgJpDlCgAE5M+5jMFg7oOvwUfam234pZWRS
 WcslWSI8mkhmJC38PcymcrDHiM7Z2DunoJaZL8CXNRN9DbWWyL57df+Z282vAAsOYt6N
 QQe2aebPpK4M6bXqHTAmIZEPTwPUWVdz/qp7pWEYChkF2BZ1F6b4tfqKPx41hMaCzumP fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrqyxvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 22:47:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FMjRne031616;
        Tue, 15 Sep 2020 22:47:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h8868ea2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 22:47:00 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FMkwFI019050;
        Tue, 15 Sep 2020 22:46:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 22:46:58 +0000
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix initial FLOGI failure due to BBSCN not supported
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7ry3bgo.fsf@ca-mkp.ca.oracle.com>
References: <20200911200147.110826-1-james.smart@broadcom.com>
Date:   Tue, 15 Sep 2020 18:46:56 -0400
In-Reply-To: <20200911200147.110826-1-james.smart@broadcom.com> (James Smart's
        message of "Fri, 11 Sep 2020 13:01:47 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=965
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=980 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150178
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


James,

> Initial FLOGIs are failing with the following message:
>  lpfc 0000:13:00.1: 1:(0):0820 FLOGI Failed (x300). BBCredit Not Supported

The Fixes: SHA was not correct. Fixed and applied to 5.9/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
