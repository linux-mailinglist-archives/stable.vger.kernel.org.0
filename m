Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5242A277ACE
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 22:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIXUyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 16:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgIXUyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 16:54:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 928AF221EB;
        Thu, 24 Sep 2020 20:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600980856;
        bh=tVjYj9L6bZlyfmQII/W2YskHWml8UCyVZRJQUGN3Hew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iSnYpDRhlNSQLE336fF32Fw3x7t7F7vSL4XkGh8Ah/H0Y9tPbXGBZJs0x/j3SqtKA
         pu6F0VIA+ia1EI+gcsnbPDrAUQO9GPIpyQQdaXVpIk85n7VwtJhn74SfswoKAEdv4+
         m7dm/7zkj42sSjYFFleRXcs0C8HBfnxz4uIr8z08=
Date:   Thu, 24 Sep 2020 16:54:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 041/330] USB: serial: mos7840: fix probe
 error handling
Message-ID: <20200924205415.GQ2431@sasha-vm>
References: <20200918020110.2063155-1-sashal@kernel.org>
 <20200918020110.2063155-41-sashal@kernel.org>
 <20200918065300.GA21896@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200918065300.GA21896@localhost>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 08:53:00AM +0200, Johan Hovold wrote:
>On Thu, Sep 17, 2020 at 09:56:21PM -0400, Sasha Levin wrote:
>> From: Johan Hovold <johan@kernel.org>
>>
>> [ Upstream commit 960fbd1ca584a5b4cd818255769769d42bfc6dbe ]
>>
>> The driver would return success and leave the port structures
>> half-initialised if any of the register accesses during probe fails.
>>
>> This would specifically leave the port control urb unallocated,
>> something which could trigger a NULL pointer dereference on interrupt
>> events.
>>
>> Fortunately the interrupt implementation is completely broken and has
>> never even been enabled...
>>
>> Note that the zero-length-enable register write used to set the zle-flag
>> for all ports is moved to attach.
>>
>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Johan Hovold <johan@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this from all stable queues. As the commit message and
>missing stable-cc tag suggests, it's not needed.
>
>Sasha, please stop sending AUTOSEL patches for usb-serial. I think this
>the fourth time I ask you now.

Right, this series is a bit different because it didn't originate from
the AUTOSEL work but rather was an audit of patches picked up by
downstream kernels as fixes.

I'll drop it, sorry for the noise.

-- 
Thanks,
Sasha
