Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0EE61EEFE
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 10:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiKGJaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 04:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiKGJaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 04:30:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFBA17A9B;
        Mon,  7 Nov 2022 01:29:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5456960F83;
        Mon,  7 Nov 2022 09:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3FCC433C1;
        Mon,  7 Nov 2022 09:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667813397;
        bh=DCiuz6LTY7l26h6R3wPtgXXRsGfpQyNAt3IMbr+A5bI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2UY2VRx4lvFjc4K5NkWOGnKR+WkrD231zYQ5MW0fZmm5xJpuexUdyEJz6Sy2mOCm3
         r28HkswseGOZuGcn337tstBklRfzb2Z3afKCoaQ2ELdBGc0cUZ1b9QN4a77VS7QaAN
         DqBK74SihJ5lqS/Ms0tveVkbtTjsdAub3F9m0LCc=
Date:   Mon, 7 Nov 2022 10:29:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonas Rabenstein <rabenstein@cs.fau.de>
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
Message-ID: <Y2jQEwGJZ0fANWAb@kroah.com>
References: <20221103150303.974028-1-rabenstein@cs.fau.de>
 <20221103153247.zal3czlsxvanfnc3@kashyyyk>
 <Y2jISpQUOTxXxpxN@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2jISpQUOTxXxpxN@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 09:56:42AM +0100, Greg KH wrote:
> On Thu, Nov 03, 2022 at 04:32:47PM +0100, Jonas Rabenstein wrote:
> > Hi again,
> > after sending this out, I noticed this is only a problem in the stable
> > versions (starting from v6.0.3), as c09eb2e578eb1668bbc has been applied (as
> > 03f148c159a250dd454) but not 0e253f7e558a3e250902 ("bpf: Return value in kprobe
> > get_func_ip only for entry address") which makes always use of get_entry_ip.
> > I therefore think, 0e253f7e558a3e250902 needs to be added to the stable v6.0
> > series as well as otherwise it can't be compiled with -Werror if
> > CONFIG_X6_KERNEL_IBT is set but CONFIG_FPROBE isn't.
> 
> Ok, now queued up, thanks.

Oops, this breaks the build, now dropping.

greg k-h
