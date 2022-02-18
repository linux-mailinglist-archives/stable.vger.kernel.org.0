Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06AD4BAF23
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 02:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiBRB1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 20:27:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiBRB1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 20:27:49 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989C4DEF5
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 17:27:34 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id a6so1499593oid.9
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 17:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:user-agent:date:message-id:subject:to:cc;
        bh=kFDKVWyEyvDppu0jj4hMTqjCtj/MAyORvC6FZOal0io=;
        b=WP7RLa6pkhllQDpL4S6fLT6vXbProVLngxFcYwjtsvrnjsRrYuorZM6OlDLKtqkWh5
         cvpIJjyO44pDC+AoXA2/rG4ylbi4QbVZD17hSfFBJfz//JE+6Wfb1UfbNXGv6akZ/rFI
         Uf7DY89cYwhXaqGdYL1+vQGimTKFrPlPBmmrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:user-agent:date:message-id
         :subject:to:cc;
        bh=kFDKVWyEyvDppu0jj4hMTqjCtj/MAyORvC6FZOal0io=;
        b=PvwStyQ9GX1r7dVY0aMX5FOEP9ECl3QAjl4g2lEdQECW4TZXczljCKnq/sBrjEW0CL
         D11EqRYJh9u3lWueFLznwUD1O/5V/X4qO2IKaESOk0VyxsumBKSV4rADjarqSQElT3ah
         E+optbmds+i5fDsPmymjcFEetw3ZTDzoFMwnF3eSKIa/h1gfkqoF05T6FMPxd9W27nwp
         SgGgP6IgQlzqBNucJVg12YMkdcPsIhYxwUdWAhtkHfyFJU/FlNR9NTVve3jqfoTks+i6
         TsO1lWbNX394PGmxPIlV9fgJon/HqprUhmAVqf8iQzTd2aU58XbTSknV2cKTgW/RK9Ue
         vLcA==
X-Gm-Message-State: AOAM532GwjqZ4pDghxfb1V8HHi3yw3PE6DrZGQZsX9oruoDDDgI7ZNVD
        PLAaoPNim7c52hYk9m4iBeZTCqquiBSdZ8uaFqU6ZivRgMw=
X-Google-Smtp-Source: ABdhPJzHC6aV5Kx1A5nxbGw3uEjAqoiTLrCzQpK7+KxzKNv9PZZ7OGTdCHLqssNOfVN6n/2z1yIdw8f4yp4eg7z1wlU=
X-Received: by 2002:aca:df44:0:b0:2ce:285f:cb99 with SMTP id
 w65-20020acadf44000000b002ce285fcb99mr3960562oig.40.1645147653657; Thu, 17
 Feb 2022 17:27:33 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Feb 2022 17:27:33 -0800
MIME-Version: 1.0
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date:   Thu, 17 Feb 2022 17:27:33 -0800
Message-ID: <CAE-0n53cOFJFOOV-YOc0MzbiLr9FvaJw=ucs2SNNGOeznYzVLw@mail.gmail.com>
Subject: arm64 ftrace fixes for v5.4.y
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable maintainers,

I recently ran into an issue where trying to load a module with jump
table entries crashes the system when function tracing is enabled. The
crash happens because ftrace is modifying the code and then marking it
as read-only too early. ftrace_make_call() calls module_enable_ro(mod,
true) before module init is over because ftrace_module_enable() calls
__ftrace_replace_code() which does FTRACE_UPDATE_MAKE_CALL. All this
code is gone now upstream but is still present on v5.4 stable kernels. I
picked this set of patches to v5.4 and it fixed it for me.

fbf6c73c5b26 ftrace: add ftrace_init_nop()
a1326b17ac03 module/ftrace: handle patchable-function-entry
bd8b21d3dd66 arm64: module: rework special section handling
f1a54ae9af0d arm64: module/ftrace: intialize PLT at load time

after doing that I ran into another issue because I'm using clang. Would
it be possible to pick two more patches to the stable tree to silence
this module warning from sysfs complaining about
/module/<modname>/sections/__patchable_function_entries being
duplicated?

dd2776222abb kbuild: lto: merge module sections
6a3193cdd5e5 kbuild: lto: Merge module sections if and only if
CONFIG_LTO_CLANG is enabled

All of these apply cleanly to v5.4.y stable branch.

Crash below.

 Unable to handle kernel write to read-only memory at virtual address
ffffffd1b81fc0b0
 Mem abort info:
   ESR = 0x9600004f
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x0000004f
   CM = 0, WnR = 1
 swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000081bc1000
 [ffffffd1b81fc0b0] pgd=0000000271858003, pud=0000000271858003,
pmd=0000000266c05003, pte=00600001f3f4df93
 Internal error: Oops: 9600004f [#1] PREEMPT SMP
 Modules linked in: vsock(+) <a bunch more modules>
 CPU: 5 PID: 6254 Comm: modprobe Not tainted 5.4.177 #19
 Hardware name: Google Lazor (rev3 - 8) with KB Backlight (DT)
 pstate: 60400009 (nZCv daif +PAN -UAO)
 pc : jump_label_swap+0x2c/0x68
 lr : jump_label_swap+0x18/0x68
 sp : ffffffc01946bb10
 x29: ffffffc01946bb10 x28: 00000000000000b0
 x27: 0000000000000010 x26: 00000000000000b0
 x25: 00000000000001a0 x24: ffffffd1b81fc180
 x23: ffffffd2036540fc x22: ffffffd1b81fc000
 x21: 0000000000000010 x20: ffffffd1b81fc0b0
 x19: ffffffd1b81fc180 x18: 0000000000000000
 x17: ffffffd204006e08 x16: 0000000000006000
 x15: ffffffd1b8209000 x14: 0066ba79a6ffffff
 x13: 0000000000000004 x12: 000000004c55e4d8
 x11: 00000000ffffd9f0 x10: 00000000ffffd754
 x9 : ffffffffffffff30 x8 : 00000000ffffe2ec
 x7 : fefefefefefefefe x6 : 00000000000341d5
 x5 : ffffffd203654164 x4 : ffffffd2036540fc
 x3 : 0000000000000000 x2 : ffffffc01946bb30
 x1 : ffffffd203654110 x0 : 00000000fffffff0
 Call trace:
  jump_label_swap+0x2c/0x68
  do_swap+0x98/0xa0
  sort_r+0x178/0x1a0
  sort+0x14/0x1c
  jump_label_module_notify+0x7c/0x2c0
  notifier_call_chain+0x58/0x90
  __blocking_notifier_call_chain+0x58/0x84
  blocking_notifier_call_chain+0x38/0x48
  prepare_coming_module+0x30/0x3c
  load_module+0xda4/0xf8c
  __arm64_sys_finit_module+0xa4/0xdc
  el0_svc_common+0xb4/0x17c
  el0_svc_compat_handler+0x2c/0x58
  el0_svc_compat+0x8/0x2c
 Code: cb130289 29402e8a f940068c 4b090108 (b9000288)
