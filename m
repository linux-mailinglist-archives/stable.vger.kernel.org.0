Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03998C3FD2
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 20:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbfJAS1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 14:27:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729444AbfJAS1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 14:27:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91IJA5v137656;
        Tue, 1 Oct 2019 18:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Bp0nYLDxS7dpUSfySpK5uXb+Schf0NiemjtVBNnZ9Xg=;
 b=i7IknPeHLhRI9uKkAxm7LguR7q5cqhYTANRQJ4IULI8cOGFFMlSZQosnwOHd8SHHH1LE
 euvFVY8aZDqVezxFb0tzrG39WRoS4RA1uTAoQxzpVgrdU5szTsCiuSKhgzLAXXhSK1Ij
 FKSpgSW3JyhcfvkPk1DIb3enK1maJx6Qw+HnUMQ5NGSjsQZi1D3iGJRh+yvh0Mr8jAKX
 /aHUeB5XFhlvdveSe7kV9rqP47SaAZ5FekCkVQz9r6/jC61GONxc2l7vttmdMl+M/COU
 bC4I4qajL2u3396sP+O69QWu+PGA5yM/tjePRYr1A/H7SZA1pWDZ/3PGb8NZh3C0CJTP JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rqxmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 18:26:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91IMdZG118288;
        Tue, 1 Oct 2019 18:26:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vbqd1am21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 18:26:56 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x91IQtge000586;
        Tue, 1 Oct 2019 18:26:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 11:26:54 -0700
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] zfcp: fix reaction on bit error theshold notification with adapter close
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <yq1d0fhw2ex.fsf@oracle.com>
        <20191001104949.42810-1-maier@linux.ibm.com>
        <20191001141408.GB3129841@kroah.com>
        <71b8fc68-23a8-a591-1018-f290d6e3312a@linux.ibm.com>
        <20191001154208.GB3523275@kroah.com>
Date:   Tue, 01 Oct 2019 14:26:48 -0400
In-Reply-To: <20191001154208.GB3523275@kroah.com> (Greg KH's message of "Tue,
        1 Oct 2019 17:42:08 +0200")
Message-ID: <yq1tv8stj87.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=755
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=837 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010148
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Greg,

> Ok, then why make this a module option that you will have to support
> for the next 20+ years anyway if you feel this fix is the correct way
> that it should be done instead?

I agree.

Why not just shut FCP down unconditionally on excessive bit errors?
What's the benefit of allowing things to continue? Are you hoping things
will eventually recover in a single-path scenario?

-- 
Martin K. Petersen	Oracle Linux Engineering
