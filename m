Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AC556C593
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 03:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiGIBDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 21:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiGIBDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 21:03:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02C52C64D;
        Fri,  8 Jul 2022 18:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7850B623EE;
        Sat,  9 Jul 2022 01:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ACAC341CA;
        Sat,  9 Jul 2022 01:03:36 +0000 (UTC)
Date:   Fri, 8 Jul 2022 21:03:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <tom.zanussi@linux.intel.com>, <trix@redhat.com>,
        <stable@vger.kernel.org>, <zhangjinhao2@huawei.com>
Subject: Re: [PATCH] Revert "tracing: fix double free"
Message-ID: <20220708210335.79a38356@gandalf.local.home>
In-Reply-To: <20220630013137.164756-1-zhengyejian1@huawei.com>
References: <20220630013137.164756-1-zhengyejian1@huawei.com>
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

On Thu, 30 Jun 2022 09:31:37 +0800
Zheng Yejian <zhengyejian1@huawei.com> wrote:

> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 48e82e141d54..2784951e0fc8 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -4430,6 +4430,7 @@ static int parse_var_defs(struct hist_trigger_data *hist_data)
>  
>  			s = kstrdup(field_str, GFP_KERNEL);
>  			if (!s) {
> +				kfree(hist_data->attrs->var_defs.name[n_vars]);

Instead of doing just a revert, can we also add, for safety:

				hist_data->attrs->var_defs.name[n_vars] = NULL;

Thanks,

-- Steve

>  				ret = -ENOMEM;
>  				goto free;
>  			}
