Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5477E679D75
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbjAXP21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjAXP2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:28:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AD41A96D;
        Tue, 24 Jan 2023 07:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFFF6612CF;
        Tue, 24 Jan 2023 15:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934D3C433D2;
        Tue, 24 Jan 2023 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674574097;
        bh=DFV2/9gj6sPEo6k2DtJ6ywijKdwcFb8PC1ifLycfAFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1tgPOElY70AjKYefZZ3RvfK47hsmQEB/T1V2sauA4iCGt321FSN4QO4E2DfQ38UhA
         CnQDFsiYJPkrsutVqOt7ARcFe+xCBu0X7wJZDMz6FDXFpqQSFCip/myisS1FBQ3pkk
         04L7FQnpu6Cpbb7Y4cIF0zfQQZ3R+FkIwVeRVF5E=
Date:   Tue, 24 Jan 2023 16:28:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jordy Zomer <jordyzomer@google.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        ebiederm@xmission.com, brho@google.com, catalin.marinas@arm.com,
        broonie@kernel.org, legion@kernel.org, Jason@zx2c4.com,
        surenb@google.com
Subject: Re: [PATCH AUTOSEL 6.1 34/35] prlimit: do_prlimit needs to have a
 speculation check
Message-ID: <Y8/5DKfHZ2Mj7m8Q@kroah.com>
References: <20230124134131.637036-1-sashal@kernel.org>
 <20230124134131.637036-34-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124134131.637036-34-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 08:41:30AM -0500, Sasha Levin wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [ Upstream commit 739790605705ddcf18f21782b9c99ad7d53a8c11 ]
> 
> do_prlimit() adds the user-controlled resource value to a pointer that
> will subsequently be dereferenced.  In order to help prevent this
> codepath from being used as a spectre "gadget" a barrier needs to be
> added after checking the range.
> 
> Reported-by: Jordy Zomer <jordyzomer@google.com>
> Tested-by: Jordy Zomer <jordyzomer@google.com>
> Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/sys.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 5fd54bf0e886..88b31f096fb2 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1442,6 +1442,8 @@ static int do_prlimit(struct task_struct *tsk, unsigned int resource,
>  
>  	if (resource >= RLIM_NLIMITS)
>  		return -EINVAL;
> +	resource = array_index_nospec(resource, RLIM_NLIMITS);
> +
>  	if (new_rlim) {
>  		if (new_rlim->rlim_cur > new_rlim->rlim_max)
>  			return -EINVAL;
> -- 
> 2.39.0
> 

This is already in the 6.1.8 release so no need to add it again :)

thanks,

greg k-h
