Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA8622F936
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 21:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgG0TjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 15:39:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42462 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgG0Ti6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 15:38:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RJRmYp180965;
        Mon, 27 Jul 2020 19:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=GnGInBejxKJR8KJdylZfInvi9CkV1xbWav4Z516HihQ=;
 b=upscnwtWCsxxYQnNHL3wUGx99lTGZuMNcRNj4crsmOnCplU+pP8LssIwi4AMyc8A6HJT
 N8uvWGeQDhfE5qRtt14xOZaWHWBjappAj4zwBxR0/sh88jRN9vS1+mfyjV/XygBn1L1o
 fS4ghb/FcTbOsbcXENI6LUKqbkYKesGCi0mH8OMqVVpHVcrq86+wjku2rzUri8ExEx83
 sQT8wOyO3dDc+x3HtL2LJl6zEuOn68V+DyDL8/nNKTl6+hNU4fO5zZALd/Ji898G0Y8z
 A0qW4f79QbVzXCvZV7WIfh+zmaicNXo8rDY8RBnOaEyw/CltASNawjhAzMZwFRGywCFT NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32hu1j3gau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Jul 2020 19:38:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RJSk3q084037;
        Mon, 27 Jul 2020 19:38:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32hu5rfyem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 19:38:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06RJcrhX017980;
        Mon, 27 Jul 2020 19:38:53 GMT
Received: from dhcp-10-154-112-121.vpn.oracle.com (/10.154.112.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 12:38:53 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.5\))
Subject: re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20200727191809.GI406581@sasha-vm>
Date:   Mon, 27 Jul 2020 14:38:52 -0500
Cc:     Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <D8DDA535-33D5-4E80-85B3-62A463441B5F@oracle.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com> <20200727191809.GI406581@sasha-vm>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.9.5)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=3 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=3 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270130
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jul 27, 2020, at 2:18 PM, Sasha Levin <sashal@kernel.org> wrote:
> 
> On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
>> This mail needs to be saent to stable@vger.kernel.org (now cc'd).
>> 
>> Greg et al: please backport 2df3bae9a6543e90042291707b8db0cbfbae9ee9
> 
> Hm, what's the issue that this patch addresses? It's not clear from the
> commit message.
> 
> -- 
> Thanks,
> Sasha

HI Sasha ,

In an off-line conversation I had with Mike , he indicated that :


commit 1b17159e52bb31f982f82a6278acd7fab1d3f67b
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Fri Feb 28 18:00:53 2020 -0500

   dm bio record: save/restore bi_end_io and bi_integrity


commit 248aa2645aa7fc9175d1107c2593cc90d4af5a4e
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Fri Feb 28 18:11:53 2020 -0500

   dm integrity: use dm_bio_record and dm_bio_restore


Were picked up  in  "stable" kernels picked up even though 
neither was marked for stable@vger.kernel.org 

Adding this missing  commit :  

 2df3bae9a6543e90042291707b8db0cbfbae9ee9


Completes the series 


Thank you ,


John.


