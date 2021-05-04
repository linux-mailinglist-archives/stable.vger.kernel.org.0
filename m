Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B191372FE9
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 20:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhEDSro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 14:47:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53288 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhEDSrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 14:47:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 144IU48j062279;
        Tue, 4 May 2021 18:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=jITkOCAYtWc/1On6+2heG+5B/3MUI5lKIGqkE3uQvrk=;
 b=UG0bOy5WCE4JDtF5rWr/qa9d2HiFJ+jE9pEmssfoVxTivFcbYAMjPNaOp4AzJcKpCCTH
 pnF3mZFV0HPCblKEpbkGtHh6DWzbRJVgo9ZmkeJT7lKZ9EVgfZLrR1lQW2FyQPN7WBB3
 HAyP1798f5lzymrUK7WO7HlgD5RKjWVmVRVu4w6Gts0TZ62XAfaF8cJlVDyAssXcUg4a
 PYBL2kIjhfvdnm1dmtcVLLflPmTwDbAettS3YY2iUkNNTX6FJD1IJF0Anj11pKELddsG
 22gh4Eat3HBpkcXW7c3ZU0/IdIY/zTRngRh2uEyQxOBfjGHXEtA5Ih59tg6r8dGIkRPX 5Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 388vgbr5m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 18:46:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 144IVOmW055213;
        Tue, 4 May 2021 18:46:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 388w1edaaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 18:46:44 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 144Iivbd126698;
        Tue, 4 May 2021 18:46:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 388w1eda9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 18:46:43 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 144IkfrS011699;
        Tue, 4 May 2021 18:46:41 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 May 2021 18:46:41 +0000
Date:   Tue, 4 May 2021 21:46:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     stable@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: need to back port ("scsi: ufs: Unlock on a couple error paths")
Message-ID: <20210504184635.GT21598@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: yF2f6ZUuLm2_mNtEYfdLN_iS12GE6Jmi
X-Proofpoint-ORIG-GUID: yF2f6ZUuLm2_mNtEYfdLN_iS12GE6Jmi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040122
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I ran Smatch on 5.4.116 and I found that we were missing commit
bb14dd1564c9 ("scsi: ufs: Unlock on a couple error paths").

The problem was caused because somehow my Fixes tag did not match the
upstream commit that stable used.  I have both hashes in my git tree and
the patches are identical except for the hash.  I don't know git well
enough to say what went wrong.  I don't think the SCSI tree rebases?

My fixes tag:
Fixes: a276c19e3e98 ("scsi: ufs: Avoid busy-waiting by eliminating tag conflicts")
       ^^^^^^^^^^^^

Stable hash:
commit a8d2d45c70c7391386baf7863674f156da56a3d5
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Mon Dec 9 10:13:08 2019 -0800

    scsi: ufs: Avoid busy-waiting by eliminating tag conflicts

    [ Upstream commit 7252a3603015f1fd04363956f4b72a537c9f9c42 ]
                      ^^^^^^^^^^^^
regards,
dan carpenter
