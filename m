Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3645350680
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 20:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhCaSh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 14:37:56 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:16251 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhCaShn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 14:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617215864; x=1648751864;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=pJx5l5IUyVFTnL4MY0QFELAQ9SMIATEuO+GrHBpRKa0=;
  b=KdjPJ6+jk+WALK4NuVAFOr08bU+5yXzJJCgxJtb/zB+0Vkx4FHwpPLRc
   FDrULWzQo55dsDYwaItG4ntE9SQu/j581F4hlQfdFGB1qGQ9mp9z5+aMr
   RdmDo9LsIaGtoQqT5exEf3FoWf6ELF0fNqOQnQQ9r091WDms9C4d4U8zv
   0=;
X-IronPort-AV: E=Sophos;i="5.81,293,1610409600"; 
   d="scan'208";a="102494824"
Subject: Re: [PATCH 1/2] bpf: fix userspace access for bpf_probe_read{, str}()
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 31 Mar 2021 18:37:37 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 864E5240AA4;
        Wed, 31 Mar 2021 18:37:36 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.162.207) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 31 Mar 2021 18:37:33 +0000
To:     Sasha Levin <sashal@kernel.org>
CC:     <stable@vger.kernel.org>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com> <YGNeIhMNjQ0RGUGr@sashalap>
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
Message-ID: <b0a5f24a-4e25-53f2-f5fb-e09ac89dc869@amazon.com>
Date:   Wed, 31 Mar 2021 21:37:28 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGNeIhMNjQ0RGUGr@sashalap>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.162.207]
X-ClientProxiedBy: EX13D07UWA001.ant.amazon.com (10.43.160.145) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/03/2021 20:21, Sasha Levin wrote:
> commit 8d92db5c04d10381f4db70ed99b1b576f5db18a7 upstream.
>>
>> This is an adaptation of parts from above commit to kernel 5.4.
>
> This is very different from the upstream commit, let's not annotate it
> as that commit.
>
No problem.
>>
>> To generally fix the issue, upstream includes new BPF helpers:
>> bpf_probe_read_{user,kernel}_str(). For details on them, see
>> commit 6ae08ae3dea2 ("bpf: Add probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers")
>
> What stops us from taking that API back to 5.4? I took a look at the
> dependencies and they don't look too scary.
>
> Can we try that route instead? We really don't want to diverge from
> upstream that much.
>
probe_read_{user,kernel}* functions themselves seem simple enough.
Importing them in a forward-compliant way to 5.4 would require either
adding an unused entry in bpf.h's __BPF_FUNC_MAPPER or also pulling
skb_output bpf helper functions into 5.4. To me, it seems like too
much of a UAPI change to go into a stable release.

Another option would be to import more code to make it somewhat closer
to upstream implementation without changing UAPI. As in v5.8, I could
internally map these helpers to probe_read_compat* functions, which
will in turn call probe_read_{user,kernel}*_common functions.
Func names might seem weird out of context, but it will be closer.
Implementation will still defer, e.g. to avoid warnings on platforms
without ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE

Does that sound like a reasonable solution?

--
Thanks,
Tsahi
