Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AD41ABC6E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 11:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503680AbgDPJNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 05:13:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33054 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503677AbgDPJNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 05:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587028411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kDbMwf4T7fz2iy2x4sZthu5JgBi4KMPTfc1UBx0b968=;
        b=idNzKgs9MTSlSMyPeEhMT+10692EdGLlbQpatrQN2PeofV3OurQEyKA7LLPTqKkufd1Rkl
        4ACQPhBE2x8OM9LVWFrk5PAKX5ascNidIuyF5YbGAkgwKjnNCFk33HSZJ2mXjLegXK4f+0
        aESijYmEktc7NgHzfLr9p8CwHKiB5mI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-pSsGjVneONSQGO4bbt2LdA-1; Thu, 16 Apr 2020 05:13:28 -0400
X-MC-Unique: pSsGjVneONSQGO4bbt2LdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60E491005513;
        Thu, 16 Apr 2020 09:13:26 +0000 (UTC)
Received: from krava (unknown [10.40.195.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5CF87E7C4;
        Thu, 16 Apr 2020 09:13:23 +0000 (UTC)
Date:   Thu, 16 Apr 2020 11:13:20 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
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
Message-ID: <20200416091320.GA322899@krava>
References: <20200408164641.3299633-1-jolsa@kernel.org>
 <20200409234101.8814f3cbead69337ac5a33fa@kernel.org>
 <20200409184451.GG3309111@krava>
 <20200409201336.GH3309111@krava>
 <20200410093159.0d7000a08fd76c2eaf1398f8@kernel.org>
 <20200414160338.GE208694@krava>
 <20200415090507.GG208694@krava>
 <20200416105506.904b7847a1b621b75463076d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416105506.904b7847a1b621b75463076d@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 10:55:06AM +0900, Masami Hiramatsu wrote:

SNIP

> >           trampoline_handler
> >             kretprobe_hash_lock(current, &head, &flags);  <--- deadlock
> > 
> > Adding kprobe_busy_begin/end helpers that mark code with fake
> > probe installed to prevent triggering of another kprobe within
> > this code.
> > 
> > Using these helpers in kprobe_flush_task, so the probe recursion
> > protection check is hit and the probe is never set to prevent
> > above lockup.
> > 
> > Reported-by: "Ziqian SUN (Zamir)" <zsun@redhat.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> Thanks Jiri and Ziqian!
> 
> Looks good to me.
> 
> Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
> 
> BTW, this is a kind of bugfix. So should it add a Fixes tag?
> 
> Fixes: ef53d9c5e4da ('kprobes: improve kretprobe scalability with hashed locking')
> Cc: stable@vger.kernel.org

ah right, do you want me to repost with those?

thanks,
jirka

