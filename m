Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45B86EAEA7
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjDUQEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 12:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjDUQEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 12:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527B1D32A;
        Fri, 21 Apr 2023 09:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE837619FD;
        Fri, 21 Apr 2023 16:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414FFC433D2;
        Fri, 21 Apr 2023 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682093046;
        bh=XKlPr6uDvxCV6++QaXDCvxgmIhxfSV6g1aBX1EDd6/E=;
        h=From:To:Cc:Subject:Date:From;
        b=YvOY8ukU7+89A+/bW+xfR21Kl2zYpreIqu7qiwMDDw3oP3guG1sgT4M4ee/cPip2V
         bVmW+VAswwC5z2Tpo/QrUcc94O/lM9rs7HsK5WX4AEfIpJWzG8o8zs4OFg9v379omw
         0GNTrq8WF7O991DEV5vXmnLqjgmR2Y5KHgd+MAPG0/CM7qtZNKHPpJpDXrfVuGQA9r
         EiOrlGeh1s8ljzG5pAY0oJRc+QjqtXcmeMZ147lcMcO15CZrMVSHC6edPyYwDjv8tO
         rzp5ozZ29BJN9derrw+IuZWJa8aA02dB+ccKn5yRzqqCaG/Mo3HjSQmAWEVM4/YHiZ
         JrAJYWp0s5Q1g==
From:   broonie@kernel.org
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the tip tree
Date:   Fri, 21 Apr 2023 17:03:53 +0100
Message-Id: <20230421160353.106874-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

After merging the tip tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

/tmp/next/build/kernel/time/posix-cpu-timers.c: In function 'posix_cpu_timer_wait_running_nsleep':
/tmp/next/build/kernel/time/posix-cpu-timers.c:1310:30: error: 'timr' is a pointer; did you mean to use '->'?
 1310 |         spin_unlock_irq(&timr.it_lock);
      |                              ^
      |                              ->
/tmp/next/build/kernel/time/posix-cpu-timers.c:1312:28: error: 'timr' is a pointer; did you mean to use '->'?
 1312 |         spin_lock_irq(&timr.it_lock);
      |                            ^
      |                            ->


Caused by commit

  2aaae4bf41b101f7e ("posix-cpu-timers: Implement the missing timer_wait_running callback")

The !POSIX_CPU_TIMERS_TASK_WORK case wasn't fully updated.  I've used
the version of the tip tree from next-20230420 instead.
