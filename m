Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4201ACA1D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410374AbgDPPb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392171AbgDPNm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:56 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5779720732;
        Thu, 16 Apr 2020 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044576;
        bh=pKr2ODiezIbXVsIZUlYbDhELk4vhbLO4dwd5JanhVDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DYDoeT+4hlWnZScNJWKzbPVJP6AmaxiEBcN9QaCMwpYR+ioBzx5PL3FhzIHC2+c/+
         RtXULmJ+QUoHFlldeF7OO8+NpY0b6xRd4MEh28kb8NOorpCxOltXVb4oSb79+AIqvn
         UMDWYBszSdyr4a5FPV5Dcb7rjUAOmOj9YorEfYTo=
Date:   Thu, 16 Apr 2020 22:42:50 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "bibo,mao" <bibo.mao@intel.com>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] kretprobe: Prevent triggering kretprobe from within
 kprobe_flush_task
Message-Id: <20200416224250.7a53fb581e50aa32df75a0cf@kernel.org>
In-Reply-To: <20200416091320.GA322899@krava>
References: <20200408164641.3299633-1-jolsa@kernel.org>
        <20200409234101.8814f3cbead69337ac5a33fa@kernel.org>
        <20200409184451.GG3309111@krava>
        <20200409201336.GH3309111@krava>
        <20200410093159.0d7000a08fd76c2eaf1398f8@kernel.org>
        <20200414160338.GE208694@krava>
        <20200415090507.GG208694@krava>
        <20200416105506.904b7847a1b621b75463076d@kernel.org>
        <20200416091320.GA322899@krava>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jiri,

On Thu, 16 Apr 2020 11:13:20 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, Apr 16, 2020 at 10:55:06AM +0900, Masami Hiramatsu wrote:
> 
> SNIP
> 
> > >           trampoline_handler
> > >             kretprobe_hash_lock(current, &head, &flags);  <--- deadlock
> > > 
> > > Adding kprobe_busy_begin/end helpers that mark code with fake
> > > probe installed to prevent triggering of another kprobe within
> > > this code.
> > > 
> > > Using these helpers in kprobe_flush_task, so the probe recursion
> > > protection check is hit and the probe is never set to prevent
> > > above lockup.
> > > 
> > > Reported-by: "Ziqian SUN (Zamir)" <zsun@redhat.com>
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > 
> > Thanks Jiri and Ziqian!
> > 
> > Looks good to me.
> > 
> > Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
> > 
> > BTW, this is a kind of bugfix. So should it add a Fixes tag?
> > 
> > Fixes: ef53d9c5e4da ('kprobes: improve kretprobe scalability with hashed locking')
> > Cc: stable@vger.kernel.org
> 
> ah right, do you want me to repost with those?

Yeah, if you don't mind.

Thank you,

> 
> thanks,
> jirka
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
