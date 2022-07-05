Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B425676EF
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 20:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiGESyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 14:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiGESyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 14:54:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B84C1658C;
        Tue,  5 Jul 2022 11:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657047241; x=1688583241;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=jy5NhYWnWv4OHjHj7j8+j/6G/mQekzx7zQG7r8h8CYw=;
  b=ME7rBK8vJiDaySGt1QdyXQetd/62Q2ftUp9igrUWf7d3N5SV36+3k+rI
   eoH3kjwx7HcyIzIwzb7cd8pO/UQUlATDT0s9kVYn3wqfmUcv0MfLxM+FI
   +3wV2ls8RFCCBbWFXZ8xYdz6mND3uhqF9OoztTQWiwMK6+1qh/Rkpbd74
   JC9j2Y6GY/5eN3r5YpxoL/JywDvmfZ8xrug7CmrzVajOqcTKdXM0KSgNs
   VcZiIc5hLN6bW7YpS6RR+FIEIsa/w6lpgwWhsR8UO4Hh6QxUXcNDQbU7p
   sxC6/dmB5rbmEEB2srSWFoMdcFxVbzShxw62ApXg+5pa2/Ly6tH4/ZStF
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="282201901"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="282201901"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 11:54:00 -0700
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="695775841"
Received: from atongsak-mobl1.amr.corp.intel.com ([10.209.113.116])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 11:54:00 -0700
Date:   Tue, 5 Jul 2022 11:54:00 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        MPTCP Upstream <mptcp@lists.linux.dev>
Subject: Re: [PATCH 5.10 51/84] selftests: mptcp: add ADD_ADDR timeout test
 case
In-Reply-To: <YsRnZ/wmcqGiYzOt@kroah.com>
Message-ID: <86b7155-839d-381e-4927-dd607366c7e6@linux.intel.com>
References: <20220705115615.323395630@linuxfoundation.org> <20220705115616.814163273@linuxfoundation.org> <a2260559-86af-74ff-ca95-d494688d5ea7@tessares.net> <YsRnZ/wmcqGiYzOt@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Jul 2022, Greg Kroah-Hartman wrote:

> On Tue, Jul 05, 2022 at 05:59:22PM +0200, Matthieu Baerts wrote:
>> Hi Greg, Sasha,
>>
>> (+ MPTCP upstream ML)
>>
>> First, thank you again for maintaining the stable branches!
>>
>> On 05/07/2022 13:58, Greg Kroah-Hartman wrote:
>>> From: Geliang Tang <geliangtang@gmail.com>
>>>
>>> [ Upstream commit 8d014eaa9254a9b8e0841df40dd36782b451579a ]
>>>
>>> This patch added the test case for retransmitting ADD_ADDR when timeout
>>> occurs. It set NS1's add_addr_timeout to 1 second, and drop NS2's ADD_ADDR
>>> echo packets.
>> TL;DR: Could it be possible to drop all selftests MPTCP patches from
>> v5.10 queue please?
>>
>>
>> I was initially reacting on this patch because it looks like it depends on:
>>
>>   93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
>>
>> and indirectly to:
>>
>>   9ce7deff92e8 ("docs: networking: mptcp: Add MPTCP sysctl entries")
>>
>> to have "net.mptcp.add_addr_timeout" sysctl knob needed for this new
>> selftest.
>>
>> But then I tried to understand why this current patch ("selftests:
>> mptcp: add ADD_ADDR timeout test case") has been selected for 5.10. I
>> guess it was to ease the backport of another one, right?
>> Looking at the 'series' file in 5.10 queue, it seems the new
>> "selftests-mptcp-more-stable-diag-tests" patch requires 5 other patches:
>>
>> -> selftests-mptcp-more-stable-diag-tests.patch
>>  -> selftests-mptcp-fix-diag-instability.patch
>>   -> selftests-mptcp-launch-mptcp_connect-with-timeout.patch
>>    -> selftests-mptcp-add-add_addr-ipv6-test-cases.patch
>>     -> selftests-mptcp-add-link-failure-test-case.patch
>>      -> selftests-mptcp-add-add_addr-timeout-test-case.patch
>>
>>
>> When looking at these patches in more detail, it looks like "selftests:
>> mptcp: add ADD_ADDR IPv6 test cases" depends on a new feature only
>> available from v5.11: ADD_ADDR for IPv6.
>>
>>
>> Could it be possible to drop all these patches from v5.10 then please?
>
> Sure, but leave them in for 5.15.y and 5.18.y?
>

Hi Greg -

I'm the other MPTCP maintainer, jumping in here due to Matt's time zone.

Yes: leave selftests-mptcp-more-stable-diag-tests.patch in 5.15.y and 
5.18.y

--
Mat Martineau
Intel
