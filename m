Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9F739E098
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 17:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFGPgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 11:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230239AbhFGPgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 11:36:09 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC3661164;
        Mon,  7 Jun 2021 15:34:17 +0000 (UTC)
Date:   Mon, 7 Jun 2021 11:34:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Liangyan <liangyan.peng@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        yinbinbin@alibabacloud.com, wetp <wetp.zy@linux.alibaba.com>,
        jnwang@linux.alibaba.com, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tracing: Correct the length check which causes memory
 corruption
Message-ID: <20210607113416.603c72d3@oasis.local.home>
In-Reply-To: <20210607125734.1770447-1-liangyan.peng@linux.alibaba.com>
References: <20210607125734.1770447-1-liangyan.peng@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  7 Jun 2021 20:57:34 +0800
Liangyan <liangyan.peng@linux.alibaba.com> wrote:

> commit b220c049d519 ("tracing: Check length before giving out
> the filter buffer") adds length check to protect trace data
> overflow introduced in 0fc1b09ff1ff, seems that this fix can't prevent
> overflow entirely, the length check should also take the sizeof
> entry->array[0] into account, since this array[0] is filled the
> length of trace data and occupy addtional space and risk overflow.

Bah, you're right! I didn't take into account that when the event is
this big, array[] will have content.

I queued the patch and will start testing it.

Thanks!

-- Steve
