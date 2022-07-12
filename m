Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E835721F3
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 19:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiGLRuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 13:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiGLRuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 13:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4984D14A;
        Tue, 12 Jul 2022 10:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB0F6B81B89;
        Tue, 12 Jul 2022 17:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806FDC3411C;
        Tue, 12 Jul 2022 17:49:58 +0000 (UTC)
Date:   Tue, 12 Jul 2022 13:49:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <tom.zanussi@linux.intel.com>, <trix@redhat.com>,
        <stable@vger.kernel.org>, <zhangjinhao2@huawei.com>
Subject: Re: [PATCH] tracing/histograms: Simplify create_hist_fields()
Message-ID: <20220712134956.4acb90a3@gandalf.local.home>
In-Reply-To: <20220630013152.164871-1-zhengyejian1@huawei.com>
References: <20220630013152.164871-1-zhengyejian1@huawei.com>
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

On Thu, 30 Jun 2022 09:31:52 +0800
Zheng Yejian <zhengyejian1@huawei.com> wrote:

> When I look into implements of create_hist_fields(), I think there can be
> following two simplifications:
>   1. If something wrong happened in parse_var_defs(), free_var_defs() would
>      have been called in it, so no need goto free again after calling it;
>   2. After calling create_key_fields(), regardless of the value of 'ret', it
>      then always runs into 'out: ', so the judge of 'ret' is redundant.
> 
> No functional changes.

I applied this but removed the "No functional changes" because it is a
functional change. The end result may be the same, but the flow is
different, and that means it changed functionally.

The only time "No functional changes" should be stated is if you move code
around or change #ifdefs to perform the same action. IOW, if the assembly
produced by the compiler is the same before and after your change, you can
say "No functional changes", otherwise don't ever say that.

This is important, because if a bisect lands on this, people may think the
bisect is incorrect, when in reality it could be the cause of the bug (I
just had this happen to me with another commit that had "No functional
changes" :-p )

-- Steve


> 
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
