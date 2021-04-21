Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00BF366BB3
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbhDUNFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:05:31 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:3877 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbhDUNFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:05:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010271; x=1650546271;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=yewBK2UdkTGSSBHvPotbvWTYavwdTYJMCubqayrc7fc=;
  b=HVwBTGtbY+1rwGrIg8tAiWhbOkhYHY6Khyap45VauqjzOilA35slSJK9
   Ps8I5MKl8dUpQvAxTlu9qSn3yjuBqD8jvFrt5D15IQAWL3VEmD8Cw1vXd
   ZoqjKu+0Lu60zDvDT0OjKvE1V99YfSRWBXld9UIZtotvw+/K9EatmkcLt
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,238,1613433600"; 
   d="scan'208";a="104665525"
Subject: Re: [PATCH 0/2] fix userspace access on arm64 for linux 5.4
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Apr 2021 13:04:21 +0000
Received: from EX13D01EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id D9BD5A2428;
        Wed, 21 Apr 2021 13:04:20 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.161.102) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:04:18 +0000
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <YHGMWBj+DEW+EiQE@kroah.com>
 <e99e851a-07c3-ab83-0d10-fa2bb87a516d@amazon.com>
 <YHVH2uNBTVDsJ66m@kroah.com>
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
Message-ID: <66f9c439-13d1-1392-0d20-0c48fb9fdd60@amazon.com>
Date:   Wed, 21 Apr 2021 16:04:12 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YHVH2uNBTVDsJ66m@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D32UWA004.ant.amazon.com (10.43.160.193) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 13/04/2021 10:27, Greg KH wrote:
> On Mon, Apr 12, 2021 at 10:46:41PM +0300, Zidenberg, Tsahi wrote:
>> The original bug that I was working on: command line parameters don't
>> appear when snooping execve using bpf on arm64.
> Has this ever worked?  If not, it's not really a regression that needs
> to be fixed, just use a newer kernel version, right?
It's not so much a regression between old and new kernels, as it is
a regression when changing architectures. The same API works on x86,
but not on arm64 (in x86 - you can access userspace with a kernelspace
access).
Multiple Linux distributions support both x86 and arm64, and some of
these choose to keep with 5.4 LTS Linux kernel. I think these
distributions should expect the same experience across architectures.
> But your "patch 1" is no where near what that commit is upstream so now
> you have divered from what is there and created something new.  And we
> don't like that for obvious reasons (no testing, maintaining over time,
> etc.)
I have created an alternative patch series that stays very close to
upstream. It brings in much more code, and adds some APIs as we
discussed. Will send it right away for your consideration.

Thank you!
Tsahi.

