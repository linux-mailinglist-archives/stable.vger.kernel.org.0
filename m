Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB205387C2
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 21:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbiE3Tdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 15:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiE3Tdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 15:33:43 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698FF3CFFA;
        Mon, 30 May 2022 12:33:41 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvl8r-0001V6-CF; Mon, 30 May 2022 21:33:29 +0200
Received: from [85.1.206.226] (helo=linux-2.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvl8q-000VcP-QA; Mon, 30 May 2022 21:33:29 +0200
Subject: Re: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <165366693881.797669.16926184644089588731.stgit@devnote2>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0204f480-cdb0-e49f-9034-602eced02966@iogearbox.net>
Date:   Mon, 30 May 2022 21:33:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <165366693881.797669.16926184644089588731.stgit@devnote2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26557/Mon May 30 10:05:44 2022)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/22 5:55 PM, Masami Hiramatsu (Google) wrote:
> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> There is a small chance that get_kretprobe(ri) returns NULL in
> kretprobe_dispatcher() when another CPU unregisters the kretprobe
> right after __kretprobe_trampoline_handler().
> 
> To avoid this issue, kretprobe_dispatcher() checks the get_kretprobe()
> return value again. And if it is NULL, it returns soon because that
> kretprobe is under unregistering process.
> 
> This issue has been introduced when the kretprobe is decoupled
> from the struct kretprobe_instance by commit d741bf41d7c7
> ("kprobes: Remove kretprobe hash"). Before that commit, the
> struct kretprob_instance::rp directly points the kretprobe
> and it is never be NULL.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
> Cc: stable@vger.kernel.org
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Steven, I presume you'll pick this fix up?

Thanks,
Daniel
