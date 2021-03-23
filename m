Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9293460AA
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 14:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhCWN6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 09:58:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47268 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbhCWN6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 09:58:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NDso27187340;
        Tue, 23 Mar 2021 13:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=o7vohucRxPAL5WR5AcjogXr4TVQPKWtRe8usdnwS8Ig=;
 b=b8/Eg+rCAQqWEaLh26FgnzZpREF/UeQFyj2FPhcxQQ+I5rgR1PPDOD+9MxhWwM9Hx1Jh
 xOe8+6Df812xwazCZjB8C+bxz21K2toVSRM7zYod9n8vUSHtAl5eB+ZsVat9MZ1oRdP9
 Ckh5YU1fLVdcyJF/uJviapqZ5owtaS+DUdBnBteFmWcWhQkY4WdtjXnNwwUTpvRx4Jnu
 0PLk4w2SVL7meltIcPdyaBZknW4RNICWvB8W2MhePib126xDTTYcKUeGz3X0/VplkI7H
 IQxfLpZi2HNPlM3fUYrQeTUxIuYiKkVRoCMPZXIsPDhueZ70Ewr1oZELI6SK4FeprCHz dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37d6jbf7aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 13:58:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NDu9rH191662;
        Tue, 23 Mar 2021 13:58:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 37dttryccj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 13:58:20 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12NDwJ42024102;
        Tue, 23 Mar 2021 13:58:19 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Mar 2021 13:58:18 +0000
Date:   Tue, 23 Mar 2021 16:58:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Atul Gopinathan <atulgopinathan@gmail.com>
Cc:     gregkh@linuxfoundation.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] staging: rtl8192e: Fix incorrect source in
 memcpy()
Message-ID: <20210323135811.GI1717@kadam>
References: <20210323113413.29179-1-atulgopinathan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323113413.29179-1-atulgopinathan@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230103
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

This is very clever detective work.  How did you spot the bug?

regards,
dan carpenter

