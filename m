Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585B74A67EB
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 23:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239730AbiBAWX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 17:23:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:27449 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239569AbiBAWX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Feb 2022 17:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643754236; x=1675290236;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=LDA11oIt3ZuYcp+qjJtMtPHBGLPRGcv4qaLDLO6F51U=;
  b=W5FNP25BbRK88Bcv00biBrbb1P8RtYU9oQDHo+7ZJ9ewjLzbX4O4/HMf
   8HDot1uffTooSMTNA2NNbELW3lFr4w2Bu9MFOqtX8n/WmziShdEIUMmv/
   Cxo3G9sN8tciL4VDmnaoM/K/CWNrKzXdf48DOWJyayswrhYeaLL0IgLyG
   h/gYczbLdDrgXNogOvdFNM9nPyf2ptatA/2vaHDbMAigz53cfOwbuzhyP
   cWUgwHjS30oSTDVE1lA6zZLb8xvnYmm5BjyG6BQhxLrgzmEa8f52h6MEb
   ykvCQRTb608abbxfLJqkCtu3j4WleK+qAoKCouUqPRrknRi+Xz+RS3bAL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="245403280"
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="245403280"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 14:23:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="626887477"
Received: from ekebedex-mobl1.amr.corp.intel.com ([10.251.14.93])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 14:23:55 -0800
Date:   Tue, 1 Feb 2022 14:23:55 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH 5.16 138/200] mptcp: keep track of local endpoint still
 available for each msk
In-Reply-To: <YflEd6+5rdsfKojI@kroah.com>
Message-ID: <7c25c17-84d5-82ee-6d3-6b2482c939b2@linux.intel.com>
References: <20220131105233.561926043@linuxfoundation.org> <20220131105238.198209212@linuxfoundation.org> <26d216d1-355-e132-a868-529f15c9b660@linux.intel.com> <YflD6pbqi/EGPG3f@kroah.com> <YflEd6+5rdsfKojI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Feb 2022, Greg Kroah-Hartman wrote:

> On Tue, Feb 01, 2022 at 03:30:02PM +0100, Greg Kroah-Hartman wrote:
>> On Mon, Jan 31, 2022 at 11:36:32AM -0800, Mat Martineau wrote:
>>> On Mon, 31 Jan 2022, Greg Kroah-Hartman wrote:
>>>
>>>> From: Paolo Abeni <pabeni@redhat.com>
>>>>
>>>> [ Upstream commit 86e39e04482b0aadf3ee3ed5fcf2d63816559d36 ]
>>>
>>> Hi Greg -
>>>
>>> Please drop this from the stable queue for both 5.16 and 5.15. It wasn't
>>> intended for backporting and we haven't checked for dependencies with other
>>> changes in this part of MPTCP subsystem.
>>>
>>> In the mptcp tree we make sure to add Fixes: tags on every patch we think is
>>> eligible for the -stable tree. I know you're sifting through a lot of
>>> patches from subsystems that end up with important fixes arriving from the
>>> "-next" branches, and it seems like the scripts scooped up several MPTCP
>>> patches this time around that don't meet the -stable rules.
>>
>> I think these were needed due to 8e9eacad7ec7 ("mptcp: fix msk traversal
>> in mptcp_nl_cmd_set_flags()") which you did tag with a "Fixes:" tag,
>> right?  Without these other commits, that one does not apply and it
>> looks like it should go into 5.15.y and 5.16.y.
>>

Ok, I see what happened there (there's a new variable present in 5.17 
that's not relevant for the earlier kernels). 8e9eacad7ec7 needs manual 
backporting, I'll work on that and send to the stable list.

>> Note, just putting a "Fixes:" tag does not guarantee if a commit will 
>> go into a stable tree.  Please use the correct 
>> "Cc:stable@vger.kernel.org" tag as the documentation asks for.
>>

I will make sure to use the Cc:stable@vger.kernel.org tag in the future.


>> I'll go drop all of these mptcp patches, including 8e9eacad7ec7 ("mptcp:
>> fix msk traversal in mptcp_nl_cmd_set_flags()") for now.  If you want
>> them added back in, please let us know.
>
> To be specific, I have dropped the following commits from the queues
> now, which was more than just these three that you asked:
>
> 602837e8479d ("mptcp: allow changing the "backup" bit by endpoint id")
> 59060a47ca50 ("mptcp: clean up harmless false expressions")
> 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
> 8e9eacad7ec7 ("mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()")
> a4c0214fbee9 ("mptcp: fix removing ids bitmap setting")
> 9846921dba49 ("selftests: mptcp: fix ipv6 routing setup")
>
> If you want them back, please let us know.
>

Of the above, there's only one suitable for stable as-is:

9846921dba49 ("selftests: mptcp: fix ipv6 routing setup")

Please add that one to the 5.16 and 5.15 queues.


Thanks!


--
Mat Martineau
Intel
