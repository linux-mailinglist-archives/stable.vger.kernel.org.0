Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328714B03F
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 04:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfFSCvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 22:51:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfFSCvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 22:51:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J2nJkC075342;
        Wed, 19 Jun 2019 02:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=L4phCbahTYJumOSspv1r7NxClQaWWMs5xDPyNWp/G6w=;
 b=MPOSUmu1KK3+g0SG5BW3UbjLkcgMh+DJAjWdLQr4S+X8tqs7Z4MHZ/pF3QKiaYkFzt0z
 QCV5PonpxjKUVzq/hfDJH88s2MMcqtJZJtwTGfjWW/uXVH5D70p57XcJ+ApxAo/qEDkw
 1I5A7MuLqhqH005HclYlygoSEC0h6iNVp6SHvs/2MIErnfUuKL3+3C4r0qSYdzTcmSp2
 9DUjDnGL/jzTj0DZfnFfjTjfWJidQdYVXzYR3jvBDVlk+WOms4Co3g9hV+jGqBV+iaOR
 ulTgFCUQ2doDwuASSgwH1oIoIVkxT58Ywm943sdfN3ytBNGN2nusbY848Rd9ZUo3rBEe /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t78098qh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 02:51:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J2p9nh163405;
        Wed, 19 Jun 2019 02:51:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2t77ymtuuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 02:51:18 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5J2pFbs004087;
        Wed, 19 Jun 2019 02:51:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 19:51:14 -0700
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <evgreen@chromium.org>, <beanhuo@micron.com>,
        <marc.w.gonzalez@free.fr>, <ygardi@codeaurora.org>,
        <subhashj@codeaurora.org>, <sthumma@codeaurora.org>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: Avoid runtime suspend possibly being blocked forever
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1560352745-24681-1-git-send-email-stanley.chu@mediatek.com>
Date:   Tue, 18 Jun 2019 22:51:10 -0400
In-Reply-To: <1560352745-24681-1-git-send-email-stanley.chu@mediatek.com>
        (Stanley Chu's message of "Wed, 12 Jun 2019 23:19:05 +0800")
Message-ID: <yq18stywan5.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=974
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190021
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Stanley,

> UFS runtime suspend can be triggered after pm_runtime_enable()
> is invoked in ufshcd_pltfrm_init(). However if the first runtime
> suspend is triggered before binding ufs_hba structure to ufs
> device structure via platform_set_drvdata(), then UFS runtime
> suspend will be no longer triggered in the future because its
> dev->power.runtime_error was set in the first triggering and does
> not have any chance to be cleared.

Applied to 5.2/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
