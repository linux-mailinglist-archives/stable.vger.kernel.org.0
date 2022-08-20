Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB9459ADF8
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 14:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiHTMs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 08:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiHTMs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 08:48:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C51F21E0B;
        Sat, 20 Aug 2022 05:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17EFD61226;
        Sat, 20 Aug 2022 12:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0111C433D6;
        Sat, 20 Aug 2022 12:48:24 +0000 (UTC)
Date:   Sat, 20 Aug 2022 08:48:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] tracing/eprobes: Do not hardcode $comm as a string
Message-ID: <20220820084837.4d6a95e4@gandalf.local.home>
In-Reply-To: <20220820201824.5637c4feff4a7674aebde60a@kernel.org>
References: <20220820014035.531145719@goodmis.org>
        <20220820014833.035925907@goodmis.org>
        <20220820201824.5637c4feff4a7674aebde60a@kernel.org>
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

On Sat, 20 Aug 2022 20:18:24 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> > Do not assume that comm is a string. Not to mention, it currently forces
> > comm fields to fault, as string processing for event probes is currently
> > broken.  
> 
> Indeed. There should be an event argument which names "comm".
> Eprobe might refer it. BTW, does eprobe use any special common fields?
> I originally introduced "$" variable for such special variables.

I used the '$' for denoting the fields, as it was the easiest way to
integrate with trace_probe.c. There's no special variables, but this patch
series now allows '@' as well as if $comm (or $COMM) is not a field, it
acts the same as $comm for kprobes. Filtering and histograms do the same
thing (use 'comm' as the event field, or has the current->comm if the event
does not have 'comm' as a field). I should probably make "$common_comm"
used too.

-- Steve
