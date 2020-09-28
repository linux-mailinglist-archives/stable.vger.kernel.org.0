Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4856227B885
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 01:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgI1Xzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 19:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgI1Xzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 19:55:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 947A82193E;
        Mon, 28 Sep 2020 22:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601330426;
        bh=ZFEod8yQOVrkBo8ei/0ZNHsZ2G5wacEFDAQREbQ1Mrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gJLQq3XgRmcaXVK+sZq+JIMO4IOEauGmH4HgF2Sa6Btp9+3h4CDacN1VCnp/tPJMz
         DUmXdPyhHucWge65pwMg1pegZv6ltXZdy1x3aZox7MFn9fTY83MkimhlRgaCHfFpds
         LDiJd1X2alw+WM3v7lVlQJ1Xidohk/r8SnkeGMZ0=
Date:   Mon, 28 Sep 2020 18:00:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH AUTOSEL 4.4 42/64] serial: uartps: Wait for tx_empty in
 console setup
Message-ID: <20200928220025.GD2219727@sasha-vm>
References: <20200918021643.2067895-1-sashal@kernel.org>
 <20200918021643.2067895-42-sashal@kernel.org>
 <CA+G9fYsi87yT-bEdpQ+7ca5gH_QcWHmticMSxKuCSt+SLrWj-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsi87yT-bEdpQ+7ca5gH_QcWHmticMSxKuCSt+SLrWj-A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 01:46:59AM +0530, Naresh Kamboju wrote:
>On Fri, 18 Sep 2020 at 07:51, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
>>
>> [ Upstream commit 42e11948ddf68b9f799cad8c0ddeab0a39da33e8 ]
>>
>> On some platforms, the log is corrupted while console is being
>> registered. It is observed that when set_termios is called, there
>> are still some bytes in the FIFO to be transmitted.
>>
>> So, wait for tx_empty inside cdns_uart_console_setup before calling
>> set_termios.
>>
>> Signed-off-by: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
>> Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
>> Link: https://lore.kernel.org/r/1586413563-29125-2-git-send-email-raviteja.narayanam@xilinx.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>stable rc branch 4.4 arm64 build broken.
>
>../drivers/tty/serial/xilinx_uartps.c: In function ‘cdns_uart_console_setup’:
>../drivers/tty/serial/xilinx_uartps.c:1170:40: error: ‘TX_TIMEOUT’
>undeclared (first use in this function)
> 1170 |  time_out = jiffies + usecs_to_jiffies(TX_TIMEOUT);
>                                                                      ^~~~~~~~~~
>Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Dropped, thanks!

-- 
Thanks,
Sasha
