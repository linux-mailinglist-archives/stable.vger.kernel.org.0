Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C64A5FDE99
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJMRB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiJMRB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:01:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34669F0379
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCFE4B81FBC
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 17:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34625C433D6;
        Thu, 13 Oct 2022 17:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665680484;
        bh=c4EZe/OM3oGnBn5d8mD3/jmZIYgbK873PCNQ4f0vGi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BNKUfBFM+Tf5g/eTkTS0w2XOqMlNJ37ja6pPpmMjsfrUr2eEPImRDxMJSCX8Xh9gk
         41SsCHKgNgY5ZO9JA//1++2EnPv9cYu6xqCooUyD8S4O3BocogamTpCdDawVgFY4ig
         29BE9FLLjf+XDWI7BXrMpFOqOKpT1LKDRnin2h5A=
Date:   Thu, 13 Oct 2022 19:02:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.9.y] random: restore O_NONBLOCK support
Message-ID: <Y0hEkS0ZizRcm+o6@kroah.com>
References: <Y0g7N95gKNFMJZ72@kroah.com>
 <20221013163231.1410141-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013163231.1410141-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 10:32:31AM -0600, Jason A. Donenfeld wrote:
> commit cd4f24ae9404fd31fc461066e57889be3b68641b upstream.
> 
> Prior to 5.6, when /dev/random was opened with O_NONBLOCK, it would
> return -EAGAIN if there was no entropy. When the pools were unified in
> 5.6, this was lost. The post 5.6 behavior of blocking until the pool is
> initialized, and ignoring O_NONBLOCK in the process, went unnoticed,
> with no reports about the regression received for two and a half years.
> However, eventually this indeed did break somebody's userspace.
> 
> So we restore the old behavior, by returning -EAGAIN if the pool is not
> initialized. Unlike the old /dev/random, this can only occur during
> early boot, after which it never blocks again.
> 
> In order to make this O_NONBLOCK behavior consistent with other
> expectations, also respect users reading with preadv2(RWF_NOWAIT) and
> similar.
> 
> Fixes: 30c08efec888 ("random: make /dev/random be almost like /dev/urandom")
> Reported-by: Guozihua <guozihua@huawei.com>
> Reported-by: Zhongguohua <zhongguohua1@huawei.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andrew Lutomirski <luto@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/random.c | 4 ++++
>  1 file changed, 4 insertions(+)

Now queued up, thanks.

greg k-h
