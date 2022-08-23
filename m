Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7995B59D1F6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbiHWHZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiHWHZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:25:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773FE62A93;
        Tue, 23 Aug 2022 00:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 289A0B81BDB;
        Tue, 23 Aug 2022 07:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A338C433D6;
        Tue, 23 Aug 2022 07:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661239534;
        bh=58Xb+4i5V/oco9O7BavXUkLRRYHB+58DLbXicNZDwh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pjTr/Z6SvB4TmFzMxTfi4ZLz2yva0Pmx+Rx4GcRvdiO3jgYYYfnFpQxYAU9ieczXX
         uNjwd8sTRcPzn35myL47BwZ5xGyR1WQXMS9eyUrUQZVFA6/+6LmKYr4oZ50Ex+AvTd
         RresWZXixK4Wa+E2pudBmcywk+jdu6j/UYacXUSk=
Date:   Tue, 23 Aug 2022 09:25:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 5.10] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
Message-ID: <YwSA65p3f8kV8TEM@kroah.com>
References: <20220820050518.2118130-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820050518.2118130-1-pulehui@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 01:05:18PM +0800, Pu Lehui wrote:
> From: Tadeusz Struk <tadeusz.struk@linaro.org>
> 
> commit 4c46091ee985ae84c60c5e95055d779fcd291d87 upstream.
> 
> Syzbot found a Use After Free bug in compute_effective_progs().
> The reproducer creates a number of BPF links, and causes a fault
> injected alloc to fail, while calling bpf_link_detach on them.
> Link detach triggers the link to be freed by bpf_link_free(),
> which calls __cgroup_bpf_detach() and update_effective_progs().
> If the memory allocation in this function fails, the function restores
> the pointer to the bpf_cgroup_link on the cgroup list, but the memory
> gets freed just after it returns. After this, every subsequent call to
> update_effective_progs() causes this already deallocated pointer to be
> dereferenced in prog_list_length(), and triggers KASAN UAF error.
> 
> To fix this issue don't preserve the pointer to the prog or link in the
> list, but remove it and replace it with a dummy prog without shrinking
> the table. The subsequent call to __cgroup_bpf_detach() or
> __cgroup_bpf_detach() will correct it.
> 
> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
> Reported-by: <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Cc: <stable@vger.kernel.org>
> Link: https://syzkaller.appspot.com/bug?id=8ebf179a95c2a2670f7cf1ba62429ec044369db4
> Link: https://lore.kernel.org/bpf/20220517180420.87954-1-tadeusz.struk@linaro.org
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>  kernel/bpf/cgroup.c | 70 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 60 insertions(+), 10 deletions(-)

Now queued up, thanks.

greg k-h
