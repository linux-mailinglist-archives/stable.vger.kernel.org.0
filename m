Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC42232852
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 01:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgG2Xpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 19:45:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgG2Xpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 19:45:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TNcHW0155864;
        Wed, 29 Jul 2020 23:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4vcgnr5eAgcF2LE8tun+6DGHCSCSV2Mi6qpXUFIm8C0=;
 b=e7BeT72iVO1LKsBXMYkADGU6On7OMfkKNWjhqa4Imj1IyHs5IVlMyBvfIvsAoZenolkE
 gDuw4bXUFWU5l9JnGyBLqSYTyd9cqrL50ILgflJatj/nFIKpfxpyXLIBEisfgi3AC7Ih
 cY4+gPitOH/C3Vyb5FWU+dzBZCLYZRSL0isNBx+3SO8uJ6WNpcnu7gUbm2zvvegfKRQG
 RY87UCXXpbJLOIY4ME/5MZzHLQFXMil68G3TNF+Q62C+9IVELgWPfm0/net+0Jl+Jqj1
 Dah6LlMaVJgKh8h2EsgIHTm0BezFyIDK9WHVRpeTN3P9a8qymFqpUMfjdhjSTXuIztVL xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32hu1jrpqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 23:45:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TNcdEG133121;
        Wed, 29 Jul 2020 23:45:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32hu5vsdmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 23:45:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06TNjlNj019183;
        Wed, 29 Jul 2020 23:45:47 GMT
Received: from [192.168.1.106] (/47.220.71.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jul 2020 16:45:47 -0700
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
To:     Mike Snitzer <snitzer@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com> <20200729115119.GB2674635@kroah.com>
 <20200729115557.GA2799681@kroah.com> <20200729141607.GA7215@redhat.com>
From:   John Donnelly <John.P.donnelly@oracle.com>
Message-ID: <851f749a-5c92-dcb1-f8e4-95b4434a1ec4@oracle.com>
Date:   Wed, 29 Jul 2020 18:45:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729141607.GA7215@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290161
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/29/20 9:16 AM, Mike Snitzer wrote:
> On Wed, Jul 29 2020 at  7:55am -0400,
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
>> On Wed, Jul 29, 2020 at 01:51:19PM +0200, Greg KH wrote:
>>> On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
>>>> This mail needs to be saent to stable@vger.kernel.org (now cc'd).
>>>>
>>>> Greg et al: please backport 2df3bae9a6543e90042291707b8db0cbfbae9ee9
>>>
>>> Now backported, thanks.
>>
>> Nope, it broke the build, I need something that actually works :)
>>
> 
> OK, I'll defer to John Donnelly to get back with you (and rest of
> stable@).  He is more invested due to SUSE also having this issue.  I
> can put focus to it if John cannot sort this out.
> 
> Mike
> 


Hi.


Thank you for reaching out.

What specifically is broken? . If it that applying 
2df3bae9a6543e90042291707b8db0cbfbae9ee9 to 4.14.y is failing?

JD.

