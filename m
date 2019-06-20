Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4AA4DB4D
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 22:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfFTUfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 16:35:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFTUfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 16:35:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KKYe7u053632;
        Thu, 20 Jun 2019 20:35:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=pxneq9uTqALGSb+O9I6ZQbEGKX8uDk2Bht9a+At6BxU=;
 b=R0TzZBpNF77G0fhbpDyOk0a2DwSn/aiU6rWdW60eNDAoSn8IEqDle0ssM0lRupwiwnEd
 v980Yont1EVQuc4JvWV6r1Cu19IkrgdLRRC6dwwPtPdEjA8zxuUViQUO2UDpStStITkf
 c8N2pvN5nHKjx/9ZPJe/dMKZ8pydhJ4Bb5a7oZxR0mz/5h0AWsZq7ZiZ3UeWmMn3+64+
 RliVNH52n+oaoEVBHZgYhAJTq6tz6Mg1ZeURgtgv0Vj2sZUFsEkhmqqwY5Cidx4M6TbF
 B6dnx6xXNYhSd9W8mFeXFno3QBXj7A+ZN0Y+8ZLmtwPT0eL1gR1NN/8vaB98HTxwq9Nj Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t7809k5jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 20:35:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KKZCcp076785;
        Thu, 20 Jun 2019 20:35:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2t77yntwgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 20:35:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KKZ7qf026028;
        Thu, 20 Jun 2019 20:35:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 13:35:07 -0700
To:     Jan Kara <jack@suse.cz>
Cc:     Jim Gill <jgill@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190619070541.30070-1-jack@suse.cz>
Date:   Thu, 20 Jun 2019 16:35:05 -0400
In-Reply-To: <20190619070541.30070-1-jack@suse.cz> (Jan Kara's message of
        "Wed, 19 Jun 2019 09:05:41 +0200")
Message-ID: <yq1zhmcq9l2.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=759
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=828 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200147
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Jan,

> Once we unlock adapter->hw_lock in pvscsi_queue_lck() nothing prevents
> just queued scsi_cmnd from completing and freeing the request. Thus
> cmd->cmnd[0] dereference can dereference already freed request leading
> to kernel crashes or other issues (which one of our customers
> observed). Store cmd->cmnd[0] in a local variable before unlocking
> adapter->hw_lock to fix the issue.

Applied to 5.2/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
