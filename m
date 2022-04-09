Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA434FA971
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 18:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242583AbiDIQNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 12:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242584AbiDIQM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 12:12:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374811B7BD
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 09:10:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C796D60B3D
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 16:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBC8C385A0;
        Sat,  9 Apr 2022 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649520651;
        bh=cTKL1F31CIQToQ35CYJ+AmCBp5bzWjT+VlcGvRQj/No=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxnlCFXtk9zeaf9ZZ6nB8dFp0ADFtPVQw76imtGsdqweqsO2DRWoJr7mjuPnkM5zT
         kZgoHN5KZrXCzFguO7/7LNf+j7akKyXPzjP9mK/5956Vl1gIQcBTv8P7HhDLBkU+9C
         R2jPLipbwSeXCpNGvdGB2fCIONQFr/fbKrNaC0FqDzUc/gEIQc8+WByN47mYxcrtNr
         +LNmmqALKHLNAGXCK6GeIorkDa6L4jw/ncrGgypoTO5vil/LASRjDU2EEFOpgO+Tu5
         9RVIoBxEFdhI1u60/o0w8OFO08f5cBnFmBUzSvH0Zn4lZHA3VABEBEyRIdxnBbA/t6
         ir3NBlr9QU6dw==
Date:   Sat, 9 Apr 2022 12:10:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>
Subject: Re: [stable:PATCH v5.4.188] KVM: arm64: Check
 arm64_get_bp_hardening_data() didn't return NULL
Message-ID: <YlGwCmQS6ud3Ezzx@sashalap>
References: <20220408172219.4152131-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220408172219.4152131-1-james.morse@arm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 08, 2022 at 06:22:19PM +0100, James Morse wrote:
>Will reports that with CONFIG_EXPERT=y and CONFIG_HARDEN_BRANCH_PREDICTOR=n,
>the kernel dereferences a NULL pointer during boot:
>
>[    2.384444] Internal error: Oops: 96000004 [#1] PREEMPT SMP
>[    2.384461] pstate: 20400085 (nzCv daIf +PAN -UAO)
>[    2.384472] pc : cpu_hyp_reinit+0x114/0x30c
>[    2.384476] lr : cpu_hyp_reinit+0x80/0x30c
>
>[    2.384529] Call trace:
>[    2.384533]  cpu_hyp_reinit+0x114/0x30c
>[    2.384537]  _kvm_arch_hardware_enable+0x30/0x54
>[    2.384541]  flush_smp_call_function_queue+0xe4/0x154
>[    2.384544]  generic_smp_call_function_single_interrupt+0x10/0x18
>[    2.384549]  ipi_handler+0x170/0x2b0
>[    2.384555]  handle_percpu_devid_fasteoi_ipi+0x120/0x1cc
>[    2.384560]  __handle_domain_irq+0x9c/0xf4
>[    2.384563]  gic_handle_irq+0x6c/0xe4
>[    2.384566]  el1_irq+0xf0/0x1c0
>[    2.384570]  arch_cpu_idle+0x28/0x44
>[    2.384574]  do_idle+0x100/0x2a8
>[    2.384577]  cpu_startup_entry+0x20/0x24
>[    2.384581]  secondary_start_kernel+0x1b0/0x1cc
>[    2.384589] Code: b9469d08 7100011f 540003ad 52800208 (f9400108)
>[    2.384600] ---[ end trace 266d08dbf96ff143 ]---
>[    2.385171] Kernel panic - not syncing: Fatal exception in interrupt
>
>In this configuration arm64_get_bp_hardening_data() returns NULL.
>Add a check in kvm_get_hyp_vector().
>
>Cc: Will Deacon <will@kernel.org>
>Link: https://lore.kernel.org/linux-arm-kernel/20220408120041.GB27685@willie-the-truck/
>Fixes: 26129ea2953b ("KVM: arm64: Add templates for BHB mitigation sequences")
>Cc: stable@vger.kernel.org # 5.4.x
>Signed-off-by: James Morse <james.morse@arm.com>

Queued up this and the 4.19 one, thanks!

-- 
Thanks,
Sasha
