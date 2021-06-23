Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8E63B1EEC
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWQsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 12:48:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:48226 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWQsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 12:48:10 -0400
IronPort-SDR: vAfAGzikqyxdrMGwtwlsu1j6ElsJ7OPpyU5A9VaRCxXIcwhbNYe9bmU4UPwkraIlh8q+9nTqUA
 j37r3/C9b7tg==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="268441964"
X-IronPort-AV: E=Sophos;i="5.83,294,1616482800"; 
   d="scan'208";a="268441964"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 09:45:51 -0700
IronPort-SDR: 2kKySzKhEEuaKqA1xVeNcgH+CcKpBVAuw8ohiGI7FILIaeXgEIcZBUQEZlYydjms64l/87Kwir
 4lfHSYHZXQFg==
X-IronPort-AV: E=Sophos;i="5.83,294,1616482800"; 
   d="scan'208";a="454714788"
Received: from crystalc-mobl1.amr.corp.intel.com ([10.212.148.72])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 09:45:50 -0700
Date:   Wed, 23 Jun 2021 09:45:49 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 038/146] mptcp: do not warn on bad input from the
 network
In-Reply-To: <254a0b83518083416abdae4cd27659bc10760773.camel@redhat.com>
Message-ID: <d3cd1cac-298e-fb97-ae5d-af6dd2de617c@linux.intel.com>
References: <20210621154911.244649123@linuxfoundation.org>  <20210621154912.589676201@linuxfoundation.org> <20210623142235.GA27348@amd> <254a0b83518083416abdae4cd27659bc10760773.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Jun 2021, Paolo Abeni wrote:

> Hello,
>
> On Wed, 2021-06-23 at 16:22 +0200, Pavel Machek wrote:
>> Hi!
>>
>>> From: Paolo Abeni <pabeni@redhat.com>
>>>
>>> [ Upstream commit 61e710227e97172355d5f150d5c78c64175d9fb2 ]
>>>
>>> warn_bad_map() produces a kernel WARN on bad input coming
>>> from the network. Use pr_debug() to avoid spamming the system
>>> log.
>>
>> So... we switched from WARN _ONCE_ to pr_debug, as many times as we
>> detect the problem.
>>
>> Should this be pr_debug_once?
>
> Thank you for double checking this!
>
> In the MPTCP code, we use pr_debug() statements as a debug tool, e.g.
> when enabled, it could print per-packet info with no restriction.
>
> There are (a few) similar use in the plain TCP code.
>
> pr_debug() is not supposed to be enabled on any production system,
> while the WARN_ONCE could trigger automated tools for irrelevant
> network noise.
>
> I thing pr_debug() is fine here.
>

Hi Pavel -

I agree with Paolo. This is not a frequently encountered condition, even 
when turning on this specific pr_debug(). I'd say the previous use of the 
_ONCE() variant was mostly because the effects were not optional (not 
because of frequency).

For protocol development, pr_debug() is both off by default and more
useful when it _is_ enabled. I'd prefer to keep this patch as-is.

Thanks,


--
Mat Martineau
Intel
