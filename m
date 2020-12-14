Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B81A2D9704
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 12:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407709AbgLNLIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 06:08:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54266 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407306AbgLNLIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 06:08:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEAsJWA083722;
        Mon, 14 Dec 2020 11:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HHxooGdiL/XI/7m8xwtF2YV8gMtwgfBZLELsSxs0NrE=;
 b=UWMixQbOq5orbLv7Ws22731ZB5yMPFL0K2JfQdwsMJR1xzDblAbqXUMDAe3ORQyBod0Q
 feMt1/896z9Tox1zfWoE40pJELAWqWkQeandroH3KY0WWHDq8opwZZbjIa+BMiGr3Ly+
 R25GkwGmQLbQ3KVPG0uFwxpWI63I7h6XrW58F4TlK7Sm44oTt2/Qg5mBI0LbLLNO/5z8
 mU3X5ZzZb0hZiKP8vnBcigluWr3uZFpOp0rOSKH4+JmAYouB+g/ppkxrQlZ6LE8qs2gF
 j/rR0V9y1xyjWJveCYLaO8U9wbp8moE8iPvogNs5CZbmWtWLLFK8rH9dTf4Ng9PCHpc2 Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35ckcb4ryg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 11:07:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEAo2QM034891;
        Mon, 14 Dec 2020 11:07:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35d7subn0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 11:07:23 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEB7KoK023846;
        Mon, 14 Dec 2020 11:07:20 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 03:07:20 -0800
Date:   Mon, 14 Dec 2020 14:07:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrea Parri <parri.andrea@gmail.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        devel@linuxdriverproject.org,
        Saruhan Karademir <skarade@microsoft.com>
Subject: Re: [PATCH AUTOSEL 5.9 15/23] scsi: storvsc: Validate length of
 incoming packet in storvsc_on_channel_callback()
Message-ID: <20201214110711.GB2831@kadam>
References: <20201212160804.2334982-1-sashal@kernel.org>
 <20201212160804.2334982-15-sashal@kernel.org>
 <20201212180901.GA19225@andrea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212180901.GA19225@andrea>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1031
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140078
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 12, 2020 at 07:09:01PM +0100, Andrea Parri wrote:
> Hi Sasha,
> 
> On Sat, Dec 12, 2020 at 11:07:56AM -0500, Sasha Levin wrote:
> > From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> > 
> > [ Upstream commit 3b8c72d076c42bf27284cda7b2b2b522810686f8 ]
> 
> FYI, we found that this commit introduced a regression and posted a
> revert:
> 
>   https://lkml.kernel.org/r/20201211131404.21359-1-parri.andrea@gmail.com
> 
> Same comment for the AUTOSEL 5.4, 4.19 and 4.14 you've just posted.
> 

Konstantin, is there anyway we could make searching lore.kernel.org
search all the mailing lists?  Right now we can only search one mailing
list at a time.

Part of the stable process should be to search lore.kernel.org for
Fixes: 3b8c72d076c4 ("scsi: storvsc: Validate length of... ")

But, unfortunately, git revert sets people up for failure by not
including a fixes tag so we'd also have to search for:
This reverts commit 3b8c72d076c42bf27284cda7b2b2b522810686f8.

regards,
dan carpenter
