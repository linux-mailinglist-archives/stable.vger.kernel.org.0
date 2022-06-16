Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB57C54E17D
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376803AbiFPNJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiFPNJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:09:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2E219C3B;
        Thu, 16 Jun 2022 06:09:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F2DFB823C1;
        Thu, 16 Jun 2022 13:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40122C34114;
        Thu, 16 Jun 2022 13:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655384966;
        bh=Kam1VOX7GHS0BIUZI+qpskgubDpSDvYDQZeqTMNfquw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nyg3vhxQP8VNzQQZOB8vXfSkTz4QqHxZ7sl1DeggFPiV8472Nk8tSCqgOPGBISN9T
         ld/DMAm4+To74v4L2l10BAE8LgzCFMsCphQ+KUsQrc0+k6EW7eaTGMObY4KsmY472h
         lY/fGKpbEHWp58ntnepgNXqQYWhPiWAY1dBXGpG0=
Date:   Thu, 16 Jun 2022 15:09:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     daniel@iogearbox.net, linux-kernel@vger.kernel.org, pavel@denx.de,
        sashal@kernel.org, stable@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] bpf: Fix incorrect memory charge cost calculation in
 stack_map_alloc()
Message-ID: <YqsrhAgihc0EjzIC@kroah.com>
References: <YqbunqapIFiIVqOb@kroah.com>
 <20220614142622.998611-1-ytcoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614142622.998611-1-ytcoode@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 10:26:22PM +0800, Yuntao Wang wrote:
> commit b45043192b3e481304062938a6561da2ceea46a6 upstream.
> 
> This is a backport of the original upstream patch for 5.4/5.10.
> 
> The original upstream patch has been applied to 5.4/5.10 branches, which
> simply removed the line:
> 
>   cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
> 
> This is correct for upstream branch but incorrect for 5.4/5.10 branches,
> as the 5.4/5.10 branches do not have the commit 370868107bf6 ("bpf:
> Eliminate rlimit-based memory accounting for stackmap maps"), so the
> bpf_map_charge_init() function has not been removed.
> 
> Currently the bpf_map_charge_init() function in 5.4/5.10 branches takes a
> wrong memory charge cost, the
> 
>   attr->max_entries * (sizeof(struct stack_map_bucket) + (u64)value_size))
> 
> part is missing, let's fix it.
> 
> Cc: <stable@vger.kernel.org> # 5.4.y
> Cc: <stable@vger.kernel.org> # 5.10.y
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
> Note that the original upstream patch is currently applied to
> linux-stable-rc/linux-5.4.y branch, not linux/linux-5.4.y, this patch
> depends on that patch.

Now queued up, thanks.

greg k-h
