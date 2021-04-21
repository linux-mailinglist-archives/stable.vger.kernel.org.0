Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48D4366E2F
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 16:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhDUO2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 10:28:34 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11529 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbhDUO2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 10:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619015282; x=1650551282;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=2lNoxGX/RYM6USYtvjT8Br2jzuo6lbcOi3HWRI5WpI8=;
  b=TLpi7nM/FJxFoX9AFkZ3AJXElKPd3XeVGRmjAik/D/hdj+Xv855sks/j
   XnMyfF9DOV8i17EzZuHMUxxoGSXMzUAec4Un+q8mMAqMmpwPUednptX5+
   84J0aOr/kecHU1nLJJeGmbXHzDKWQVjmcD0LCr5q16ZDi+2KELqIvhK0W
   c=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="109008671"
Subject: Re: [PATCH 0/8] Fix bpf: fix userspace access for bpf_probe_read{, str}()
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Apr 2021 14:27:55 +0000
Received: from EX13D01EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id B82E4A1D71;
        Wed, 21 Apr 2021 14:27:53 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.162.28) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 14:27:51 +0000
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
 <YIAmHIzn2eW+II3R@kroah.com>
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
Message-ID: <eb943c43-8446-4a8a-c4a2-3e95ede58347@amazon.com>
Date:   Wed, 21 Apr 2021 17:27:44 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIAmHIzn2eW+II3R@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.162.28]
X-ClientProxiedBy: EX13D31UWC003.ant.amazon.com (10.43.162.34) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 21/04/2021 16:18, Greg KH wrote:
> On Wed, Apr 21, 2021 at 04:05:32PM +0300, Zidenberg, Tsahi wrote:
>> In arm64, kernelspace address accessors cannot be used to access
>> userspace addresses, which means bpf_probe_read{,str}() cannot access
>> userspace addresses. That causes e.g. command-line parameters to not
>> appear when snooping execve using bpf.
>>
>> This patch series takes the upstream solution. This solution also
>> changes user API in the following ways:
>> * Add probe_read_{user, kernel}{,_str} bpf helpers
>> * Add skb_output helper to the enum only (calling it not supported)
>> * Add support for %pks, %pus specifiers
>>
>> An alternative fix only takes the required logic to existing API without
>> adding new API, was suggested here:
>> https://www.spinics.net/lists/stable/msg454945.html
>>
>> Another option is to only take patches [1-4] of this patchset, and add
>> on top of them commit 8d92db5c04d1 ("bpf: rework the compat kernel probe
>> handling"). In that case, the last patch would require function renames
>> and conflict resolutions that were avoided in this patchset by pulling
>> patches [5-7].
> What stable tree(s) are you expecting these to be relevant for?
Sorry I forgot to mention it here..
This patchset was created/tested for 5.4.
I expect it to also be relevant for 4.19, but I didn't test it.
If you like it for 5.4 I could test and resubmit or notify you.
No updates are necessary for 5.10.

Thank you!
Tsahi.

