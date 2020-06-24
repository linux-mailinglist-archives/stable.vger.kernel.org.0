Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C45206B27
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 06:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgFXEcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 00:32:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54616 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgFXEcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 00:32:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4Mpsv053294;
        Wed, 24 Jun 2020 04:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=suWIxa7byyihzA9tXBmQWH7Fk6N+fzCUrLg8b9n8MYU=;
 b=0Z0UTlzgls7TQZ/MbJn4qrSLmLKP3H3fB3F1mjhdA/ihWnYrB9oXx0JV8KwDNqnmi2Hu
 9WvKWJfP6tLy5Wi+QeRT+jkQ17UxL7tcZhNzzcDucJfGvFkUPJYptT2gz6PEIM5rTsrG
 KVM0eZxHR+PjftowdAacblOhzc5aZc2VHLOomguKLZrkqYZrZsqJtYVNAdZA6/qLiZvb
 9CY3tZb5cCBgce1MRlE1GlJofWIRJy2R+VqDMbd6X9xb/rnxxa/T/3bkVcC4LaOEAZZe
 tf9TwXLAgLPTUQSl3oya4U1Rups9n+nnxZbPo5aHUb9KfUEZih2ceF/YIRGbBFFGo/6w mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31uut5gkuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 04:31:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4OAIj117928;
        Wed, 24 Jun 2020 04:29:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31uur6r6by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 04:29:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05O4TnHX030165;
        Wed, 24 Jun 2020 04:29:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 04:29:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        target-devel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Arun Easi <aeasi@marvell.com>, stable@vger.kernel.org,
        Martin Wilck <mwilck@suse.com>,
        Quinn Tran <qutran@marvell.com>, linux@yadro.com,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v2] scsi: qla2xxx: Keep initiator ports after RSCN
Date:   Wed, 24 Jun 2020 00:29:41 -0400
Message-Id: <159297296072.9797.15955182612058210718.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605144435.27023-1-r.bolshakov@yadro.com>
References: <20200605144435.27023-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006240031
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Jun 2020 17:44:37 +0300, Roman Bolshakov wrote:

> The driver performs SCR (state change registration) in all modes
> including pure target mode.
> 
> For each RSCN, scan_needed flag is set in qla2x00_handle_rscn() for the
> port mentioned in the RSCN and fabric rescan is scheduled. During the
> rescan, GNN_FT handler, qla24xx_async_gnnft_done() deletes session of
> the port that caused the RSCN.
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Keep initiator ports after RSCN
      https://git.kernel.org/mkp/scsi/c/632f24f09d5b

-- 
Martin K. Petersen	Oracle Linux Engineering
