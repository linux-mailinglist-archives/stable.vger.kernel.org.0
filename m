Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF10C27D499
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 19:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgI2Rjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 13:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2Rjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 13:39:33 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 795F32076A;
        Tue, 29 Sep 2020 17:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601401172;
        bh=3Q9bIE4KRAd2RN7bnCf2+tZORxbdZuhsPUXx+b2+McM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oj4+d+/ZsAHArbDN58zR7nMq9nUyUiVAI2GcMw6FexUXT4msRXrG/Nb8rbg8V3JQV
         pdHPG9CQAycWuWhULCHE52vbCR+oONa7rRf24cxjK1WXEYUuKVxE5Ap+IS918M8D7g
         Gs/HA+a7NBLdIYgQVAGWt/TRMR31YXXrDb0RQFxE=
Date:   Tue, 29 Sep 2020 13:39:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        linux-serial@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH AUTOSEL 4.9 64/90] serial: uartps: Wait for tx_empty in
 console setup
Message-ID: <20200929173931.GC2415204@sasha-vm>
References: <20200918021455.2067301-1-sashal@kernel.org>
 <20200918021455.2067301-64-sashal@kernel.org>
 <CA+G9fYuT_qF2sbmCV76C3B=KS7tSjo9XDkCLwm0A4ZBLJ_eBtw@mail.gmail.com>
 <CA+G9fYtRj=+KM0CJZjPnfCn6OHcW7iFAkE=ECKiz4uOOyq=B2Q@mail.gmail.com>
 <20200929065902.GD2439787@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200929065902.GD2439787@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 08:59:02AM +0200, Greg Kroah-Hartman wrote:
>On Tue, Sep 29, 2020 at 01:43:22AM +0530, Naresh Kamboju wrote:
>> On Tue, 29 Sep 2020 at 01:41, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>> >
>> > On Fri, 18 Sep 2020 at 07:55, Sasha Levin <sashal@kernel.org> wrote:
>> > >
>> > > From: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
>> > >
>> > > [ Upstream commit 42e11948ddf68b9f799cad8c0ddeab0a39da33e8 ]
>> > >
>> > > On some platforms, the log is corrupted while console is being
>> > > registered. It is observed that when set_termios is called, there
>> > > are still some bytes in the FIFO to be transmitted.
>> > >
>> > > So, wait for tx_empty inside cdns_uart_console_setup before calling
>> > > set_termios.
>> > >
>> > > Signed-off-by: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
>> > > Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
>> > > Link: https://lore.kernel.org/r/1586413563-29125-2-git-send-email-raviteja.narayanam@xilinx.com
>> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> >
>> > stable rc 4.9 arm64 build broken.
>>
>> and stable rc 4.9 arm build broken.
>
>Thanks, I've queued up the dependant patch, somehow Sasha's builders
>must have missed this :)

Because it doesn't fail here with an allmodconfig :(

sasha@sasha-builder:~/data/linux$ git checkout queue-4.9
HEAD is now at 77d58b1b4d54 kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()
sasha@sasha-builder:~/data/linux$ make ARCH=arm64 CROSS_COMPILE="/home/sasha/x-tools/aarch64-unknown-linux-android/bin/aarch64-unknown-linux-android-" allmodconfig
scripts/kconfig/conf  --allmodconfig Kconfig
#
# configuration written to .config
#
sasha@sasha-builder:~/data/linux$ make ARCH=arm64 CROSS_COMPILE="/home/sasha/x-tools/aarch64-unknown-linux-gnu/bin/aarch64-unknown-linux-gnu-" drivers/tty/serial/xilinx_uartps.o
   CHK     include/config/kernel.release
   CHK     include/generated/uapi/linux/version.h
   CHK     include/generated/utsrelease.h
   CHK     include/generated/bounds.h
   CHK     include/generated/timeconst.h
   CHK     include/generated/asm-offsets.h
   CALL    scripts/checksyscalls.sh
   CHK     scripts/mod/devicetable-offsets.h
   CC [M]  drivers/tty/serial/xilinx_uartps.o

-- 
Thanks,
Sasha
