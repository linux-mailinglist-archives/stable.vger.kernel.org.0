Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841CB6B4A8
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 04:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfGQCoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 22:44:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfGQCoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 22:44:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H2dNxx083515;
        Wed, 17 Jul 2019 02:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=GnWP/lxbZcugLrpynIxeIU9XHWghvEFpZx/nqSEoC0A=;
 b=B3PxSh5WBW+95QflXbZxy2ZggMdnx+l1ikjdYyvP41OjN75tLMV45+BaUeF/lRZ9vtwM
 wwBfVk4ME1K2ShtwQw6LmrrD3G5poFMxyBk6mT00W+Pq0L2+kNJBiZ2eig8ahOFBxEMa
 PmRymV8LtTrg5VhS4HOV73rLxBzbuGqSp8VoMRDxHcYnYDIrFRAl/mzbL2D3XV0LSIna
 TzvD6Ydwt7dXiOdFUmkPtY8DMmiHT0/mKWx0o+3dsI3yRryJvqfUBMYSgkxcFcGzLgVb
 QyrBzs+Qt7XwPedee1ka26h3wysFFeiVVHi0tYY9TSgwfeQabmJuiuFZMgUDASQKh08x wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tq6qtqvy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 02:43:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H2giRT128886;
        Wed, 17 Jul 2019 02:43:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tq5bcr5ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 02:43:47 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6H2hjAS030263;
        Wed, 17 Jul 2019 02:43:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 02:43:45 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: Re: [PATCH V2] scsi: fix race on creating sense cache
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190712020819.31935-1-ming.lei@redhat.com>
Date:   Tue, 16 Jul 2019 22:43:42 -0400
In-Reply-To: <20190712020819.31935-1-ming.lei@redhat.com> (Ming Lei's message
        of "Fri, 12 Jul 2019 10:08:19 +0800")
Message-ID: <yq1blxtz8gx.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=844
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907170032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=900 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170031
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Ming,

> When scsi_init_sense_cache(host) is called concurrently from different
> hosts, each code path may see that the cache isn't created, then try
> to create a new one, then the created sense cache may be overrided and
> leaked.
>
> Fixes the issue by moving 'mutex_lock(&scsi_sense_cache_mutex)' before
> scsi_select_sense_cache().

Applied to 5.3/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
