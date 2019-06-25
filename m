Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C655B9A
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 00:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfFYWto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 18:49:44 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:45492 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbfFYWtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 18:49:43 -0400
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.27/8.16.0.27) with SMTP id x5PMmqQh021033;
        Tue, 25 Jun 2019 23:49:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=z8N8vx0sBhB72JI5VPkatepSaImzVZpZ4fIHLDa0hp0=;
 b=dwr9A21Tm+5EiADaU/EvcwcaZn1iyA7JNdvkyhUHs0kOvXopO+HS+E+iRnDRG6lNOcwq
 sJ/fQy/hUWpVWBWj6OR64yG3RRkAqxcpg1FRFjlzpHRO2KHYrNDZekPQbpoKZwCaA/QA
 ct7K1T7Fs3hw72e4NYuD9QBYwzD8duXPzVFh3XVPBNxQxCnNXvAXOFBH9Ni8tB+gnmgq
 R6dB240+oK/0W5CqJumPF1fHNJgBlhg0Cm/CUO/Ra8rhsr2jsR+/p3DGdWAz3NtmNQFw
 sS4b4HOh1+z0XKAPA5HSrsdadTNwaGyx4qoUbdZ1fXH58KULOFihTUUjbd7eJmH1MG5f nQ== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 2tb4s8vx58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 23:49:39 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x5PMlgSM000359;
        Tue, 25 Jun 2019 18:49:35 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2t9fnwncw3-1;
        Tue, 25 Jun 2019 18:49:35 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 658DC206EE;
        Tue, 25 Jun 2019 22:49:34 +0000 (GMT)
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
 <20190625202626.GD7898@sasha-vm>
 <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
 <20190625221821.GA17994@kroah.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <7282e627-edd6-51cb-ad9d-d9f34b2e9628@akamai.com>
Date:   Tue, 25 Jun 2019 15:49:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625221821.GA17994@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250183
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250183
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/25/19 3:18 PM, Greg KH wrote:
> On Tue, Jun 25, 2019 at 01:29:35PM -0700, Josh Hunt wrote:
>> On 6/25/19 1:26 PM, Sasha Levin wrote:
>>> On Tue, Jun 25, 2019 at 01:19:37PM -0400, Josh Hunt wrote:
>>>> Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:
>>>
>>> You probably meant b6653b3629e5b88202be3c9abc44713973f5c4b4 here.
>>
>> I wasn't sure if I should reference the upstream commit or stable commit.
> 
> The upstream commit please.

Thanks. I'll fix for next version.

> 
>> dad3a9314 is the version of the commit from linux-4.14.y. There may be a
>> similar issue with the Fixes tag below since that also references the 4.14
>> vers of the change.
>>
>>>
>>>> tcp_fragment() might be called for skbs in the write queue.
>>>>
>>>> Memory limits might have been exceeded because tcp_sendmsg() only
>>>> checks limits at full skb (64KB) boundaries.
>>>>
>>>> Therefore, we need to make sure tcp_fragment() wont punish applications
>>>> that might have setup very low SO_SNDBUF values.
>>>>
>>>> Backport notes:
>>>> Initial version used tcp_queue type which is not present in older
>>>> kernels,
>>>> so added a new arg to tcp_fragment() to determine whether this is a
>>>> retransmit or not.
>>>>
>>>> Fixes: 9daf226ff926 ("tcp: tcp_fragment() should apply sane memory
>>>> limits")
>>>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>>>> Reviewed-by: Jason Baron <jbaron@akamai.com>
>>>> ---
>>>>
>>>> Eric/Greg - This applies on top of v4.14.130. I did not see anything come
>>>> through for the older (<4.19) stable kernels yet. Without this change
>>>> Christoph Paasch's packetrill script (https://lore.kernel.org/netdev/CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com/)
>>>>
>>>> will fail on 4.14 stable kernels, but passes with this change.
>>>
>>> Eric, it would be great if you could Ack this, it's very different from
>>> your original patch.
>>
>> Yes, that would be great.
> 
> I would prefer if this looks a bit more like the upstream fix, perhaps a
> backport of the function that added the "direction" of the packet first,
> and then Eric's patch?  As it is, this patch adds a different parameter
> to the function than what is in Linus's tree, and I bet will cause
> problems at some later point in time.

The commit which introduced the fn arguments is part of a much larger 
change that created a separate rb-tree for the retransmit queue:

commit 75c119afe14f74b4dd967d75ed9f57ab6c0ef045
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Oct 5 22:21:27 2017 -0700

     tcp: implement rb-tree based retransmit queue

I can backport the portion of this change which basically does this:

+enum tcp_queue {
+       TCP_FRAG_IN_WRITE_QUEUE,
+       TCP_FRAG_IN_RTX_QUEUE,
+};
+int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
+                struct sk_buff *skb, u32 len,
+                unsigned int mss_now, gfp_t gfp);

and the corresponding call-sites of tcp_fragment(). If we do that then 
Eric's fix (b6653b3629e5b88202be3c9abc44713973f5c4b4) should apply 
cleanly on top of linux-4.14.y. I'm happy to do that if you'd rather go 
that route. If you want the full rb-tree change into 4.14 then I would 
defer that to Eric, but would argue that IMHO is probably too invasive 
of a change for a LTS kernel.

Thanks
Josh
