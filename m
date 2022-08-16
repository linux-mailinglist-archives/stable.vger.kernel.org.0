Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2801259613A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 19:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbiHPReu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 13:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236477AbiHPRes (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 13:34:48 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670F1659E7;
        Tue, 16 Aug 2022 10:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660671283; x=1692207283;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=18C6ARl9ap+Cedl7PD7j87s90Sel1myV+oWO8N8wL14=;
  b=JzD2Y8WQRdHeJ1+Ux0KLdV16tmT5vmbkRR+hh4/VXM9OFujkPlZW2NaZ
   TS6JQB3ap9njzyhr/TR56xSpt+bx9WJCTUQHR+P64FkUyEUesPKJtE/f/
   Qhl3Xq1lU2ObQctovMFTCRiZHJSDsb8hVxce9/gwviU8hfv7PAfqucDw/
   0YQJw6ffVVgJStvFpcNRvPPSZ0qg7qqjKYWEs/6ChqwJqZEeHkjjjzaJf
   tSZRIbESxJ0SECxpeneRyzub+NumDNSs668ifW7RvOzSaqR6dRk7izBKY
   OaB63Pn11v1iZY0PRkJxlMTSH2kVuWVB/V5DXM2pp5za046T4IcYy0Kqo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="272675962"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="272675962"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 10:34:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="852730709"
Received: from jzhu1-mobl.ccr.corp.intel.com (HELO [10.254.68.75]) ([10.254.68.75])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 10:34:42 -0700
Message-ID: <839e2877-bb16-dbb5-d4da-bc611733c7e1@linux.intel.com>
Date:   Tue, 16 Aug 2022 10:34:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
From:   Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
In-Reply-To: <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/22 05:28, Peter Zijlstra wrote:

> 
> Could you please test this; I've only compiled it.
> 
When booting I get the following BUG:

------------[ cut here ]------------
kernel BUG at arch/x86/kernel/alternative.c:290!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.0.0-rc1-00001-gb72b03c96999 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1
04/01/2014
RIP: 0010:apply_alternatives+0x287/0x2d0
Code: 4c 29 f6 03 74 24 13 89 74 24 13 45 85 c0 0f 85 d2 41 e9 00 41 0f b6 02 83
e0 fd 3c e9 0f 84 46 ff ff ff e9 5e fe ff ff 0f 0b <0f> 0b f7 c6 00 ff ff ff 0f
84 68 ff ff ff 8d 71 fb c6 44 24 12 e9
RSP: 0000:ffffffff82c03d68 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffffffff83728c24 RCX: 0000000000007fff
RDX: 00000000ffffffea RSI: 0000000000000000 RDI: 000000000000ffff
RBP: ffffffff82c03d7a R08: e800000010c4c749 R09: 0001e8cc00000001
R10: 10c48348cc000000 R11: e8ae0feb75ccff49 R12: ffffffff8372fcf8
R13: 0000000000000000 R14: ffffffff81001a68 R15: 000000000000001f
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 0000000002c0c001 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? insn_get_opcode+0xef/0x1c0
 ? ct_nmi_enter+0xb3/0x180
 ? ct_nmi_exit+0xbe/0x1d0
 ? irqentry_exit+0x2d/0x40
 ? asm_common_interrupt+0x22/0x40
 alternative_instructions+0x5b/0xf5
 check_bugs+0xdaf/0xdef
 start_kernel+0x66a/0x6a2
 secondary_startup_64_no_verify+0xe0/0xeb
 </TASK>
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace 0000000000000000 ]---
RIP: 0010:apply_alternatives+0x287/0x2d0
Code: 4c 29 f6 03 74 24 13 89 74 24 13 45 85 c0 0f 85 d2 41 e9 00 41 0f b6 02 83
e0 fd 3c e9 0f 84 46 ff ff ff e9 5e fe ff ff 0f 0b <0f> 0b f7 c6 00 ff ff ff 0f
84 68 ff ff ff 8d 71 fb c6 44 24 12 e9
RSP: 0000:ffffffff82c03d68 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffffffff83728c24 RCX: 0000000000007fff
RDX: 00000000ffffffea RSI: 0000000000000000 RDI: 000000000000ffff
RBP: ffffffff82c03d7a R08: e800000010c4c749 R09: 0001e8cc00000001
R10: 10c48348cc000000 R11: e8ae0feb75ccff49 R12: ffffffff8372fcf8
R13: 0000000000000000 R14: ffffffff81001a68 R15: 000000000000001f
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 0000000002c0c001 CR4: 0000000000770ef0
PKRU: 55555554
Kernel panic - not syncing: Attempted to kill the idle task!
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---



