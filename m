Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B56C6DE96E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 04:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDLCcO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Apr 2023 22:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjDLCcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 22:32:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4249144B1;
        Tue, 11 Apr 2023 19:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D637A6266D;
        Wed, 12 Apr 2023 02:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0108C4339E;
        Wed, 12 Apr 2023 02:32:10 +0000 (UTC)
Date:   Tue, 11 Apr 2023 22:32:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tze-nan Wu (=?UTF-8?B?5ZCz5r6k5Y2X?=)" <Tze-nan.Wu@mediatek.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Cheng-Jui Wang (=?UTF-8?B?546L5q2j552/?=)" 
        <Cheng-Jui.Wang@mediatek.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "Bobule Chang (=?UTF-8?B?5by15byY576p?=)" <bobule.chang@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>
Subject: Re: [PATCH v3] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Message-ID: <20230411223206.0bc5794e@gandalf.local.home>
In-Reply-To: <ef0ebc2f0f934ff5c35719f1960d24a5838ff770.camel@mediatek.com>
References: <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
        <20230410073512.13362-1-Tze-nan.Wu@mediatek.com>
        <20230411124403.2a31e12d@gandalf.local.home>
        <ef0ebc2f0f934ff5c35719f1960d24a5838ff770.camel@mediatek.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Apr 2023 02:27:53 +0000
Tze-nan Wu (吳澤南) <Tze-nan.Wu@mediatek.com> wrote:

> > > @@ -5368,7 +5372,7 @@ void ring_buffer_reset_online_cpus(struct
> > > trace_buffer *buffer)
> > >       /* Make sure all commits have finished */
> > >       synchronize_rcu();
> > > 
> > > -     for_each_online_buffer_cpu(buffer, cpu) {
> > > +     for_each_cpu_and(cpu, buffer->cpumask, &reset_online_cpumask)  
> 
> Maybe we should use for_each_buffer_cpu(buffer, cpu) here?
> since a CPU may also came offline during synchronize_rcu().

Yeah, I guess that works too (not looking at the code at the moment though).

-- Steve

> 
> > > {
> > >               cpu_buffer = buffer->buffers[cpu];  
> > 
