Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484E535D16A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 21:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbhDLTrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 15:47:16 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:4603 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbhDLTrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 15:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1618256817; x=1649792817;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=tcywR4t8O+B2vWqSiMMSOpE4uWNNqtJR3p/DWdYXtU4=;
  b=tCA3zMA0aTciEpHx38XkUiWijhEl+7Y0NnkaMgUt7AjK3moKy9oWDi7V
   OlWdP9TYAfYAljK4vtUtLUo42aYRylMLQFP9L4gnf9mTbnI33M+vf70Ht
   hCaecrfN6oDS/t7NGOWdTX1a8vO+z88l8StoHLma9EcRyYpRSdVe4iVHY
   w=;
X-IronPort-AV: E=Sophos;i="5.82,216,1613433600"; 
   d="scan'208";a="127038454"
Subject: Re: [PATCH 0/2] fix userspace access on arm64 for linux 5.4
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 12 Apr 2021 19:46:50 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 41C38A1DC1;
        Mon, 12 Apr 2021 19:46:48 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.160.48) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 12 Apr 2021 19:46:46 +0000
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <YHGMWBj+DEW+EiQE@kroah.com>
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
Message-ID: <e99e851a-07c3-ab83-0d10-fa2bb87a516d@amazon.com>
Date:   Mon, 12 Apr 2021 22:46:41 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHGMWBj+DEW+EiQE@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D48UWA004.ant.amazon.com (10.43.163.61) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/04/2021 14:30, Greg KH wrote:
> On Mon, Mar 29, 2021 at 01:56:53PM +0300, Zidenberg, Tsahi wrote:
>> arm64 access to userspace addresses in bpf and kprobes is broken,
>> because kernelspace address accessors are always used, and won't work
>> for userspace.
> What does not work exactly?
>
> What is broken that is fixed in these changes?  I can't seem to
> understand that as it feels like bpf and kprobes works on 5.4.y unless
> something broke it?
>
> confused,
>
> greg k-h

The original bug that I was working on: command line parameters don't
appear when snooping execve using bpf on arm64. This is true using
either osquery (with --enable_bpf_events) or bcc (execsnoop-bpfcc).
The reason, it seems, is that in arm64 userspace addresses cannot be
accessed with kernelspace accessors.
This bug is fixed with Patch 1.

Since Patch 1 added ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE, I thought
it made sense to check what else uses this config. I did not verify
kprobes are also broken in the same way, but it seems likely, and the
fix is very small. If only Patch 1 is merged - I'll be happy :)

Thank you!
Tsahi.
