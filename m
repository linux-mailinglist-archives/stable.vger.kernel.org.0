Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0598A247C5D
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 05:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgHRDBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 23:01:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51028 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHRDBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 23:01:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I2qLB3112294;
        Tue, 18 Aug 2020 03:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=fYy/b+dVGKsTMt/VZa3tnk1hVc/HoA/MK3e+u3tVj+8=;
 b=ORCySYGc6efoM38ZKhPyUC7KvEbhObVu2SRdzPlEHrb2RXiZM0UrKkZkxt8oeCXDYbps
 9PAfX1z6Izs167hzbCbkBWKWjp64bJEovUMHQC54anQgVr6SNtekC/1/P5lnWFkc/x6z
 y4rBrwtK12+zb08Q+f/CFPCQIS35yAsURsritGs5pf4jq3ys5U0k633nSfp65pW3ZMGQ
 hQiHDRpHBbiGz/Ey5kr9wFCI+RW9YEaZP/mvLOJVQA3I0SVZaIMlowqaGnpflh/HJWgp
 /Hpxvl6wN/j/Y8EaJMwhARj+SxSYLD++PQbPFrlMl5+ZB54shSqUpfS7aJFiDfF8etOu 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74r26am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:00:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I2wsrW114873;
        Tue, 18 Aug 2020 03:00:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32xsmwnwrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:00:56 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07I30oHt014497;
        Tue, 18 Aug 2020 03:00:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:00:49 -0700
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.com>, Xiao Ni <xni@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND] block: loop: set discard granularity and
 alignment for block device backed loop
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kp0d5fh.fsf@ca-mkp.ca.oracle.com>
References: <20200817100130.2496059-1-ming.lei@redhat.com>
        <20200817101718.GC25336@lst.de>
Date:   Mon, 17 Aug 2020 23:00:46 -0400
In-Reply-To: <20200817101718.GC25336@lst.de> (Christoph Hellwig's message of
        "Mon, 17 Aug 2020 12:17:18 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=901 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=902
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180020
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Christoph,

> If you have a few spare cycles, can you kill QUEUE_FLAG_DISCARD and
> just key off discard support based on checking discard_granularity to
> avoid problems like this in the future?

Yes, that would be great!

-- 
Martin K. Petersen	Oracle Linux Engineering
