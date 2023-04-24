Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF046ED5EF
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 22:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjDXULf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 16:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjDXULe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 16:11:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30E140E0;
        Mon, 24 Apr 2023 13:11:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F6D1628BF;
        Mon, 24 Apr 2023 20:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17D9C433D2;
        Mon, 24 Apr 2023 20:11:31 +0000 (UTC)
Date:   Mon, 24 Apr 2023 16:11:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Cc:     <mhiramat@kernel.org>, <bobule.chang@mediatek.com>,
        <wsd_upstream@mediatek.com>, <cheng-jui.wang@mediatek.com>,
        <npiggin@gmail.com>, <stable@vger.kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v4] ring-buffer: Ensure proper resetting of atomic
 variables in ring_buffer_reset_online_cpus
Message-ID: <20230424161129.27e75db1@rorschach.local.home>
In-Reply-To: <20230412112401.25081-1-Tze-nan.Wu@mediatek.com>
References: <20230412112401.25081-1-Tze-nan.Wu@mediatek.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Apr 2023 19:23:56 +0800
Tze-nan Wu <Tze-nan.Wu@mediatek.com> wrote:

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
> Changes from v1 to v3: https://lore.kernel.org/all/20230408052226.25268-1-Tze-nan.Wu@mediatek.com/
>   - Declare the cpumask variable statically rather than dynamically.
> 
> Changes from v2 to v3: https://lore.kernel.org/all/20230409024616.31099-1-Tze-nan.Wu@mediatek.com/
>   - Considering holding cpu_hotplug_lock too long because of the
>     synchronize_rcu(), maybe it's better to prevent the issue by copying
>     cpu_online_mask at the entry of the function as V1 does, instead of
>     using cpus_read_lock().
> 
> Changes from v3 to v4: https://lore.kernel.org/all/20230410073512.13362-1-Tze-nan.Wu@mediatek.com/
>   - Considering that the size of cpumask may not be too big on some machines
>     We no longer adopt the approach of copying cpumask at the beginning of
>     the function. Instead, we ensure that atomic variables have been set up
>     before atomic_sub() is called.
>   - Change the title of the patch.
> ---
>  kernel/trace/ring_buffer.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 76a2d91eecad..8c647d8b5bb4 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -5361,20 +5361,28 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
>  	for_each_online_buffer_cpu(buffer, cpu) {
>  		cpu_buffer = buffer->buffers[cpu];
>  
> -		atomic_inc(&cpu_buffer->resize_disabled);
> +#define RESET_BIT	(1 << 30)

Nit, please add the define outside the function. You could do it right
before the function, but defines like this make the code somewhat ugly.

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

