Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1135265342D
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiLUQjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiLUQjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:39:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6344121800;
        Wed, 21 Dec 2022 08:39:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B7BCB81B97;
        Wed, 21 Dec 2022 16:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E896C433EF;
        Wed, 21 Dec 2022 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671640767;
        bh=WeFMIF8etWndUchlfTrkY4NERFPTyRAFBrYazCCgsXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rzzd/auHHs2WOMpCddCCUoar9TVYi3l1GYjrT2HQ1BWa9u0TIEoeH4HkCJpKwvShV
         KMfp9dGT7EX0gE1Geb0RiEa5crwhCihjr6xQt9dkL4YPR/IXMF7Tk3e2Wtylw9UXYb
         RHiMVuQSOsk566l92Kf3DBwiudCyyp7QoZp4mqKM=
Date:   Wed, 21 Dec 2022 17:39:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Zijun Hu <zijuhu@codeaurora.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Sai Teja Aluvala <quic_saluvala@quicinc.com>,
        Panicker Harish <quic_pharish@quicinc.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] serdev: ttyport: fix use-after-free on closed TTY
Message-ID: <Y6M2vLV9PM3HfXZY@kroah.com>
References: <20221221163249.1058459-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221163249.1058459-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 05:32:48PM +0100, Krzysztof Kozlowski wrote:
> use-after-free is visible in serdev-ttyport, e.g. during system reboot
> with Qualcomm Atheros Bluetooth.  The TTY is closed, thus "struct
> tty_struct" is being released, but the hci_uart_qca driver performs
> writes and flushes during system shutdown in qca_serdev_shutdown().
> 
>   Unable to handle kernel paging request at virtual address 0072662f67726fd7
>   ...
>   CPU: 6 PID: 1 Comm: systemd-shutdow Tainted: G        W          6.1.0-rt5-00325-g8a5f56bcfcca #8
>   Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
>   Call trace:
>    tty_driver_flush_buffer+0x4/0x30
>    serdev_device_write_flush+0x24/0x34
>    qca_serdev_shutdown+0x80/0x130 [hci_uart]
>    device_shutdown+0x15c/0x260
>    kernel_restart+0x48/0xac
> 
> KASAN report:
> 
>   BUG: KASAN: use-after-free in tty_driver_flush_buffer+0x1c/0x50
>   Read of size 8 at addr ffff16270c2e0018 by task systemd-shutdow/1
> 
>   CPU: 7 PID: 1 Comm: systemd-shutdow Not tainted 6.1.0-next-20221220-00014-gb85aaf97fb01-dirty #28
>   Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
>   Call trace:
>    dump_backtrace.part.0+0xdc/0xf0
>    show_stack+0x18/0x30
>    dump_stack_lvl+0x68/0x84
>    print_report+0x188/0x488
>    kasan_report+0xa4/0xf0
>    __asan_load8+0x80/0xac
>    tty_driver_flush_buffer+0x1c/0x50
>    ttyport_write_flush+0x34/0x44
>    serdev_device_write_flush+0x48/0x60
>    qca_serdev_shutdown+0x124/0x274
>    device_shutdown+0x1e8/0x350
>    kernel_restart+0x48/0xb0
>    __do_sys_reboot+0x244/0x2d0
>    __arm64_sys_reboot+0x54/0x70
>    invoke_syscall+0x60/0x190
>    el0_svc_common.constprop.0+0x7c/0x160
>    do_el0_svc+0x44/0xf0
>    el0_svc+0x2c/0x6c
>    el0t_64_sync_handler+0xbc/0x140
>    el0t_64_sync+0x190/0x194
> 
> Fixes: bed35c6dfa6a ("serdev: add a tty port controller driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  drivers/tty/serdev/serdev-ttyport.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
> index d367803e2044..3d2bab91a988 100644
> --- a/drivers/tty/serdev/serdev-ttyport.c
> +++ b/drivers/tty/serdev/serdev-ttyport.c
> @@ -91,6 +91,9 @@ static void ttyport_write_flush(struct serdev_controller *ctrl)
>  	struct serport *serport = serdev_controller_get_drvdata(ctrl);
>  	struct tty_struct *tty = serport->tty;
>  
> +	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
> +		return;

Shouldn't that be a more useful macro/function instead?
	serport_is_active(serport)

Anyway, what prevents this from changing _right_ after you test it and
before you call the next line in this function (same for all invocations
here.)

thanks,

greg k-h
