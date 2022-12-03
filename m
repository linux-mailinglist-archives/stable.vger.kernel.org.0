Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402876416E3
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiLCNaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLCNaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:30:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013601CB31
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 05:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9219A6023A
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96441C433D6;
        Sat,  3 Dec 2022 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670074212;
        bh=XRj6uRydS5XxCpNK24g1+ZcN77BC+fmnbiHNaLsvDjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xYcrPeixpCKYIHpTltZkKEAubCf1f1QWg91bzBsus6t1w7f2xHEm9vm0SIe2QJTTl
         Flgkvpt0+OyB4JAUHgpVHkXHyLOqmpLZ6oolDNR7YEQezifp7spfsQnmoyuVKIqLFA
         NOPirSaPk6XZ/7epAB8u/nqEqmh7EC4DhD4sOfno=
Date:   Sat, 3 Dec 2022 14:30:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.15] KVM: x86/mmu: Fix race condition in
 direct_page_fault
Message-ID: <Y4tPYlDA4tMEuPwk@kroah.com>
References: <20221202030843.1777127-1-takiguchi.kazuki171@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202030843.1777127-1-takiguchi.kazuki171@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 12:08:46PM +0900, Kazuki Takiguchi wrote:
> commit 47b0c2e4c220f2251fd8dcfbb44479819c715e15 upstream.
> 
> make_mmu_pages_available() must be called with mmu_lock held for write.
> However, if the TDP MMU is used, it will be called with mmu_lock held for
> read.
> This function does nothing unless shadow pages are used, so there is no
> race unless nested TDP is used.
> Since nested TDP uses shadow pages, old shadow pages may be zapped by this
> function even when the TDP MMU is enabled.
> Since shadow pages are never allocated by kvm_tdp_mmu_map(), a race
> condition can be avoided by not calling make_mmu_pages_available() if the
> TDP MMU is currently in use.
> 
> I encountered this when repeatedly starting and stopping nested VM.
> It can be artificially caused by allocating a large number of nested TDP
> SPTEs.

Now queued up, thanks.

greg k-h
