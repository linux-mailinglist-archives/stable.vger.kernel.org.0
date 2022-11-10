Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE69623B5E
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 06:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiKJFjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 00:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiKJFjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 00:39:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE297643A;
        Wed,  9 Nov 2022 21:39:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1838CE20CD;
        Thu, 10 Nov 2022 05:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C679DC433B5;
        Thu, 10 Nov 2022 05:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668058736;
        bh=4QhL3KIc3bb/u5lTU5w9dA3lFMXt9DXFP2bnRvXDvT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RfRylnjeIsss1CAKtzZcp03C9lK3xuRQ8PbTPMk7ZcQoPxzg3sgLkljQUYaBfK0rP
         W6f2W0Ol8kMf9+v4wfvYo1ljAL0HeuPXoahWd1abixrcKQxwF+TA/2MXrVtw6MXwUn
         u4zUl/p56/8yveXkufvtIj3J+zv4hJg+4ynf1vBrqfezA/NZvrV6L2zNkB3j1ANwdi
         +14NTL4l77Tk1O48s1qD+ghMr20v1efrDx32hOuQOImuEnNcDnNmfVA2L3KgB951oW
         Tf+U6k1beTWds0sc8xDvmNOJiHS5FSLCSahmLE6ZFkxcreCUWf5QQnNMZOZ2EVJkxV
         CmN4urNVJWIRw==
Date:   Wed, 9 Nov 2022 21:38:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] crypto: avoid unnecessary work when self-tests are
 disabled
Message-ID: <Y2yOb4gBVw3yzAwh@sol.localdomain>
References: <20221110023738.147128-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110023738.147128-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022 at 06:37:38PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently, registering an algorithm with the crypto API always causes a
> notification to be posted to the "cryptomgr", which then creates a
> kthread to self-test the algorithm.  However, if self-tests are disabled
> in the kconfig (as is the default option), then this kthread just
> notifies waiters that the algorithm has been tested, then exits.
> 
> This causes a significant amount of overhead, especially in the kthread
> creation and destruction, which is not necessary at all.  For example,
> in a quick test I found that booting a "minimum" x86_64 kernel with all
> the crypto options enabled (except for the self-tests) takes about 400ms
> until PID 1 can start.  Of that, a full 13ms is spent just doing this
> pointless dance, involving a kthread being created, run, and destroyed
> over 200 times.  That's over 3% of the entire kernel start time.
> 
> Fix this by just skipping the creation of the test larval and the
> posting of the registration notification entirely, when self-tests are
> disabled.  Also compile out the unnecessary code in algboss.c.
> 
> While this patch is an optimization and not a "fix" per se, I've marked
> it as for stable, due to the large improvement it can make to boot time.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Unfortunately, this patch won't work because it breaks templates.

There should still be a solution that at least avoids having to spawn kthreads,
though...

- Eric
