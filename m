Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5904B6182FF
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiKCPib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKCPi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:38:29 -0400
X-Greylist: delayed 331 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Nov 2022 08:38:22 PDT
Received: from faui40.informatik.uni-erlangen.de (faui40.informatik.uni-erlangen.de [131.188.34.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3B5114;
        Thu,  3 Nov 2022 08:38:22 -0700 (PDT)
Received: from cs.fau.de (i4laptop28.informatik.uni-erlangen.de [10.188.34.179])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: rabenstein)
        by faui40.informatik.uni-erlangen.de (Postfix) with ESMTPSA id CAAB3548534;
        Thu,  3 Nov 2022 16:32:47 +0100 (CET)
Date:   Thu, 3 Nov 2022 16:32:47 +0100
From:   Jonas Rabenstein <rabenstein@cs.fau.de>
To:     stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>, Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: mark get_entry_ip as __maybe_unused
Message-ID: <20221103153247.zal3czlsxvanfnc3@kashyyyk>
References: <20221103150303.974028-1-rabenstein@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103150303.974028-1-rabenstein@cs.fau.de>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi again,
after sending this out, I noticed this is only a problem in the stable
versions (starting from v6.0.3), as c09eb2e578eb1668bbc has been applied (as
03f148c159a250dd454) but not 0e253f7e558a3e250902 ("bpf: Return value in kprobe
get_func_ip only for entry address") which makes always use of get_entry_ip.
I therefore think, 0e253f7e558a3e250902 needs to be added to the stable v6.0
series as well as otherwise it can't be compiled with -Werror if
CONFIG_X6_KERNEL_IBT is set but CONFIG_FPROBE isn't.

- Jonas

On Thu, Nov 03, 2022 at 04:03:03PM +0100, Jonas Rabenstein wrote:
> Commit c09eb2e578eb1668bbc ("bpf: Adjust kprobe_multi entry_ip
> for CONFIG_X86_KERNEL_IBT") introduced the get_entry_ip() function.
> Depending on CONFIG_X86_KERNEL_IBT it is a static function or only
> a macro definition. The only user of this symbol so far is in
> kprobe_multi_link_handler() if CONFIG_FPROBE is enabled.
> If CONFIG_FROBE is not set, the symbol is not used and - depending
> on CONFIG_X86_KERNEL_IBT - a warning for get_entry_ip() is emitted.
> To solve this, the function should be marked as __maybe_unused.
> 
> Signed-off-by: Jonas Rabenstein <rabenstein@cs.fau.de>
> ---
>  kernel/trace/bpf_trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f2d8d070d024..19131aae0bc3 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1032,7 +1032,7 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
>  };
>  
>  #ifdef CONFIG_X86_KERNEL_IBT
> -static unsigned long get_entry_ip(unsigned long fentry_ip)
> +static unsigned long __maybe_unused get_entry_ip(unsigned long fentry_ip)
>  {
>  	u32 instr;
>  
> -- 
> 2.37.4
> 
