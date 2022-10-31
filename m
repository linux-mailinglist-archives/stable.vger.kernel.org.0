Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4257612F6D
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 05:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJaEHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 00:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJaEHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 00:07:53 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249567667;
        Sun, 30 Oct 2022 21:07:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=guorui.yu@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0VTPBsm8_1667189266;
Received: from 30.221.131.65(mailfrom:GuoRui.Yu@linux.alibaba.com fp:SMTPD_---0VTPBsm8_1667189266)
          by smtp.aliyun-inc.com;
          Mon, 31 Oct 2022 12:07:48 +0800
Message-ID: <b5d04a6c-79b4-bbdc-b613-6958d9f75d53@linux.alibaba.com>
Date:   Mon, 31 Oct 2022 12:07:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
To:     kirill.shutemov@linux.intel.com
Cc:     ak@linux.intel.com, bp@alien8.de, dan.j.williams@intel.com,
        dave.hansen@intel.com, david@redhat.com, elena.reshetova@intel.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@kernel.org,
        mingo@redhat.com, peterz@infradead.org,
        sathyanarayanan.kuppuswamy@linux.intel.com, seanjc@google.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, x86@kernel.org
References: <20221028141220.29217-3-kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 2/2] x86/tdx: Do not allow #VE due to EPT violation on the
 private memory
From:   Guorui Yu <GuoRui.Yu@linux.alibaba.com>
In-Reply-To: <20221028141220.29217-3-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The core of this vulnerability is not directly related to the 
ATTR_SEPT_VE_DISABLE, but the MMIO processing logic in #VE.

We have encountered similar problems on SEV-ES, here are their fixes on 
Kernel [1] and OVMF[2].

Instead of enforcing the ATTR_SEPT_VE_DISABLE in TDX guest kernel, I 
think the fix should also include necessary check on the MMIO path of 
the #VE routine.

static int handle_mmio(struct pt_regs *regs, struct ve_info *ve)
{
	unsigned long *reg, val, vaddr;
	char buffer[MAX_INSN_SIZE];
	struct insn insn = {};
	enum mmio_type mmio;
	int size, extend_size;
	u8 extend_val = 0;

	// Some addtional security check about ve->gpa should be introduced here.

	/* Only in-kernel MMIO is supported */
	if (WARN_ON_ONCE(user_mode(regs)))
		return -EFAULT;

	// ...
}

If we don't fix the problem at the point where we found, but rely on 
complicated composite logic and long comments in the kernel, I'm 
confident we'll fall back into the same pit in the near future :).


[1] 
https://github.com/torvalds/linux/blob/1a2dcbdde82e3a5f1db9b2f4c48aa1aeba534fb2/arch/x86/kernel/sev.c#L503
[2] OVMF: 
https://github.com/tianocore/edk2/blob/db2c22633f3c761975d8f469a0e195d8b79e1287/OvmfPkg/Library/VmgExitLib/VmgExitVcHandler.c#L670
