Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED35C4F2277
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 07:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiDEFOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 01:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiDEFOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 01:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AD3311;
        Mon,  4 Apr 2022 22:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3321E614A9;
        Tue,  5 Apr 2022 05:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432C9C340F0;
        Tue,  5 Apr 2022 05:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649135521;
        bh=iIo+zn0pj52zOFFjMSyQhxTcFA5tdRReaLN/oRTDT28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tDXJAzwrF2zWBJHgbCM1pgN6QUq3umuEMADLIz52ETyZwPEDosIUBjvC2b0qm8JEg
         0gYuX3lcku22/nCUOpy+TimECUFN5V6lWt7UO4RvvsECsVraPrFQvLm0XTvEtMYNfe
         Lj3RFsPntssa1rsMaXDai74CekKdklQPTT0KjyYs=
Date:   Tue, 5 Apr 2022 07:11:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Qiuhao Li <qiuhao@sysec.org>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 5.4 v2] KVM: x86/mmu: do compare-and-exchange of gPTE via
 the user address
Message-ID: <YkvPn6uWte2YEEbF@kroah.com>
References: <20220404154913.482520-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404154913.482520-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 11:49:13AM -0400, Paolo Bonzini wrote:
> commit 2a8859f373b0a86f0ece8ec8312607eacf12485d upstream.
> 
> FNAME(cmpxchg_gpte) is an inefficient mess.  It is at least decent if it
> can go through get_user_pages_fast(), but if it cannot then it tries to
> use memremap(); that is not just terribly slow, it is also wrong because
> it assumes that the VM_PFNMAP VMA is contiguous.
> 
> The right way to do it would be to do the same thing as
> hva_to_pfn_remapped() does since commit add6a0cd1c5b ("KVM: MMU: try to
> fix up page faults before giving up", 2016-07-05), using follow_pte()
> and fixup_user_fault() to determine the correct address to use for
> memremap().  To do this, one could for example extract hva_to_pfn()
> for use outside virt/kvm/kvm_main.c.  But really there is no reason to
> do that either, because there is already a perfectly valid address to
> do the cmpxchg() on, only it is a userspace address.  That means doing
> user_access_begin()/user_access_end() and writing the code in assembly
> to handle any exception correctly.  Worse, the guest PTE can be 8-byte
> even on i686 so there is the extra complication of using cmpxchg8b to
> account for.  But at least it is an efficient mess.
> 
> Reported-by: Qiuhao Li <qiuhao@sysec.org>
> Reported-by: Gaoning Pan <pgn@zju.edu.cn>
> Reported-by: Yongkang Jia <kangel@zju.edu.cn>
> Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
> Debugged-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/paging_tmpl.h | 77 ++++++++++++++++++--------------------
>  1 file changed, 37 insertions(+), 40 deletions(-)

Thanks for the fix, now queued up.

greg k-h
