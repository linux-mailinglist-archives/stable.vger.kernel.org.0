Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BC256531B
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiGDLOj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 4 Jul 2022 07:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiGDLOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:14:39 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2737DFD39
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:14:37 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lc39R2Lm4z4xLX;
        Mon,  4 Jul 2022 21:14:35 +1000 (AEST)
Date:   Mon, 04 Jul 2022 21:14:32 +1000
From:   Michael Ellerman <michael@ellerman.id.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sachin Sant <sachinp@linux.ibm.com>, benh@kernel.crashing.org,
        paulus@samba.org
CC:     linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_powerpc/powernv=3A_delay_rn?= =?US-ASCII?Q?g_of_node_creation_until_later_in_boot?=
User-Agent: K-9 Mail for Android
In-Reply-To: <YsAg/hixHvdxnWNL@zx2c4.com>
References: <Yr2PQSZWVtr+Y7a2@zx2c4.com> <20220630121654.1939181-1-Jason@zx2c4.com> <8A9A296D-D7BD-42BE-AB32-C951C29E4C40@linux.ibm.com> <YsAg/hixHvdxnWNL@zx2c4.com>
Message-ID: <2B9FC5ED-D6B8-4632-ACA4-7CF508EE9C46@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2 July 2022 8:42:06 pm AEST, "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>Hi Benjamin, Paul,
>
>On Thu, Jun 30, 2022 at 07:24:05PM +0530, Sachin Sant wrote:
>> > On 30-Jun-2022, at 5:46 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> > 
>> > The of node for the rng must be created much later in boot. Otherwise it
>> > tries to connect to a parent that doesn't yet exist, resulting on this
>> > splat:
>> > 
>> > [    0.000478] kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_get() is being called.
>> > [    0.002925] [c000000002a0fb30] [c00000000073b0bc] kobject_get+0x8c/0x100 (unreliable)
>> > [    0.003071] [c000000002a0fba0] [c00000000087e464] device_add+0xf4/0xb00
>> > [    0.003194] [c000000002a0fc80] [c000000000a7f6e4] of_device_add+0x64/0x80
>> > [    0.003321] [c000000002a0fcb0] [c000000000a800d0] of_platform_device_create_pdata+0xd0/0x1b0
>> > [    0.003476] [c000000002a0fd00] [c00000000201fa44] pnv_get_random_long_early+0x240/0x2e4
>> > [    0.003623] [c000000002a0fe20] [c000000002060c38] random_init+0xc0/0x214
>> > 
>> > This patch fixes the issue by doing the of node creation inside of
>> > machine_subsys_initcall.
>> > 
>> > Fixes: f3eac426657d ("powerpc/powernv: wire up rng during setup_arch")
>> > Cc: stable@vger.kernel.org
>> > Cc: Michael Ellerman <mpe@ellerman.id.au>
>> > Reported-by: Sachin Sant <sachinp@linux.ibm.com>
>> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> > ---
>> 
>> Thanks Jason for the patch. This fixes the reported problem for me.
>> 
>> Tested-by: Sachin Sant <sachinp@linux.ibm.com>
>> 
>> - Sachin
>
>It sounds like Michael is on vacation for a few weeks. Think you could
>queue this up so we can get POWER8 booting again?

It doesn't break booting for me, but it is an ugly splat.

I'll pick it up into fixes.

I think it's more correct to say the "platform device creation" causes the problem, so I'll update the change log to say that.

cheers
