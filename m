Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1F967F553
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 07:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjA1GxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 01:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbjA1GxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 01:53:01 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092F012878
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 22:52:58 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1636eae256cso4987711fac.0
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 22:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wppWBf9nD2Xoofwj3LLIggIcy1BkcCXUlU2b55z0apo=;
        b=L5kVtOZU9GrDcRomzZGuT+OKzGq/6An1EucuprkCAkgeSxGQjlvPOCKr587vMAiwQs
         7bj7ECp3PmLfRwriRLejhYlF1UKQruW/OWU5DIUJ/UzrLQeDkpXMPCFhaS0Hoc0o+QbX
         ZFKH/12E83H0GyOanqFG71nK1j+uN0AIl9nvBQaxEIfJ4SJdxteOQ2qavGefo5BBOqFb
         EIMdh73/P0Xa/kSW4FmH9sVUPgDiMFfDvf5GsSppXgTk9wTmvw74yssDGQx70oXLwp3x
         jS2G79FJ9ofuaDY5WZCsAWQo0/GQRTWdr3QnFUX8QBKSjt+rVl6/WzdktEBfOutG2LH2
         XRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wppWBf9nD2Xoofwj3LLIggIcy1BkcCXUlU2b55z0apo=;
        b=LIOK1KZ7sf6q9AJdZiMG7W1Pmqcj5T+x5xhddjorWK3PLUU1w85dW6n1rJ/WV+tE8L
         g3Iii1KgeGLC9fVSVbFkTAoT8t1pkgwCr/gxMkdnZfAGq2RK0sPfXKnvmSC2LSp1WMQT
         cH+P9rEDicQ8TyoR7Qegkdjaa5xt5UqJmNXwMpouuArO7usk38FuwNIjuVYyIjwHQbJ7
         A1ctDmZW/b6O8uDz3BH84KiITQn6ZvtCukWJxGtMv7e5JmmOEUBRlrzZe0v1le+FsxMY
         Abgh15n6NvqW2KyBiYgJFdQTQWw4AkvvJyk3Mmkc0LPis/RwOvrOTCjPgi5sFJpzG3cm
         Ekyg==
X-Gm-Message-State: AFqh2kqvHiqeDV/op2BVpSguCVPSreIq5fsUpsC8TAq6k1JdSLgJzfE7
        n7Lo3eNJh2J3Zb0ZHyeo5KxrBMTTz2Ft3cFyZRXbrMHNdy5JFg==
X-Google-Smtp-Source: AMrXdXuo2ruKQVtZ0CGNJrvj24tTdPdIbJkW5FwgdpXBlAtZz8uAMIbtKUe6xtgGv7Ci5dgB2xEbc1IeYCOwLHUDmko=
X-Received: by 2002:a05:6870:c190:b0:160:32ca:28a with SMTP id
 h16-20020a056870c19000b0016032ca028amr1625965oad.116.1674888777837; Fri, 27
 Jan 2023 22:52:57 -0800 (PST)
MIME-Version: 1.0
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Fri, 27 Jan 2023 22:52:47 -0800
Message-ID: <CAA5qM4B-4_9dpb=O_+ttGsOpP=N-aMrBpb+KZ7RJCOxxR+CoFA@mail.gmail.com>
Subject: i2c: mv64xxx: Add atomic_xfer method to driver
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Folks,
I am getting the following dmesg during shutdown on a stable kernel
(5.15.90) on a sunxi-a20 board.

Please consider cherry-pick the following commits to fix the issue in
stable kernel

09b343038e34 ("i2c: mv64xxx: Remove shutdown method from driver")
544a8d75f3d6 ("i2c: mv64xxx: Add atomic_xfer method to driver")

Thanks and have a good one,
- Tong

Tested-by: Tong Zhang <ztong0001@gmail.com>

8<------------------------------

