Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC446EEBD8
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 03:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbjDZBRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 21:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238366AbjDZBRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 21:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6FB13C19;
        Tue, 25 Apr 2023 18:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 087ED62CE6;
        Wed, 26 Apr 2023 01:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC61C433D2;
        Wed, 26 Apr 2023 01:17:38 +0000 (UTC)
Date:   Tue, 25 Apr 2023 21:17:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tze-nan.Wu" <Tze-nan.Wu@mediatek.com>
Cc:     <mhiramat@kernel.org>, <bobule.chang@mediatek.com>,
        <cheng-jui.wang@mediatek.com>, <wsd_upstream@mediatek.com>,
        <stable@vger.kernel.org>, <npiggin@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [PATCH v5] ring-buffer: Ensure proper resetting of atomic
 variables in ring_buffer_reset_online_cpus
Message-ID: <20230425211737.757208b3@gandalf.local.home>
In-Reply-To: <20230426010446.10753-1-Tze-nan.Wu@mediatek.com>
References: <20230426010446.10753-1-Tze-nan.Wu@mediatek.com>
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


For some reason, this email did not make it to
linux-trace-kernel@vger.kernel.org, and therefore did not make it into
patchwork?

John?

-- Steve


On Wed, 26 Apr 2023 09:04:44 +0800
Tze-nan.Wu <Tze-nan.Wu@mediatek.com> wrote:

> From: "Tze-nan Wu" <Tze-nan.Wu@mediatek.com>
> 
> In ring_buffer_reset_online_cpus, the buffer_size_kb write operation
> may permanently fail if the cpu_online_mask changes between two
> for_each_online_buffer_cpu loops. The number of increases and decreases
> on both cpu_buffer->resize_disabled and cpu_buffer->record_disabled may be
> inconsistent, causing some CPUs to have non-zero values for these atomic
> variables after the function returns.
> 
> This issue can be reproduced by "echo 0 > trace" while hotplugging cpu.
> After reproducing success, we can find out buffer_size_kb will not be
> functional anymore.
> 
> To prevent leaving 'resize_disabled' and 'record_disabled' non-zero after
> ring_buffer_reset_online_cpus returns, we ensure that each atomic variable
> has been set up before atomic_sub() to it.
> 
> Cc: stable@vger.kernel.org
> Cc: npiggin@gmail.com
> Fixes: b23d7a5f4a07 ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
> Reviewed-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
> Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
> ---
> Changes from v4 to v5: https://lore.kernel.org/lkml/20230412112401.25081-1-Tze-nan.Wu@mediatek.com/
>   - Move the define before the function
> ---
>  kernel/trace/ring_buffer.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 76a2d91eecad..253ef85a9ec3 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -5345,6 +5345,9 @@ void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu)
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
>  
> +/* Flag to ensure proper resetting of atomic variables */
> +#define RESET_BIT	(1 << 30)
> +
>  /**
>   * ring_buffer_reset_online_cpus - reset a ring buffer per CPU buffer
>   * @buffer: The ring buffer to reset a per cpu buffer of
> @@ -5361,20 +5364,27 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
>  	for_each_online_buffer_cpu(buffer, cpu) {
>  		cpu_buffer = buffer->buffers[cpu];
>  
> -		atomic_inc(&cpu_buffer->resize_disabled);
> +		atomic_add(RESET_BIT, &cpu_buffer->resize_disabled);
>  		atomic_inc(&cpu_buffer->record_disabled);
>  	}
>  
>  	/* Make sure all commits have finished */
>  	synchronize_rcu();
>  
> -	for_each_online_buffer_cpu(buffer, cpu) {
> +	for_each_buffer_cpu(buffer, cpu) {
>  		cpu_buffer = buffer->buffers[cpu];
>  
> +		/*
> +		 * If a CPU came online during the synchronize_rcu(), then
> +		 * ignore it.
> +		 */
> +		if (!(atomic_read(&cpu_buffer->resize_disabled) & RESET_BIT))
> +			continue;
> +
>  		reset_disabled_cpu_buffer(cpu_buffer);
>  
>  		atomic_dec(&cpu_buffer->record_disabled);
> -		atomic_dec(&cpu_buffer->resize_disabled);
> +		atomic_sub(RESET_BIT, &cpu_buffer->resize_disabled);
>  	}
>  
>  	mutex_unlock(&buffer->mutex);

