Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F6A693353
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 20:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBKTew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 14:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBKTev (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 14:34:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC40C15CBA;
        Sat, 11 Feb 2023 11:34:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66F95B80AAD;
        Sat, 11 Feb 2023 19:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44848C433EF;
        Sat, 11 Feb 2023 19:34:47 +0000 (UTC)
Date:   Sat, 11 Feb 2023 14:34:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>, mhiramat@kernel.org,
        linux-trace-kernel@vger.kernel.org,
        John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH -trace] trace: fix TASK_COMM_LEN in trace event format
 file
Message-ID: <20230211143445.51b49a50@gandalf.local.home>
In-Reply-To: <32e0332a-4ef4-bfe3-129e-50afa989a151@efficios.com>
References: <20230210155921.4610-1-laoar.shao@gmail.com>
        <32e0332a-4ef4-bfe3-129e-50afa989a151@efficios.com>
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

On Fri, 10 Feb 2023 11:27:18 -0500
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > --- a/include/trace/stages/stage4_event_fields.h
> > +++ b/include/trace/stages/stage4_event_fields.h
> > @@ -26,7 +26,8 @@
> >   #define __array(_type, _item, _len) {					\
> >   	.type = #_type"["__stringify(_len)"]", .name = #_item,		\  
> 
> Just out of curiosity, is the content of __stringify(_len) ever used 
> after this patch ? Perhaps we could remove it and just leave:
> 
> .type = #_type"[]"
> 
> considering that f_show appears to use the opening square bracket to 
> detect arrays. This would remove a few useless bytes of data.

I agree that we can optimize this. But lets make that a separate patch, and
not worry about it for this. That's a clean up that can be handled later.

I'd like to not add any more side effects than it may already have.

-- Steve
