Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7E64AF2A
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 02:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFSAsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 20:48:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38550 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFSAsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 20:48:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J0hrO9092797;
        Wed, 19 Jun 2019 00:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=skUGrUeWkZHkqno23rVbcBqEa6lARdjMrsLZQMB/CUg=;
 b=hiCOxUvMPKCQ6K+j+WeoF2ddBcYjeHzI3WKHObEemnDthLJSzRil24poxr2i+MhKOreZ
 sKFx0/4MAF1fwrZ28Jad2ecD+55bEHtxURY0K37sw2oaXFeb+BxNAeq/auwhp1dIwL2/
 wXVClwfd0G5ydJgN9ys8EYTv3gAI9OPLvpaVzutGUXveRvFkuZo0nJqlV030xLywiGBm
 IgtLbPBe2XQvrhpb/amp/tkOBL2pUZFz/h3zzW4rEi8WjPUfwTTMfyrqXr16bgqnsGI6
 UQBpE+BC7FbtJX46iTf12BTfd9WfCSbmE0KlaTiWcKSqTEomAp1uECGi9hJKKh5NGDBf 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t78098efh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 00:47:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J0kSbq076303;
        Wed, 19 Jun 2019 00:47:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t77ynhsrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 00:47:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5J0lvAr010725;
        Wed, 19 Jun 2019 00:47:57 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 00:47:56 +0000
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection interrupt
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <cover.1560043151.git.fthain@telegraphics.com.au>
        <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
        <58081aba-4e77-3c8e-847e-0698cf80e426@gmail.com>
        <alpine.LNX.2.21.1906111926330.25@nippy.intranet>
        <9c61076b-81f7-dc7b-0103-1e2e56072453@gmail.com>
Date:   Tue, 18 Jun 2019 20:47:54 -0400
In-Reply-To: <9c61076b-81f7-dc7b-0103-1e2e56072453@gmail.com> (Michael
        Schmitz's message of "Wed, 12 Jun 2019 11:46:59 +1200")
Message-ID: <yq1wohixux1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=713
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=765 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190004
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Michael,

> No matter - patch applied cleanly to what I'm running on my Falcon,
> and works just fine for now (stresstest will take a few hours to
> complete). And that'll thoroughly exercise the reselection code path,
> from what we've seen before.

How did it go?

-- 
Martin K. Petersen	Oracle Linux Engineering
