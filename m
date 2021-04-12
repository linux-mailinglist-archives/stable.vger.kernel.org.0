Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4120C35D1A0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 22:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbhDLUC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 16:02:26 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:25555 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237233AbhDLUCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 16:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1618257728; x=1649793728;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=fkCCIkqaqJctxZj2GiGjCNjQIx+/CxPQDQlGAO4ey68=;
  b=a/9y/Ja6Wk5zCjOwKQqodRDcw/btT+MlySE4GdNQcXExif+y4k0t1jj9
   Bxd63fHKvypldWp3l+jpUz4lauWcbY7zQRw6KsO7abhuaeHdYn2SGzvCs
   62kcHOW/F5hBEJgc8I7Jhff2Z18kid0ArxXhX6Yjk99bEDZq+6o0RTqeT
   s=;
X-IronPort-AV: E=Sophos;i="5.82,216,1613433600"; 
   d="scan'208";a="127042578"
Subject: Re: [PATCH 1/2] bpf: fix userspace access for bpf_probe_read{, str}()
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 12 Apr 2021 20:02:08 +0000
Received: from EX13D01EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 34B78A04E0;
        Mon, 12 Apr 2021 20:02:07 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.161.102) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 12 Apr 2021 20:02:03 +0000
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com> <YGNeIhMNjQ0RGUGr@sashalap>
 <b0a5f24a-4e25-53f2-f5fb-e09ac89dc869@amazon.com>
 <YGg7zApJnXCFNgL4@kroah.com>
 <655b6f67-787f-80dd-975e-3d1ab87b0c49@amazon.com>
 <YHGMAxjfn1fKfgGE@kroah.com>
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
Message-ID: <7f022c63-f0d9-cf5d-9330-d8548e4095b4@amazon.com>
Date:   Mon, 12 Apr 2021 23:01:59 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHGMAxjfn1fKfgGE@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D44UWC002.ant.amazon.com (10.43.162.169) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/04/2021 14:29, Greg KH wrote:
> On Sun, Apr 04, 2021 at 12:13:46PM +0300, Zidenberg, Tsahi wrote:
>> On 03/04/2021 12:56, Greg KH wrote:
>>>
>>> Again that would make things different from Linus's tree, which is what
>>> we want to avoid if at all possible.
>>>
>>> What commits in 5.8 are you talking about here, if the changes are there
>>> that work here in 5.4, that's fine.
>> In 5.5 (mostly 6ae08ae3dea2) BPF UAPI was changed, bpf_probe_read was split
>> into compat (original), user and kernel variants. Compat here just calls the
>> kernel variant, which means it's still broken.
> That's not a UAPI change, that does not change the userspace-visable
> part, right?  Did something change?
>
>> In 5.8 (8d92db5c04d10), compat was fixed to call user/kernel variants
>> according to address in machines where it makes sense, and disabled on other
>> machines. I am trying to take the fix for machines where it's possible, and
>> leave other machines untouched.
>>
>> As I understand it, there are 3 options:
>> 1)  Implement the same fix as v5.8, while staying with v5.4 code/API.
>>     That's what my original patch did.
>> 2)  Import the new 5.5 API + 5.8 fix. It's not trivial to get API-compatibility
>>     right. Specifically - need to solve skb_output (a7658e1a4164c), another
>>     entry in the BPF enum, introduced before the new read variants.
> What "API-compatibility" are you trying for here?  There is no issues
> with in-kernel changes of apis.
>
> What commits exactly does this require?  It is almost always better to
> keep the same identical patches that are in newer kernels to be
> backported than to do something different like you are doing in 1).
> That way any future changes/fixes can easily also be backported.
> Otherwise it gets harder and harder over time.
This is how I understand it, please correct me if/where I'm wrong:

include/uapi/linux/bpf.h is part of the UAPI. Specifically, bpf_func_id
enum is part of the UAPI. This enum matches function I.D to bpf helper,
and the indexes are kept constant across kernel versions.

Kernel 5.5 added skb_output helper (irrelevant to our fix) to that enum,
and then added probe_read_{user,kernel}* functions on top of that. Taking
probe_read_{user,kernel}* from commit 6ae08ae3dea2 itself is changing
UAPI. The mainline fix in 5.8 (8d92db5c04d10) depends on that UAPI change.

Appending another function is not a terrrible UAPI change, but to
keep these functions at the same index as later kernel versions - we'd
also need to either take skb_output or add a replacement.


Thank you!
Tsahi.
