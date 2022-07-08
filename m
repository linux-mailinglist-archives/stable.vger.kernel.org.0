Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150D056C39A
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiGHWED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 18:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiGHWEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 18:04:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695B2192BA;
        Fri,  8 Jul 2022 15:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E334B8296F;
        Fri,  8 Jul 2022 22:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBB7C341C0;
        Fri,  8 Jul 2022 22:03:57 +0000 (UTC)
Date:   Fri, 8 Jul 2022 18:03:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Collins <quic_collinsd@quicinc.com>
Cc:     Stephen Boyd <sboyd@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        Ankit Gupta <ankgupta@codeaurora.org>,
        "Gilad Avidov" <gavidov@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] spmi: trace: fix stack-out-of-bound access in SPMI
 tracing functions
Message-ID: <20220708180356.449203f9@gandalf.local.home>
In-Reply-To: <20220627235512.2272783-1-quic_collinsd@quicinc.com>
References: <20220627235512.2272783-1-quic_collinsd@quicinc.com>
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

On Mon, 27 Jun 2022 16:55:12 -0700
David Collins <quic_collinsd@quicinc.com> wrote:

> trace_spmi_write_begin() and trace_spmi_read_end() both call
> memcpy() with a length of "len + 1".  This leads to one extra
> byte being read beyond the end of the specified buffer.  Fix
> this out-of-bound memory access by using a length of "len"
> instead.
> 
> Here is a KASAN log showing the issue:
> 
> BUG: KASAN: stack-out-of-bounds in trace_event_raw_event_spmi_read_end+0x1d0/0x234
> Read of size 2 at addr ffffffc0265b7540 by task thermal@2.0-ser/1314
> ...
> Call trace:
>  dump_backtrace+0x0/0x3e8
>  show_stack+0x2c/0x3c
>  dump_stack_lvl+0xdc/0x11c
>  print_address_description+0x74/0x384
>  kasan_report+0x188/0x268
>  kasan_check_range+0x270/0x2b0
>  memcpy+0x90/0xe8
>  trace_event_raw_event_spmi_read_end+0x1d0/0x234
>  spmi_read_cmd+0x294/0x3ac
>  spmi_ext_register_readl+0x84/0x9c
>  regmap_spmi_ext_read+0x144/0x1b0 [regmap_spmi]
>  _regmap_raw_read+0x40c/0x754
>  regmap_raw_read+0x3a0/0x514
>  regmap_bulk_read+0x418/0x494
>  adc5_gen3_poll_wait_hs+0xe8/0x1e0 [qcom_spmi_adc5_gen3]
>  ...
>  __arm64_sys_read+0x4c/0x60
>  invoke_syscall+0x80/0x218
>  el0_svc_common+0xec/0x1c8
>  ...
> 
> addr ffffffc0265b7540 is located in stack of task thermal@2.0-ser/1314 at offset 32 in frame:
>  adc5_gen3_poll_wait_hs+0x0/0x1e0 [qcom_spmi_adc5_gen3]
> 
> this frame has 1 object:
>  [32, 33) 'status'
> 
> Memory state around the buggy address:
>  ffffffc0265b7400: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
>  ffffffc0265b7480: 04 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
> >ffffffc0265b7500: 00 00 00 00 f1 f1 f1 f1 01 f3 f3 f3 00 00 00 00  
>                                            ^
>  ffffffc0265b7580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffffc0265b7600: f1 f1 f1 f1 01 f2 07 f2 f2 f2 01 f3 00 00 00 00
> ==================================================================
> 
> Fixes: a9fce374815d ("spmi: add command tracepoints for SPMI")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Collins <quic_collinsd@quicinc.com>
> ---
>  include/trace/events/spmi.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/trace/events/spmi.h b/include/trace/events/spmi.h
> index 8b60efe18ba6..a6819fd85cdf 100644
> --- a/include/trace/events/spmi.h
> +++ b/include/trace/events/spmi.h
> @@ -21,15 +21,15 @@ TRACE_EVENT(spmi_write_begin,
>  		__field		( u8,         sid       )
>  		__field		( u16,        addr      )
>  		__field		( u8,         len       )
> -		__dynamic_array	( u8,   buf,  len + 1   )
> +		__dynamic_array	( u8,   buf,  len       )
>  	),
>  
>  	TP_fast_assign(
>  		__entry->opcode = opcode;
>  		__entry->sid    = sid;
>  		__entry->addr   = addr;
> -		__entry->len    = len + 1;
> -		memcpy(__get_dynamic_array(buf), buf, len + 1);
> +		__entry->len    = len;
> +		memcpy(__get_dynamic_array(buf), buf, len);
>  	),
>  
>  	TP_printk("opc=%d sid=%02d addr=0x%04x len=%d buf=0x[%*phD]",
> @@ -92,7 +92,7 @@ TRACE_EVENT(spmi_read_end,
>  		__field		( u16,        addr      )
>  		__field		( int,        ret       )
>  		__field		( u8,         len       )
> -		__dynamic_array	( u8,   buf,  len + 1   )
> +		__dynamic_array	( u8,   buf,  len       )
>  	),
>  
>  	TP_fast_assign(
> @@ -100,8 +100,8 @@ TRACE_EVENT(spmi_read_end,
>  		__entry->sid    = sid;
>  		__entry->addr   = addr;
>  		__entry->ret    = ret;
> -		__entry->len    = len + 1;
> -		memcpy(__get_dynamic_array(buf), buf, len + 1);
> +		__entry->len    = len;
> +		memcpy(__get_dynamic_array(buf), buf, len);
>  	),

Looks legit,

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

>  
>  	TP_printk("opc=%d sid=%02d addr=0x%04x ret=%d len=%02d buf=0x[%*phD]",

