Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FCC3B823E
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhF3Mhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234553AbhF3Mho (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:37:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE68C61584;
        Wed, 30 Jun 2021 12:35:14 +0000 (UTC)
Date:   Wed, 30 Jun 2021 08:35:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paul Burton <paulburton@google.com>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing: Resize tgid_map to PID_MAX_LIMIT, not
 PID_MAX_DEFAULT
Message-ID: <20210630083513.1658a6fb@oasis.local.home>
In-Reply-To: <20210630003406.4013668-2-paulburton@google.com>
References: <20210630003406.4013668-1-paulburton@google.com>
        <20210630003406.4013668-2-paulburton@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Jun 2021 17:34:06 -0700
Paul Burton <paulburton@google.com> wrote:

> On 64 bit systems this will increase the size of tgid_map from 256KiB to
> 16MiB. Whilst this 64x increase in memory overhead sounds significant 64
> bit systems are presumably best placed to accommodate it, and since
> tgid_map is only allocated when the record-tgid option is actually used
> presumably the user would rather it spends sufficient memory to actually
> record the tgids they expect.

NAK. Please see how I fixed this for the saved_cmdlines, and implement
it the same way.

785e3c0a3a87 ("tracing: Map all PIDs to command lines")

It's a cache, it doesn't need to save everything.

-- Steve


> 
> The size of tgid_map will also increase for CONFIG_BASE_SMALL=y
> configurations, but these seem unlikely to be systems upon which people
> are running ftrace with record-tgid anyway.

