Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94198532C83
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 16:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiEXOqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 10:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238384AbiEXOpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 10:45:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF45E9C2D0;
        Tue, 24 May 2022 07:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9EE2616B5;
        Tue, 24 May 2022 14:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F94C34113;
        Tue, 24 May 2022 14:45:34 +0000 (UTC)
Date:   Tue, 24 May 2022 10:45:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <kernel-team@fb.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] ftrace: clean up hash direct_functions on register
 failures
Message-ID: <20220524104527.3a07878d@gandalf.local.home>
In-Reply-To: <20220512220808.766832-1-song@kernel.org>
References: <20220512220808.766832-1-song@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 May 2022 15:08:08 -0700
Song Liu <song@kernel.org> wrote:

> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4465,7 +4465,7 @@ int ftrace_func_mapper_add_ip(struct ftrace_func_mapper *mapper,
>   * @ip: The instruction pointer address to remove the data from
>   *
>   * Returns the data if it is found, otherwise NULL.
> - * Note, if the data pointer is used as the data itself, (see 
> + * Note, if the data pointer is used as the data itself, (see
>   * ftrace_func_mapper_find_ip(), then the return value may be meaningless,
>   * if the data pointer was set to zero.
>   */
> @@ -5200,8 +5200,10 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
>  
>  	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
>  		ret = register_ftrace_function(&direct_ops);
> -		if (ret)
> +		if (ret) {
>  			ftrace_set_filter_ip(&direct_ops, ip, 1, 0);
> +			remove_hash_entry(direct_functions, entry);
> +		}
>  	}
>  
>  	if (ret) {

Perhaps something like this is more robust?

-- Steve

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4f1d2f5e7263..cd38ad490174 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5195,8 +5195,6 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 		goto out_unlock;
 
 	ret = ftrace_set_filter_ip(&direct_ops, ip, 0, 0);
-	if (ret)
-		remove_hash_entry(direct_functions, entry);
 
 	if (!ret && !(direct_ops.flags & FTRACE_OPS_FL_ENABLED)) {
 		ret = register_ftrace_function(&direct_ops);
@@ -5205,6 +5203,7 @@ int register_ftrace_direct(unsigned long ip, unsigned long addr)
 	}
 
 	if (ret) {
+		remove_hash_entry(direct_functions, entry);
 		kfree(entry);
 		if (!direct->count) {
 			list_del_rcu(&direct->next);

