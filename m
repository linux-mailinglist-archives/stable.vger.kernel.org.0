Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1B14F2371
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 08:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiDEGjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 02:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiDEGjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 02:39:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87FB1A04A
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 23:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58CF1B80DA1
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 06:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AE0C340F3;
        Tue,  5 Apr 2022 06:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649140623;
        bh=xjmWFhZwdKgeESIC5wUxs/j9AAdBxaLwRIGhsZkQsXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kw9VLPd/HtA/5eZDSQBWd+aGbt42Y+/MEPqz0XBVBkwtlFJxrXstmNautfJbPDz35
         5gNasXnjyvg8HNL1sHmOQNjdeAN4dKonfuT/+ZD11f3+6hFuhXcmKzEzMGw3PFRa8T
         HdnVMVp8v4MaRpUOaAoFgcn1SuI/uNc53fUPUGO4=
Date:   Tue, 5 Apr 2022 08:36:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     keescook@chromium.org, willy@infradead.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] coredump: Use the vma snapshot in
 fill_files_note" failed to apply to 5.17-stable tree
Message-ID: <YkvjhziWC7iLShZ7@kroah.com>
References: <164889939941112@kroah.com>
 <87mth0kfe4.fsf@email.froward.int.ebiederm.org>
 <YkvikRzy2ahCbGV6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkvikRzy2ahCbGV6@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 08:32:49AM +0200, Greg KH wrote:
> On Mon, Apr 04, 2022 at 11:00:19AM -0500, Eric W. Biederman wrote:
> > <gregkh@linuxfoundation.org> writes:
> > 
> > > The patch below does not apply to the 5.17-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > I believe it requires backporting these first.
> > 
> > commit 84158b7f6a06 ("coredump: Also dump first pages of non-executable ELF libraries")
> > commit 95c5436a4883 ("coredump: Snapshot the vmas in do_coredump")
> > commit 49c1866348f3 ("coredump: Remove the WARN_ON in dump_vma_snapshot")
> > 
> > The first is a more interesting bug fix from Jann Horn.
> > The other two are prerequisite cleanup-patches.
> 
> Thanks, that worked!

Nope, also had to add 9ec7d3230717 ("coredump/elf: Pass coredump_params into fill_note_info")

