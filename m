Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8139A4F2327
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 08:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiDEGew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 02:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiDEGeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 02:34:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F74B33E04
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 23:32:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7CF961546
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 06:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FE7C3410F;
        Tue,  5 Apr 2022 06:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649140372;
        bh=43n+ni7kKRY1bmDaCKMu6Ap+2qrnoegtyr73P86V5fs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qDIv4U+S/vxXsS6d6R8bQOdLhO2wDpfCvdmefTXiO1ycPLjxqBoAOSeFPdrctDTuN
         HL4dGhgOi8gmsnqBklbyu8IJvSsNguixbuX5i716ScKEJJboJ4YEeXlDo3IbcID/1C
         SCiLGVMlQnI9UiK7ax1cWQECIbm79TAjTuL6AdMM=
Date:   Tue, 5 Apr 2022 08:32:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     keescook@chromium.org, willy@infradead.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] coredump: Use the vma snapshot in
 fill_files_note" failed to apply to 5.17-stable tree
Message-ID: <YkvikRzy2ahCbGV6@kroah.com>
References: <164889939941112@kroah.com>
 <87mth0kfe4.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mth0kfe4.fsf@email.froward.int.ebiederm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 11:00:19AM -0500, Eric W. Biederman wrote:
> <gregkh@linuxfoundation.org> writes:
> 
> > The patch below does not apply to the 5.17-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I believe it requires backporting these first.
> 
> commit 84158b7f6a06 ("coredump: Also dump first pages of non-executable ELF libraries")
> commit 95c5436a4883 ("coredump: Snapshot the vmas in do_coredump")
> commit 49c1866348f3 ("coredump: Remove the WARN_ON in dump_vma_snapshot")
> 
> The first is a more interesting bug fix from Jann Horn.
> The other two are prerequisite cleanup-patches.

Thanks, that worked!

> I will let other folks judge how concerned they are about missing
> locking that was detected by code review.

locking where?  And if it's not resolved in Linus's tree yet, not much I
can do.

Also, what about for kernels older than 5.10?  Is this an issue there?

thanks,

greg k-h
