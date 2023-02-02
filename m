Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0A6874C0
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 05:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjBBE5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 23:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjBBE5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 23:57:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA33064690;
        Wed,  1 Feb 2023 20:56:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D678B82434;
        Thu,  2 Feb 2023 04:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F1EC433EF;
        Thu,  2 Feb 2023 04:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675313817;
        bh=7XwK8ePhXg9mBRmThdaiiB/Lfdu0j8YeXRGT+wCySPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z/UFCmjnbwoyYmqOVwxCTa3fRkDZXSv//xpEXQv6G8jOz6DGWEklxMNIWVlF1pXCM
         2fgDhAua+dY2U8Sr0kG7kr/uDiGclDayHelL+ruJzeHG2TnfZ8IL5yg6zLdLEOXpiV
         7ErwWt8we2luAb281sDcdOjOY/sv2pgc1dllnktY9muqpaN9cyComAjKvo3MbGQU3s
         e0fHYTJm08E8q7LmKp2cEQvk34fZDEEm9ys6lnqYunEfAfSD2paw6MgCIBOL4ymwUv
         Rs1FisOs6RKjGj2OAfrBrzUIMZ93XfNO0HN2s9kYvD4xZ0MWvDh/fPkAcQuSaRr2MI
         hjVaz2LJqMbug==
Date:   Wed, 1 Feb 2023 20:56:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Munehisa Kamata <kamatam@amazon.com>
Cc:     surenb@google.com, hannes@cmpxchg.org, hdanton@sina.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mengcc@amazon.com, stable@vger.kernel.org
Subject: Re: [PATCH] sched/psi: fix use-after-free in ep_remove_wait_queue()
Message-ID: <Y9tCl4r/qjqsrVj9@sol.localdomain>
References: <CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com>
 <20230202030023.1847084-1-kamatam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202030023.1847084-1-kamatam@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 07:00:23PM -0800, Munehisa Kamata wrote:
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index 8ac8b81bfee6..6e66c15f6450 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -1343,10 +1343,11 @@ void psi_trigger_destroy(struct psi_trigger *t)
>  
>  	group = t->group;
>  	/*
> -	 * Wakeup waiters to stop polling. Can happen if cgroup is deleted
> -	 * from under a polling process.
> +	 * Wakeup waiters to stop polling and clear the queue to prevent it from
> +	 * being accessed later. Can happen if cgroup is deleted from under a
> +	 * polling process otherwise.
>  	 */
> -	wake_up_interruptible(&t->event_wait);
> +	wake_up_pollfree(&t->event_wait);
>  
>  	mutex_lock(&group->trigger_lock);

wake_up_pollfree() should only be used in extremely rare cases.  Why can't the
lifetime of the waitqueue be fixed instead?

- Eric
