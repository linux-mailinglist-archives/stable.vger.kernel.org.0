Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C181B558D7
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 22:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFYU3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 16:29:42 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:27746 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbfFYU3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 16:29:42 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PKS3PU028698;
        Tue, 25 Jun 2019 21:29:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=3J7dmCPJwoRIGxCX8vSZhGrgasZoyPObj+VP/0bF4NM=;
 b=G7mYc4IEtPNPZY9LHxu0yGMKp8cv42vS8BobvmYPHF3OV6jEQqvimM1Nk/8WRbOXjA2u
 H8cmMswwxCD98K4+i/ihC0TJvvSSqqU7N5dbigbYhGjn8gIkVt9CUG7zFWJXlIahEeAk
 uOclzcxMkPRuY3QFFlYrNPF8B1QqYFO3AYUCc8jtbGqQYZd7F9IgSSOmYhZBVp2ONHDP
 dXBbT1a6QRqSTyo+8K4Qy8RVGv5lcoThcriQaXO3Fxxp9iUplV/+Ks7AwNr0T+x5+I4P
 DpBjxotsOTW5uZ3Uh++d2TmSHkt6MeixaVTO7SQdXh89s1PxVGLj8GpCidG8Ixn1YFIZ XA== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2tba50ba6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 21:29:39 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x5PKHH4J031721;
        Tue, 25 Jun 2019 16:29:38 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2t9fnwm206-1;
        Tue, 25 Jun 2019 16:29:38 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 41AD71FC74;
        Tue, 25 Jun 2019 20:29:36 +0000 (GMT)
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
 <20190625202626.GD7898@sasha-vm>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
Date:   Tue, 25 Jun 2019 13:29:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625202626.GD7898@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250152
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250154
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/25/19 1:26 PM, Sasha Levin wrote:
> On Tue, Jun 25, 2019 at 01:19:37PM -0400, Josh Hunt wrote:
>> Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:
> 
> You probably meant b6653b3629e5b88202be3c9abc44713973f5c4b4 here.

I wasn't sure if I should reference the upstream commit or stable 
commit. dad3a9314 is the version of the commit from linux-4.14.y. There 
may be a similar issue with the Fixes tag below since that also 
references the 4.14 vers of the change.

> 
>> tcp_fragment() might be called for skbs in the write queue.
>>
>> Memory limits might have been exceeded because tcp_sendmsg() only
>> checks limits at full skb (64KB) boundaries.
>>
>> Therefore, we need to make sure tcp_fragment() wont punish applications
>> that might have setup very low SO_SNDBUF values.
>>
>> Backport notes:
>> Initial version used tcp_queue type which is not present in older 
>> kernels,
>> so added a new arg to tcp_fragment() to determine whether this is a
>> retransmit or not.
>>
>> Fixes: 9daf226ff926 ("tcp: tcp_fragment() should apply sane memory 
>> limits")
>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>> Reviewed-by: Jason Baron <jbaron@akamai.com>
>> ---
>>
>> Eric/Greg - This applies on top of v4.14.130. I did not see anything come
>> through for the older (<4.19) stable kernels yet. Without this change
>> Christoph Paasch's packetrill script 
>> (https://lore.kernel.org/netdev/CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com/) 
>>
>> will fail on 4.14 stable kernels, but passes with this change.
> 
> Eric, it would be great if you could Ack this, it's very different from
> your original patch.

Yes, that would be great.

Josh

> 
> -- 
> Thanks,
> Sasha
