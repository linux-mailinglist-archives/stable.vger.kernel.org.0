Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A51961EF8A
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 10:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiKGJs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 04:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiKGJs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 04:48:56 -0500
Received: from faui40.informatik.uni-erlangen.de (faui40.informatik.uni-erlangen.de [131.188.34.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1385714D34;
        Mon,  7 Nov 2022 01:48:54 -0800 (PST)
Received: from cs.fau.de (ipbcc2d1f0.dynamic.kabel-deutschland.de [188.194.209.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: rabenstein)
        by faui40.informatik.uni-erlangen.de (Postfix) with ESMTPSA id 920DB548498;
        Mon,  7 Nov 2022 10:48:49 +0100 (CET)
Date:   Mon, 7 Nov 2022 10:48:49 +0100
From:   Jonas Rabenstein <rabenstein@cs.fau.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Song Liu <song@kernel.org>,
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
Message-ID: <20221107094849.gowmplkn3ozskrk2@kashyyyk>
References: <20221103150303.974028-1-rabenstein@cs.fau.de>
 <20221103153247.zal3czlsxvanfnc3@kashyyyk>
 <Y2jISpQUOTxXxpxN@kroah.com>
 <Y2jQEwGJZ0fANWAb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2jQEwGJZ0fANWAb@kroah.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 10:29:55AM +0100, Greg KH wrote:
> On Mon, Nov 07, 2022 at 09:56:42AM +0100, Greg KH wrote:
> > On Thu, Nov 03, 2022 at 04:32:47PM +0100, Jonas Rabenstein wrote:
> > > Hi again,
> > > after sending this out, I noticed this is only a problem in the stable
> > > versions (starting from v6.0.3), as c09eb2e578eb1668bbc has been applied (as
> > > 03f148c159a250dd454) but not 0e253f7e558a3e250902 ("bpf: Return value in kprobe
> > > get_func_ip only for entry address") which makes always use of get_entry_ip.
> > > I therefore think, 0e253f7e558a3e250902 needs to be added to the stable v6.0
> > > series as well as otherwise it can't be compiled with -Werror if
> > > CONFIG_X6_KERNEL_IBT is set but CONFIG_FPROBE isn't.
> > 
> > Ok, now queued up, thanks.
> 
> Oops, this breaks the build, now dropping.
Sorry, 0e253f7e558a3e250902 ("bpf: Return value in kprobe get_func_ip only for
entry address") uses the macro KPROBE_FLAG_ON_FUNC_ENTRY that was introduced
in bf7a87f1075f67c286f7 ("kprobes: Add new KPROBE_FLAG_ON_FUNC_ENTRY kprobe
flag"). Applying those on top of v6.0.7 fixes the original compilation problem
(CONFIG_X6_KERNEL_IBT but !CONFIG_FPROBE) and should not break anything
- jonas
> 
> greg k-h
