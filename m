Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4BD69E18F
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 14:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbjBUNoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 08:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbjBUNoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 08:44:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A914217
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 05:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE31AB80E88
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 13:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04172C433EF;
        Tue, 21 Feb 2023 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676987044;
        bh=Mu7TJpO1J1olspWT5vCVJ4OyNFer0X+SrmWLifHnHFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2pLI77st4Znh8BsG/Q5ocMePJ8iWbrIwkmONo5Mud5s/6Jd9Ug+G0JV2LkPHpVet1
         rUDv59TqIQ2hCEgiAga55QS9uRFr8TXyYmj9zJ6TmMlWoFjTjuXuXPHOOBoX5UzWkO
         amTYcmRTGqAaQNBxpO5mNg7MX00s9OjMQLDCT0mg=
Date:   Tue, 21 Feb 2023 14:44:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Srinivasarao Pathipati <quic_spathi@quicinc.com>
Cc:     stable@vger.kernel.org,
        Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
Subject: Re: [PATCH V2] rcu-tasks: Fix build error
Message-ID: <Y/TKoaNxLamp8nqh@kroah.com>
References: <1676981074-27435-1-git-send-email-quic_spathi@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1676981074-27435-1-git-send-email-quic_spathi@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 05:34:34PM +0530, Srinivasarao Pathipati wrote:
> From: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
> 
> Making show_rcu_tasks_rude_gp_kthread() function as 'inline' to
> fix below compilation error.
> This is applicable to only 5.10 kernels as code got modified
> in latest kernels.
> 
>  In file included from kernel/rcu/update.c:579:0:
>  kernel/rcu/tasks.h:710:13: error: ‘show_rcu_tasks_rude_gp_kthread’ defined but not used [-Werror=unused-function]
>   static void show_rcu_tasks_rude_gp_kthread(void) {}
> 
> Fixes: 8344496e8b49 ("rcu-tasks: Conditionally compile show_rcu_tasks_gp_kthreads()")
> Signed-off-by: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
> ---
>  kernel/rcu/tasks.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

You didn't answer my "why is this an issue now" question.

Also, please document exactly what the modification was in Linus's tree
that prevents us from backportin gthat change here.

thanks,

greg k-h
