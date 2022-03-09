Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E185D4D2A3F
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 09:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiCIIDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 03:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiCIIDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 03:03:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F45314CC97;
        Wed,  9 Mar 2022 00:02:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0792EB81EA0;
        Wed,  9 Mar 2022 08:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A102C340E8;
        Wed,  9 Mar 2022 08:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646812921;
        bh=Cfr19P9SP1R7zJ9J1a4BDOPpbOGBYdEhzLA2WG9WWJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=isNV1LXjqaCsYQBMI6d599yCQUTKjNX37a/8sc2iAFHN5pNR0NL/RrsEgRPeLsiit
         9D40wPq76w4owzq/8nK6bmcyY8woCl02YeKNNrvYZQrqKQ/hdJYnfWant+LdvnX31F
         T2VBiMwCFaN7saoRuAcYM6HSQws04TUwJccPzEm/N0LdRHs0usa9mZ56fWB4qQLyH0
         j5jgLnTzrxvxbBxJ4Rln9iBEcVaZQtAQTXce4YH7GN/xXpq3aLv27dFHSYaWAh5zuG
         OTNhJjgN6O51RBOlk9KbOHVAWLAl16qDD9NcLAqKjoTBalSR3yG15fJj+Eil3iU5n/
         Huud267loJ3EQ==
Date:   Wed, 9 Mar 2022 10:01:17 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YihezQsQca0RBuxT@iki.fi>
References: <20220303223859.273187-1-jarkko@kernel.org>
 <d476aa51-f855-bfb8-0738-3190439a2f72@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d476aa51-f855-bfb8-0738-3190439a2f72@intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 11:16:19AM -0800, Reinette Chatre wrote:
> Hi,
> 
> On 3/3/2022 2:38 PM, Jarkko Sakkinen wrote:
> > There is a limited amount of SGX memory (EPC) on each system.  When that
> > memory is used up, SGX has its own swapping mechanism which is similar
> > in concept but totally separate from the core mm/* code.  Instead of
> > swapping to disk, SGX swaps from EPC to normal RAM.  That normal RAM
> > comes from a shared memory pseudo-file and can itself be swapped by the
> > core mm code.  There is a hierarchy like this:
> > 
> > 	EPC <-> shmem <-> disk
> > 
> > After data is swapped back in from shmem to EPC, the shmem backing
> > storage needs to be freed.  Currently, the backing shmem is not freed.
> > This effectively wastes the shmem while the enclave is running.  The
> > memory is recovered when the enclave is destroyed and the backing
> > storage freed.
> > 
> > Sort this out by freeing memory with shmem_truncate_range(), as soon as
> > a page is faulted back to the EPC.  In addition, free the memory for
> > PCMD pages as soon as all PCMD's in a page have been marked as unused
> > by zeroing its contents.
> > 
> > Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> I can reliably reproduce the issue this patch aims to solve by creating
> a virtual machine that has a significant portion of its memory consumed
> by EPC:
> 
> qemu-system-x86_64 -smp 4 -m 4G\
>  -enable-kvm \
>  -cpu host,+sgx-provisionkey \
>  -object memory-backend-ram,size=2G,host-nodes=0,policy=bind,id=node0 \
>  -object memory-backend-epc,id=mem0,size=1536M,prealloc=on,host-nodes=0,policy=bind \
>  -numa node,nodeid=0,cpus=0-1,memdev=node0 \
>  -object memory-backend-ram,size=2G,host-nodes=1,policy=bind,id=node1 \
>  -object memory-backend-epc,id=mem1,size=1536M,prealloc=on,host-nodes=1,policy=bind \
>  -numa node,nodeid=1,cpus=2-3,memdev=node1 \
>  -M sgx-epc.0.memdev=mem0,sgx-epc.0.node=0,sgx-epc.1.memdev=mem1,sgx-epc.1.node=1 \
>  ...
> 
> Before this patch, running the very stressful SGX2 over subscription test case
> (unclobbered_vdso_oversubscribed_remove) in this environment always triggers 
> the oom-killer but no amount of tasks killed can save the system
> with it always ending deadlocked on memory:
> 
> [   58.642719] Tasks state (memory values in pages):
> [   58.644324] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
> [   58.647237] [    195]     0   195     3153      197    45056        0         -1000 systemd-udevd
> [   58.650238] [    281]     0   281  1836367        0 10817536        0             0 test_sgx
> [   58.653088] Out of memory and no killable processes...
> [   58.654832] Kernel panic - not syncing: System is deadlocked on memory
> 
> After applying this patch I was able to run SGX2 selftest
> unclobbered_vdso_oversubscribed_remove ten times successfully.
> 
> Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you.

> Reinette


BR, Jarkko
