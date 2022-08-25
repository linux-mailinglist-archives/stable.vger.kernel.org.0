Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3055A1082
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbiHYMbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 08:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241803AbiHYMb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 08:31:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDD5883E5;
        Thu, 25 Aug 2022 05:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C05C561B83;
        Thu, 25 Aug 2022 12:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A0FC433D6;
        Thu, 25 Aug 2022 12:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661430681;
        bh=O+GBaKiGVy7D/LtxG4vf/FnvI3gPOLL6OHhuMV14f1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DrRD0wWiwvretJWfyBvcmcwjUJ/EH+beKIaFQDhx1Rm7w+vjjrrcViw1aWGiY/JXT
         jUFw5bahMFNyjkWAIpc94zY+q+/7pINYblqSUw40y9dydWUg4vIIoDe/eUd0PGzV5u
         QHMFcE4GRV0ttTTAWaEXV1FANqQ1p1j8rwM9BPAg=
Date:   Thu, 25 Aug 2022 14:31:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ankit Jain <ankitja@vmware.com>
Cc:     juri.lelli@redhat.com, bristot@redhat.com, l.stach@pengutronix.de,
        suhui_kernel@163.com, msimmons@redhat.com, peterz@infradead.org,
        glenn@aurora.tech, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, akaher@vmware.com, amakhalov@vmware.com,
        vsirnapalli@vmware.com, sturlapati@vmware.com,
        bordoloih@vmware.com, keerthanak@vmware.com
Subject: Re: [PATCH v4.19.y 0/4] sched/deadline: Fix panic due to nested
 priority inheritance
Message-ID: <Ywdrjqht7agq0WrY@kroah.com>
References: <20220822074348.218135-1-ankitja@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822074348.218135-1-ankitja@vmware.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 01:13:44PM +0530, Ankit Jain wrote:
> When a CFS task that was boosted by a SCHED_DEADLINE
> task boosts another CFS task (nested priority inheritance),
> Kernel panic is observed.
> Fixing priority inheritance changes the way how sched_deadline
> attributes are being inherited from original donor task.
> 
> Additional supporting patches are added to fix throttling of
> boosted tasks.
> 
> Daniel Bristot de Oliveira (1):
>   sched/deadline: Unthrottle PI boosted threads while enqueuing
> 
> Lucas Stach (1):
>   sched/deadline: Fix stale throttling on de-/boosted tasks
> 
> Juri Lelli (1):
>   sched/deadline: Fix priority inheritance with multiple scheduling
>     classes
> 
> Hui Su (1):
>   kernel/sched: Remove dl_boosted flag comment
> 
>  include/linux/sched.h   |  13 ++--
>  kernel/sched/core.c     |  11 ++--
>  kernel/sched/deadline.c | 131 +++++++++++++++++++++++++---------------
>  3 files changed, 96 insertions(+), 59 deletions(-)
> 
> -- 
> 2.34.1
> 

Both sets of backports now queued up, thanks.

greg k-h
