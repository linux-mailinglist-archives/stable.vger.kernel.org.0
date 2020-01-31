Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9696114F3F0
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 22:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgAaVoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 16:44:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:60613 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgAaVoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 16:44:21 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 13:44:21 -0800
X-IronPort-AV: E=Sophos;i="5.70,387,1574150400"; 
   d="scan'208";a="377464364"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 13:44:20 -0800
Date:   Fri, 31 Jan 2020 13:44:19 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 36/55] drivers/net/b44: Change to non-atomic bit
 operations on pwol_mask
Message-ID: <20200131214419.GA19569@agluck-desk2.amr.corp.intel.com>
References: <20200130183608.563083888@linuxfoundation.org>
 <20200130183615.120752961@linuxfoundation.org>
 <20200131125730.GA20888@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131125730.GA20888@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 01:57:31PM +0100, Pavel Machek wrote:
> And I wonder if this is even good idea for mainline. x86 architecture
> is here for long time, and I doubt Intel is going to break it like
> this. Do you have documentation pointer? 

Intel isn't breaking this legacy behaviour. But it is building h/w that
allows s/w to opt-in to a mode that will generate an #AC trap for
a split lock.  One such processor ("Icelake") is already shipping.

Some Linux use cases (real-time) really, really want to avoid the cost
of a split-lock.  There's a patch in TIP that will enable this #AC on
split-lock mode on processors that support it.

Thus it's a good idea to clean up any places in the kernel that will
cause #AC when that mode is enabled. I think mainline should be
taking any patches for split lock cleanup.

Stable is a different question.  The patch to enable the #AC should
not be backported to stable. So the only way an old kernel would hit
this would be if the BIOS enabled the #AC. Really that should only
happen on a system where the developers have validated that the
entire software stack has been checked for split locks.

Is net/b44 a device that is still being included on current systems?
Or is it a legacy device that has been superceeded by something else?
If there isn't going to be a b44 on an Icelake or newer system, then
perhaps we should not worry so much about fixing the driver.

-Tony
