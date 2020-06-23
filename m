Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C4C20535F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 15:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbgFWN0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 09:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729629AbgFWN0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 09:26:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53E7E20724;
        Tue, 23 Jun 2020 13:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592918789;
        bh=ZDGwJLe81XKEYdccsxZshQmKzBG+Teh10gIWfv/5hrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JbFSLECnrHHIep+Fexh7umX6OeaIyGWGGvp+EDEMe91adeD3NOe4MSWAyqsSkDWcG
         VEMeiJnUI3Xy0eUPK0xmJVgA3ulN0Q1RAQ0L2IfZjtUz1Btfh0TlaDB3v3yNBz6vjS
         VWkxUs74K9SkuDijkWT0Rb6/VGhW23GbrnJhNgVM=
Date:   Tue, 23 Jun 2020 09:26:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mhiramat@kernel.org, anders.roxell@linaro.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        gustavoars@kernel.org, mingo@elte.hu, mingo@kernel.org,
        naveen.n.rao@linux.ibm.com, peterz@infradead.org,
        rostedt@goodmis.org, zsun@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kprobes: Fix to protect
 kick_kprobe_optimizer() by" failed to apply to 4.9-stable tree
Message-ID: <20200623132628.GX1931@sasha-vm>
References: <159291344624382@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159291344624382@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 01:57:26PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 1a0aa991a6274161c95a844c58cfb801d681eb59 Mon Sep 17 00:00:00 2001
>From: Masami Hiramatsu <mhiramat@kernel.org>
>Date: Tue, 12 May 2020 17:02:56 +0900
>Subject: [PATCH] kprobes: Fix to protect kick_kprobe_optimizer() by
> kprobe_mutex
>
>In kprobe_optimizer() kick_kprobe_optimizer() is called
>without kprobe_mutex, but this can race with other caller
>which is protected by kprobe_mutex.
>
>To fix that, expand kprobe_mutex protected area to protect
>kick_kprobe_optimizer() call.
>
>Link: http://lkml.kernel.org/r/158927057586.27680.5036330063955940456.stgit@devnote2
>
>Fixes: cd7ebe2298ff ("kprobes: Use text_poke_smp_batch for optimizing")
>Cc: Ingo Molnar <mingo@kernel.org>
>Cc: "Gustavo A . R . Silva" <gustavoars@kernel.org>
>Cc: Anders Roxell <anders.roxell@linaro.org>
>Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
>Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>Cc: David Miller <davem@davemloft.net>
>Cc: Ingo Molnar <mingo@elte.hu>
>Cc: Peter Zijlstra <peterz@infradead.org>
>Cc: Ziqian SUN <zsun@redhat.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
>Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

The conflict happened because we don't have 2d1e38f56622 ("kprobes: Cure
hotplug lock ordering issues") on 4.9 and 4.4. I've fixed it up and
queued for both branches.

-- 
Thanks,
Sasha
