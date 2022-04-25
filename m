Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB6B50E46E
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 17:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242858AbiDYPck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 11:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242896AbiDYPci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 11:32:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF5010F417;
        Mon, 25 Apr 2022 08:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02852B815E2;
        Mon, 25 Apr 2022 15:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C736C385A7;
        Mon, 25 Apr 2022 15:29:31 +0000 (UTC)
Date:   Mon, 25 Apr 2022 11:29:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     mhiramat@kernel.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] tracing: Fix potential double free in
 create_var_ref()
Message-ID: <20220425112929.5c3fcfe4@gandalf.local.home>
In-Reply-To: <20220425063739.3859998-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
References: <20220423001311.31e2dff59708ddd3043e55af@kernel.org>
        <20220425063739.3859998-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Apr 2022 06:37:38 +0000
Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp> wrote:

FYI, always send a new version of a patch as a separate thread, never as a
reply-to of a previous version. That breaks tools like patchwork which will
not show this version of the patch.

> In create_var_ref(), init_var_ref() is called to initialize the fields
> of variable ref_field, which is allocated in the previous function call
> to create_hist_field(). Function init_var_ref() allocates the
> corresponding fields such as ref_field->system, but frees these fields
> when the function encounters an error. The caller later calls
> destroy_hist_field() to conduct error handling, which frees the fields
> and the variable itself. This results in double free of the fields which
> are already freed in the previous function.
> 
> Fix this by storing NULL to the corresponding fields when they are freed
> in init_var_ref().
> 
> Fixes: 067fe038e70f ("tracing: Add variable reference handling to hist triggers")
> CC: stable@vger.kernel.org
> Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  kernel/trace/trace_events_hist.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 44db5ba9cabb..a0e41906d9ce 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -2093,8 +2093,11 @@ static int init_var_ref(struct hist_field *ref_field,
>  	return err;
>   free:
>  	kfree(ref_field->system);
> +	ref_field->system = NULL;
>  	kfree(ref_field->event_name);
> +	ref_field->event_name = NULL;
>  	kfree(ref_field->name);
> +	ref_field->name = NULL;

Nit, but it would look nicer as:

	kfree(ref_field->system);
	kfree(ref_field->event_name);
	kfree(ref_field->name);

	ref_field->system = NULL;
	ref_field->event_name = NULL;
	ref_field->name = NULL;


-- Steve

>  
>  	goto out;
>  }