0 PID: 1 at drivers/i2c/i2c-core.h:41 i2c_transfer+0xf8/0x104
[786648.647796] No atomic I2C transfer handler for 'i2c-1'
[786648.653055] Modules linked in: ip_tables x_tables ipv6
[786648.658372] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 5.15.88 #3
[786648.665040] Hardware name: Allwinner sun7i (A20) Family
[786648.670406] [<c010df14>] (unwind_backtrace) from [<c010a5b4>]
(show_stack+0x10/0x14)
[786648.678329] [<c010a5b4>] (show_stack) from [<c082dbcc>]
(dump_stack_lvl+0x40/0x4c)
[786648.686066] [<c082dbcc>] (dump_stack_lvl) from [<c011dce4>]
(__warn+0xe0/0xe4)
[786648.693455] [<c011dce4>] (__warn) from [<c011dd60>]
(warn_slowpath_fmt+0x78/0xbc)
[786648.701106] [<c011dd60>] (warn_slowpath_fmt) from [<c06111d8>]
(i2c_transfer+0xf8/0x104)
[786648.709375] [<c06111d8>] (i2c_transfer) from [<c0611234>]
(i2c_transfer_buffer_flags+0x50/0x74)
[786648.718256] [<c0611234>] (i2c_transfer_buffer_flags) from
[<c0549dd8>] (regmap_i2c_write+0x14/0x30)
[786648.727493] [<c0549dd8>] (regmap_i2c_write) from [<c05454b4>]
(_regmap_raw_write_impl+0x368/0x66c)
[786648.736629] [<c05454b4>] (_regmap_raw_write_impl) from
[<c0545830>] (_regmap_bus_raw_write+0x78/0xa0)
[786648.746020] [<c0545830>] (_regmap_bus_raw_write) from [<c0546138>]
(regmap_write+0x3c/0x5c)
[786648.754541] [<c0546138>] (regmap_write) from [<c054e754>]
(axp20x_power_off+0x2c/0x38)
[786648.762627] [<c054e754>] (axp20x_power_off) from [<c01424ac>]
(__do_sys_reboot+0x144/0x1d8)
[786648.771158] [<c01424ac>] (__do_sys_reboot) from [<c0100060>]
(ret_fast_syscall+0x0/0x48)
[786648.779420] Exception stack(0xc104ffa8 to 0xc104fff0)
[786648.784614] ffa0:                   4321fedc bedb2bc8 fee1dead
28121969 4321fedc 00000000
[786648.792943] ffc0: 4321fedc bedb2bc8 bedb2bc4 00000058 bedb2bc8
bedb2bc4 fffff000 bedb2bcc
[786648.801264] ffe0: 00000058 bedb2b3c b6f55045 b6ed37e6
[786648.806440] ---[ end trace 66f75e44e685be28 ]---
[786650.693467] i2c i2c-1: mv64xxx: I2C bus locked, block: 1, time_left: 0
[786651.213455] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00000000
[786651.221278] CPU: 0 PID: 1 Comm: systemd-shutdow Tainted: G
W         5.15.88 #3
[786651.229346] Hardware name: Allwinner sun7i (A20) Family
[786651.234710] [<c010df14>] (unwind_backtrace) from [<c010a5b4>]
(show_stack+0x10/0x14)
[786651.242640] [<c010a5b4>] (show_stack) from [<c082dbcc>]
(dump_stack_lvl+0x40/0x4c)
[786651.250378] [<c082dbcc>] (dump_stack_lvl) from [<c082bcf0>]
(panic+0xf4/0x2d8)
[786651.257778] [<c082bcf0>] (panic) from [<c01227f0>] (do_exit+0x8d0/0xadc)
[786651.264652] [<c01227f0>] (do_exit) from [<c01424b4>]
(__do_sys_reboot+0x14c/0x1d8)
[786651.272405] [<c01424b4>] (__do_sys_reboot) from [<c0100060>]
(ret_fast_syscall+0x0/0x48)
[786651.280667] Exception stack(0xc104ffa8 to 0xc104fff0)
[786651.285860] ffa0:                   4321fedc bedb2bc8 fee1dead
28121969 4321fedc 00000000
[786651.294188] ffc0: 4321fedc bedb2bc8 bedb2bc4 00000058 bedb2bc8
bedb2bc4 fffff000 bedb2bcc
[786651.302508] ffe0: 00000058 bedb2b3c b6f55045 b6ed37e6
[786651.307700] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x00000000 ]---
