Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD1429CD29
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 02:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgJ1Big (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 21:38:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833049AbgJ0Xmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 19:42:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RNdU5J033454;
        Tue, 27 Oct 2020 23:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : to : from :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=rIHsVK2Oy3+HUfVyT3NQyvNdOPBUsBa0ax0zbtnybL8=;
 b=TFJiBvZigbKvtRAHuHGPt5V+TU6nGt0GZp3Sop1rZ0GHYmdfX+RfJQqqfTMMTKr5i3wF
 aXFcBQHgZiceXh+8Ymo/0jftwgoB7tho88tuBm3IQxJVFvxAnoXncNRmOapOeeT1RzDj
 3B+ITf3WBfLkwSppYSquv4Z7KHL9YUL5UCv6ksthqSQYSkhDv9JAphHYFVY7J9Vm7hGk
 OjgZ13jz6+vhpVHi27rmPm+KBX3sR0Nh+eu+Mlg5Sbe4tbqZr1PRVQXCwj907q1B5yo/
 dROe/LT7bKDY1Gw+IY40ORaEAS5/GE7MFGCf473PrwLTnszfKybvsRJ/9cu999tXURyd yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm42cea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 23:42:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RNeIir070761;
        Tue, 27 Oct 2020 23:42:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1rb3g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 23:42:30 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RNgTcG014364;
        Tue, 27 Oct 2020 23:42:29 GMT
Received: from [10.175.221.126] (/10.175.221.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 16:42:28 -0700
Cc:     linux-nfs@vger.kernel.org, NeilBrown <neilb@suse.com>
To:     stable@vger.kernel.org
From:   Calum Mackay <calum.mackay@oracle.com>
Subject: please cherry-pick for stable --- fd01b2597941 SUNRPC: ECONNREFUSED
 should cause a rebind.
Organization: Oracle
Message-ID: <380083cd-f5f5-73fa-33ff-c5dde2e7bd02@oracle.com>
Date:   Tue, 27 Oct 2020 23:42:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=13 malwarescore=0 mlxlogscore=965 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=13 clxscore=1011 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270135
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This commit:

	fd01b2597941 SUNRPC: ECONNREFUSED should cause a rebind.

(originally applied to v4.14-rc1) didn't appear to get a stable cc, 
perhaps because it wasn't considered a common problem at the time.

A patch I'm shortly about to post, cc stable, depends on the above, so 
could it please be cherry-picked for stable?

It applies cleanly to both v4.4.240 & v4.9.240

thank you,
calum.

