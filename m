Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA11342BF7
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhCTLSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhCTLSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8598C619E3;
        Sat, 20 Mar 2021 10:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616237620;
        bh=wa6bFpfChGlr4zFoS0mPm5BPCSq0Uv76kpqvklHmxGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSBpQvKRuZZ3p3fR/gbm72y+m3x3W7hkM7c7gmdYccVpWf4PK8S186cBudD6bMcRO
         4wN6g7Qw843oqenJU50ToTlgfGwlWVLv5kxMmyRSGODcWyY/WKp1wWtDk/plefTcwF
         /xtLc7RnGGhAgq2TqMBrwl1kZuZCjdwop4ujzGXA=
Date:   Sat, 20 Mar 2021 11:53:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <simon.wy@alibaba-inc.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: Re: [PATCH 4.9] ixgbe: prevent ptp_rx_hang from running when in
 FILTER_ALL mode
Message-ID: <YFXUKr4tcy0MHLPt@kroah.com>
References: <20210320014451.36599-1-simon.wy@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320014451.36599-1-simon.wy@alibaba-inc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 20, 2021 at 09:44:51AM +0800, Wen Yang wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> commit 6704a3abf4cf4181a1ee64f5db4969347b88ca1d upstream.
> 
> On hardware which supports timestamping all packets, the timestamps are
> recorded in the packet buffer, and the driver no longer uses or reads
> the registers. This makes the logic for checking and clearing Rx
> timestamp hangs meaningless.
> 
> If we run the ixgbe_ptp_rx_hang() function in this case, then the driver
> will continuously spam the log output with "Clearing Rx timestamp hang".
> These messages are spurious, and confusing to end users.
> 
> The original code in commit a9763f3cb54c ("ixgbe: Update PTP to support
> X550EM_x devices", 2015-12-03) did have a flag PTP_RX_TIMESTAMP_IN_REGISTER
> which was intended to be used to avoid the Rx timestamp hang check,
> however it did not actually check the flag before calling the function.
> 
> Do so now in order to stop the checks and prevent the spurious log
> messages.
> 
> Fixes: a9763f3cb54c ("ixgbe: Update PTP to support X550EM_x devices", 2015-12-03)
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: <stable@vger.kernel.org> # 4.9.x: 622a2ef538fb: ixgbe: check for Tx timestamp timeouts during watchdog
> Cc: <stable@vger.kernel.org> # 4.9.x
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Thanks for the backport, now queued up.

greg k-h
