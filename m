Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9654D5FBD44
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiJKV6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 17:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJKV6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 17:58:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E1C5A168;
        Tue, 11 Oct 2022 14:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0222612EA;
        Tue, 11 Oct 2022 21:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01AEC433C1;
        Tue, 11 Oct 2022 21:58:33 +0000 (UTC)
Date:   Tue, 11 Oct 2022 17:58:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing: Fix reading strings from synthetic events
Message-ID: <20221011175831.3dd2d460@rorschach.local.home>
In-Reply-To: <20221011212702.220048293@goodmis.org>
References: <20221011212501.773319898@goodmis.org>
        <20221011212702.220048293@goodmis.org>
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

On Tue, 11 Oct 2022 17:25:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> @@ -417,19 +420,28 @@ static unsigned int trace_string(struct synth_trace_event *entry,
>  		data_offset += event->n_u64 * sizeof(u64);
>  		data_offset += data_size;
>  
> -		str_field = (char *)entry + data_offset;
> -
> -		len = strlen(str_val) + 1;
> -		strscpy(str_field, str_val, len);
> -
> +		len = kern_fetch_store_strlen(str_val) + 1;
> +		if (len == 1)
> +			len = strlen("fault") + 1;
>  		data_offset |= len << 16;
>  		*(u32 *)&entry->fields[*n_u64] = data_offset;
>  
> +		kern_fetch_store_string((unsigned long)str_val, &entry->fields[*n_u64], entry);
> +

This isn't working quite right on faults. I'll be sending a v2 later.

-- Steve
