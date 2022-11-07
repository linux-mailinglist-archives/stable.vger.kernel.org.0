Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731F761F77F
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiKGPX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiKGPXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:23:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582D0CD9;
        Mon,  7 Nov 2022 07:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4vgRGnuVtkTGEKsFjUHCzmRGxBEch8B2PbVdx00wfIY=; b=r4KpmD8YQg8XB7hbcAadnPrE6n
        jwfLNXaVezrfXQi1O1mdc+6ow3TXholNpOy0J4rqHFRyl2Ty5kq35FtNMUIfir/x8qCdnt4q7vf1H
        uq/Iu1Z5luOhf/DKVmfEA9RFMvRIY4jE6WJ4otVcaUj0TCHzpCe8RIf0PHf73ju3bzwJ2k2MBBV+L
        m5vqNMv/b+hVsIVuKHOA3bgtEaudnRJBjdm4baPQN3WYwG7B6JBfpuaaPiBhsgCcrzhcBIMQTyx/0
        OGNTa4lCru3Jc5RLzKQvXgyLtCXLnD6GAmB+GKO27jX3LAuu3lMDDITO/dPfhyVfAcSAjm4MCwo7Q
        +xhekxJA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1os3y2-009SXw-B1; Mon, 07 Nov 2022 15:23:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A69EE30007E;
        Mon,  7 Nov 2022 16:23:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8F2942B8046C9; Mon,  7 Nov 2022 16:23:12 +0100 (CET)
Date:   Mon, 7 Nov 2022 16:23:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, jmattson@google.com, seanjc@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4/8] KVM: SVM: move guest vmsave/vmload to assembly
Message-ID: <Y2ki4Iz8AZzTODKS@hirez.programming.kicks-ass.net>
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107145436.276079-5-pbonzini@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 09:54:32AM -0500, Paolo Bonzini wrote:
> @@ -56,6 +59,16 @@ SYM_FUNC_START(__svm_vcpu_run)
>  	/* Move @svm to RDI. */
>  	mov %_ASM_ARG2, %_ASM_DI
>  
> +	/*
> +	 * Use a single vmcb (vmcb01 because it's always valid) for
> +	 * context switching guest state via VMLOAD/VMSAVE, that way
> +	 * the state doesn't need to be copied between vmcb01 and
> +	 * vmcb02 when switching vmcbs for nested virtualization.
> +	 */
> +	mov SVM_vmcb01_pa(%_ASM_DI), %_ASM_AX
> +1:	vmload %_ASM_AX
> +2:
> +
>  	/* "POP" @vmcb to RAX. */
>  	pop %_ASM_AX
>  
> @@ -80,16 +93,11 @@ SYM_FUNC_START(__svm_vcpu_run)
>  	/* Enter guest mode */
>  	sti
>  
> +3:	vmrun %_ASM_AX
> +4:
> +	cli
>  
> +	/* Pop @svm to RAX while it's the only available register. */
>  	pop %_ASM_AX
>  
>  	/* Save all guest registers.  */

So Andrew noted that once the vmload has executed any exception taken
(say at 3) will crash and burn because %gs is scribbled.

Might be good to make a record of this in the code so it can be cleaned
up some day.

> @@ -159,11 +179,19 @@ SYM_FUNC_START(__svm_vcpu_run)
>  	pop %_ASM_BP
>  	RET
>  
> +10:	cmpb $0, kvm_rebooting
>  	jne 2b
>  	ud2
> +30:	cmpb $0, kvm_rebooting
> +	jne 4b
> +	ud2
> +50:	cmpb $0, kvm_rebooting
> +	jne 6b
> +	ud2
>  
> +	_ASM_EXTABLE(1b, 10b)
> +	_ASM_EXTABLE(3b, 30b)
> +	_ASM_EXTABLE(5b, 50b)
