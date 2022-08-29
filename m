Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDFC5A5599
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 22:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiH2Ue6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 16:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiH2Ue5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 16:34:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235591CB34;
        Mon, 29 Aug 2022 13:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6561B81211;
        Mon, 29 Aug 2022 20:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EEAC433D6;
        Mon, 29 Aug 2022 20:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661805293;
        bh=JdpTsh0vpLzXYFuVgPaN22fxCzf3es58W6ZxtaLnGJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W98aFR9L/yVMMf3iotWWAjyF8BnjSlCM3x5mH4GwSvEWlNp4ZivZ3+WKFui043hcI
         f65XvSDXEL/OrQMwaFn6CnHqm4sw3BebP9jZfsM1NjloVIo666eZW3wkBIoKcHK2WG
         qi0DsjDdyPw2OBNGUMxX3ddTC8XRZ8qJqx2S7Ax8=
Date:   Mon, 29 Aug 2022 13:34:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q? "Arve_?= =?ISO-8859-1?Q?Hj=F8nnev=E5g" ?= 
        <arve@android.com>, Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        kernel-team@android.com,
        syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com,
        syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com,
        stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] binder: fix alloc->vma_vm_mm null-ptr dereference
Message-Id: <20220829133452.cd4d9abe858c940126557c41@linux-foundation.org>
In-Reply-To: <20220829201254.1814484-2-cmllamas@google.com>
References: <20220829201254.1814484-1-cmllamas@google.com>
        <20220829201254.1814484-2-cmllamas@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Aug 2022 20:12:48 +0000 Carlos Llamas <cmllamas@google.com> wrote:

> Syzbot reported a couple issues introduced by commit 44e602b4e52f
> ("binder_alloc: add missing mmap_lock calls when using the VMA"), in
> which we attempt to acquire the mmap_lock when alloc->vma_vm_mm has not
> been initialized yet.
> 
> This can happen if a binder_proc receives a transaction without having
> previously called mmap() to setup the binder_proc->alloc space in [1].
> Also, a similar issue occurs via binder_alloc_print_pages() when we try
> to dump the debugfs binder stats file in [2].

Thanks.  I assume you'll be merging all these into mainline?

> 
> Fixes: 44e602b4e52f ("binder_alloc: add missing mmap_lock calls when using the VMA")
> Reported-by: syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com
> Reported-by: syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org> # v5.15+

44e602b4e52f is only present in 6.0-rcX?


