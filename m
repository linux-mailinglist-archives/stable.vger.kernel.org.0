Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA5E676D4C
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjAVN4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjAVN4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:56:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3706713D54;
        Sun, 22 Jan 2023 05:56:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBAA3B80ADF;
        Sun, 22 Jan 2023 13:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F219C433D2;
        Sun, 22 Jan 2023 13:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674395774;
        bh=oyaU0pZ6+kxi5BCt/vMyGdsTVxNHluKGSAjEgXudF/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vC3I5GA3YSfE9NypnkPb0qbWslIEk9orup+sGVFawRSmgnAS9yu71KzesNcC66zLw
         blkWGkP1WSvKPkw3kReC2ILjBlfqm4HUf+69QgZexND/4J3oZl+kGRkq+ahnMfmFsW
         cgI1kCOHEbUy6tp0UM9GlVZiEN50Hj118qotXJOg=
Date:   Sun, 22 Jan 2023 14:56:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Please add oops_limit to -stable
Message-ID: <Y81Aezlkyccop5JX@kroah.com>
References: <202301191532.AEEC765@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202301191532.AEEC765@keescook>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 04:26:55PM -0800, Kees Cook wrote:
> Hi,
> 
> I'd like to ask that the oops_limit series get included in -stable
> releases. It's a recommended defense developed while writing this
> report:
> https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html
> 
> I've had a few people ask about having it in -stable, for example:
> https://lore.kernel.org/lkml/20230119201023.4003-1-sj@kernel.org
> 
> This is the series:
> 
> 9360d035a579 panic: Separate sysctl logic from CONFIG_SMP
> d4ccd54d28d3 exit: Put an upper limit on how often we can oops
> 9db89b411170 exit: Expose "oops_count" to sysfs
> de92f65719cd exit: Allow oops_limit to be disabled
> 79cc1ba7badf panic: Consolidate open-coded panic_on_warn checks
> 9fc9e278a5c0 panic: Introduce warn_limit
> 8b05aa263361 panic: Expose "warn_count" to sysfs
> 00dd027f721e docs: Fix path paste-o for /sys/kernel/warn_count
> 7535b832c639 exit: Use READ_ONCE() for all oops/warn limit reads
> 
> For v6.1.x they apply cleanly and behave as expected.

All now queued up.

> I'm hoping someone can step up and do backports for v5.15.x and earlier,
> as there appear to be a number of conflicts and I'm swamped with other
> stuff to do. :P

If any distro/release cares about 5.15.y and earlier, I will be glad to
take backports.

thanks,

greg k-h
