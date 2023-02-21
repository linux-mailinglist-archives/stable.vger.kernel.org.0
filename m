Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A9869E19E
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 14:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjBUNqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 08:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbjBUNp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 08:45:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B154D1DB88
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 05:45:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED3B6100E
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 13:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49658C433D2;
        Tue, 21 Feb 2023 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676987157;
        bh=faIXtInbZm/tiyABGFOeo9pgDsJBGd067oYQlGXgcuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1jrx1SGHOdCQIMVavpu0xgI/8CYdFkLwHNAClao/PBmqa4rymDEI2xE4uWojnhA06
         XEnQRAyqx3ThfRNWf0f1gmG+t+h59jnYZcHxQrmCSd2/YqpKfBPTanendjr9QVQHYR
         y/u91U7iVo0tZFghwT0iBEOa8LQcnWhOcBEgFPS0=
Date:   Tue, 21 Feb 2023 14:45:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V1] rcu-tasks: Fix build error
Message-ID: <Y/TLEw0a84S3C3qd@kroah.com>
References: <1676916839-32235-1-git-send-email-quic_c_spathi@quicinc.com>
 <Y/PByBdfz/WPBs2W@kroah.com>
 <72e8a2a5-8729-5551-563a-d8d7c143f527@quicinc.com>
 <Y/Sez06gvJbAv7VE@kroah.com>
 <b721f192-32da-a532-84c2-6f768ac2a7ee@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b721f192-32da-a532-84c2-6f768ac2a7ee@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 04:49:17PM +0530, Srinivasarao Pathipati wrote:
> 
> On 2/21/2023 4:07 PM, Greg KH wrote:
> > On Tue, Feb 21, 2023 at 02:57:15PM +0530, Srinivasarao Pathipati wrote:
> > > On 2/21/2023 12:24 AM, Greg KH wrote:
> > > > On Mon, Feb 20, 2023 at 11:43:59PM +0530, Srinivasarao Pathipati wrote:
> > > > > Making show_rcu_tasks_rude_gp_kthread() function as 'inline' to
> > > > > fix below compilation error.
> > > > > This is applicable to only 5.10 kernels as code got modified
> > > > > in latest kernels.
> > > > > 
> > > > >    In file included from kernel/rcu/update.c:579:0:
> > > > >    kernel/rcu/tasks.h:710:13: error: ‘show_rcu_tasks_rude_gp_kthread’ defined but not used [-Werror=unused-function]
> > > > >     static void show_rcu_tasks_rude_gp_kthread(void) {}
> > > > > 
> > > > > Signed-off-by: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
> > > > > ---
> > > > >    kernel/rcu/tasks.h | 2 +-
> > > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> > > > > index 8b51e6a..53ddb4e 100644
> > > > > --- a/kernel/rcu/tasks.h
> > > > > +++ b/kernel/rcu/tasks.h
> > > > > @@ -707,7 +707,7 @@ static void show_rcu_tasks_rude_gp_kthread(void)
> > > > >    #endif /* #ifndef CONFIG_TINY_RCU */
> > > > >    #else /* #ifdef CONFIG_TASKS_RUDE_RCU */
> > > > > -static void show_rcu_tasks_rude_gp_kthread(void) {}
> > > > > +static inline void show_rcu_tasks_rude_gp_kthread(void) {}
> > > > >    #endif /* #else #ifdef CONFIG_TASKS_RUDE_RCU */
> > > > >    ////////////////////////////////////////////////////////////////////////
> > > > > -- 
> > > > > 2.7.4
> > > > > 
> > > > What commit id caused this problem?
> > > commit  (8344496e8b49c4122c1808d6cd3f8dc71bccb595 rcu-tasks: Conditionally
> > > compile show_rcu_tasks_gp_kthreads()) introduced this issue
> > So this has been around for a very very long time.
> > 
> > Why is this suddenly an issue now, almost 3 years later?  What changed
> > to cause this to become an issue?
> > 
> > And please put this information in the changelog text.
> 
>  We observed this issue on Android kernels with arch=UM  after picking this
> patch (3fe617ccafd6f5bb33c2391d6f4eeb41c1fd0151 Enable '-Werror' by default
> for all kernel builds ) recently into Android kernels.

But that commit is NOT in the 5.10.y tree, so why would we care about
this problem in the 5.10.y tree?

confused,

greg k-h
