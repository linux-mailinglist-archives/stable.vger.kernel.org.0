Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A504B353796
	for <lists+stable@lfdr.de>; Sun,  4 Apr 2021 11:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhDDJOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Apr 2021 05:14:07 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8663 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhDDJOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Apr 2021 05:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617527643; x=1649063643;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=zRncd8ZAL+WB375O79kQJ8WBUO5Ls3dgruGjfAw+nwo=;
  b=GX+yKWiAujWPdbhnpFZSFkm3Z4R99tosDjRBc/m1Y/7gTCUQB+jIFWnA
   RRADWvBhzxI6Yy4spKgJJN6asgNbev54/7WjwYQhUoQ2N4ygMVZLJTDN3
   u0boIxYoN4W6mXnRx2+NS+YmEaOYJmHDp9ogWagdyx4Or4p1RcoFSDWM6
   g=;
X-IronPort-AV: E=Sophos;i="5.81,304,1610409600"; 
   d="scan'208";a="103343483"
Subject: Re: [PATCH 1/2] bpf: fix userspace access for bpf_probe_read{, str}()
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 04 Apr 2021 09:13:56 +0000
Received: from EX13D01EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id D17C7A2162;
        Sun,  4 Apr 2021 09:13:54 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.161.253) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 4 Apr 2021 09:13:51 +0000
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com> <YGNeIhMNjQ0RGUGr@sashalap>
 <b0a5f24a-4e25-53f2-f5fb-e09ac89dc869@amazon.com>
 <YGg7zApJnXCFNgL4@kroah.com>
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
Message-ID: <655b6f67-787f-80dd-975e-3d1ab87b0c49@amazon.com>
Date:   Sun, 4 Apr 2021 12:13:46 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGg7zApJnXCFNgL4@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D46UWC003.ant.amazon.com (10.43.162.119) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 03/04/2021 12:56, Greg KH wrote:
> On Wed, Mar 31, 2021 at 09:37:28PM +0300, Zidenberg, Tsahi wrote:
>> On 30/03/2021 20:21, Sasha Levin wrote:
>>
>>> What stops us from taking that API back to 5.4? I took a look at the
>>> dependencies and they don't look too scary.
>>>
>>> Can we try that route instead? We really don't want to diverge from
>>> upstream that much.
>>>
>> probe_read_{user,kernel}* functions themselves seem simple enough.
>> Importing them in a forward-compliant way to 5.4 would require either
>> adding an unused entry in bpf.h's __BPF_FUNC_MAPPER or also pulling
>> skb_output bpf helper functions into 5.4. To me, it seems like too
>> much of a UAPI change to go into a stable release.
> Why is anything changing in the user api here?  The user api should not
> be changing in incompatible ways, otherwise you would not be able to
> upgrade to new kernels without breaking things.
>
>> Another option would be to import more code to make it somewhat closer
>> to upstream implementation without changing UAPI. As in v5.8, I could
>> internally map these helpers to probe_read_compat* functions, which
>> will in turn call probe_read_{user,kernel}*_common functions.
>> Func names might seem weird out of context, but it will be closer.
>> Implementation will still defer, e.g. to avoid warnings on platforms
>> without ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>>
>> Does that sound like a reasonable solution?
> Again that would make things different from Linus's tree, which is what
> we want to avoid if at all possible.
>
> What commits in 5.8 are you talking about here, if the changes are there
> that work here in 5.4, that's fine.
In 5.5 (mostly 6ae08ae3dea2) BPF UAPI was changed, bpf_probe_read was split
into compat (original), user and kernel variants. Compat here just calls the
kernel variant, which means it's still broken.
In 5.8 (8d92db5c04d10), compat was fixed to call user/kernel variants
according to address in machines where it makes sense, and disabled on other
machines. I am trying to take the fix for machines where it's possible, and
leave other machines untouched.

As I understand it, there are 3 options:
1)  Implement the same fix as v5.8, while staying with v5.4 code/API.
    That's what my original patch did.
2)  Import the new 5.5 API + 5.8 fix. It's not trivial to get API-compatibility
    right. Specifically - need to solve skb_output (a7658e1a4164c), another
    entry in the BPF enum, introduced before the new read variants.
3)  Take some internal code from v5.8 without changing the user-facing API.
    It will still not be cherry-picks and differ from Linus's tree. Result
    would be somewhat closer to v5.8 code, at the price of having a larger
    change.

I still like option 1, but I'd be happy to implement any other option you
prefer. I could also submit an identical patchset with a better commit
message.

Thank you!
Tsahi.

