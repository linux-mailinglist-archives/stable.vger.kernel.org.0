Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D227B6A41E2
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 13:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjB0MoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 07:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0MoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 07:44:22 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3A31E29C;
        Mon, 27 Feb 2023 04:44:21 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 600616244DF88;
        Mon, 27 Feb 2023 13:44:17 +0100 (CET)
Message-ID: <f6b073ce-6d78-f00f-9f6d-499df4bb6255@molgen.mpg.de>
Date:   Mon, 27 Feb 2023 13:44:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     =?UTF-8?Q?Thomas_Wei=c3=9fschuh?= <linux@weissschuh.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Please backport commit a449dfbfc089 (PM: sleep: Avoid using pr_cont()
 in the tasks freezing code)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Linux folks,


It’d be great if you could apply the commit below [1], present in Linux 
since 6.2-rc1, to at least the Linux 6.1 LTS series.

commit a449dfbfc0894676ad0aa1873383265047529e3a
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu Dec 1 19:33:09 2022 +0100

     PM: sleep: Avoid using pr_cont() in the tasks freezing code

     Using pr_cont() in the tasks freezing code related to system-wide
     suspend and hibernation is problematic, because the continuation
     messages printed there are susceptible to interspersing with other
     unrelated messages which results in output that is hard to
     understand.

     Address this issue by modifying try_to_freeze_tasks() to print
     messages that don't require continuations and adjusting its
     callers accordingly.

     Reported-by: Thomas Weißschuh <linux@weissschuh.net>
     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
     Reviewed-by: Petr Mladek <pmladek@suse.com>

On a Dell Precision 3540, Linux 6.1.12 from Debian sid/unstable logs the 
stray warning below:

     $ sudo dmesg --level=warn | grep elapsed
     [ 3063.289579] (elapsed 0.047 seconds) done.

It’s due to `pr_cont` usage, and the another (DRM) log message adds the 
unexpected newline character, splitting the message:

     [    0.000000] Linux version 6.1.0-5-amd64 
(debian-kernel@lists.debian.org) (gcc-12 (Debian 12.2.0-14) 12.2.0, GNU 
ld (GNU Binutils for Debian) 2.40) #1 SMP PREEMPT_DYNAMIC Debian 
6.1.12-1 (2023-02-15)
     […]
     [    0.000000] DMI: Dell Inc. Precision 3540/0M14W7, BIOS 1.23.0 
12/19/2022
     […]
     [ 3063.241846] Freezing user space processes ...
     [ 3063.281999] [drm] VCE initialized successfully.
     [ 3063.289579] (elapsed 0.047 seconds) done.

Backporting the patch would change the log messages a little though. No 
idea, if that is acceptable for commit for stable series.


Kind regards,

Paul


[1]: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a449dfbfc0894676ad0aa1873383265047529e3a
