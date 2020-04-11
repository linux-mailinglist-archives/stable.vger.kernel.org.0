Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9431A536E
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 20:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgDKSnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 14:43:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32984 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726129AbgDKSnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 14:43:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586630585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gv2Jmnc/kF+XLdJdYOpxXGZr2GETWXGd+W9QP2/fIf8=;
        b=FfOLOWJSVb54mnVr8yqE+4YC+qTBvkP/5ADJqRjmGAhzTtBt9cwMBIDsfZ4wknSmbAuuSR
        N/OWF4bT0A7t4pwEaF8JJYQ7x7f0cqaCaCXF1u20Tkt9x93B7MGEc+BzGYSxsiWtE+lnNu
        lJoOy9swOZlD3ZNSe5/s1X6kyCAnPvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-j8tXNJuUMBaP77xx3hJH6Q-1; Sat, 11 Apr 2020 14:42:57 -0400
X-MC-Unique: j8tXNJuUMBaP77xx3hJH6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C00F618B5F69;
        Sat, 11 Apr 2020 18:42:53 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-94.rdu2.redhat.com [10.10.115.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65B5860C05;
        Sat, 11 Apr 2020 18:42:53 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6CD12C5515; Sat, 11 Apr 2020 15:42:51 -0300 (-03)
Date:   Sat, 11 Apr 2020 15:42:51 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.19 03/54] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200411184251.GM3625@localhost.localdomain>
References: <20200411115508.284500414@linuxfoundation.org>
 <20200411115508.593027768@linuxfoundation.org>
 <20200411182813.GA18221@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200411182813.GA18221@duo.ucw.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 11, 2020 at 08:28:13PM +0200, Pavel Machek wrote:
> Hi!
> 
> > The following case cause the bug:
> > for the trouble SKB, it was in outq->transmitted list
> 
> Ok... but this is one hell of "interesting" code.
> 
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -165,29 +165,44 @@ static void sctp_clear_owner_w(struct sc
> >  	skb_orphan(chunk->skb);
> >  }
> >  
> > +#define traverse_and_process()	\
> > +do {				\
> > +	msg = chunk->msg;	\
> > +	if (msg == prev_msg)	\
> > +		continue;	\
> > +	list_for_each_entry(c, &msg->chunks, frag_list) {	\
> > +		if ((clear && asoc->base.sk == c->skb->sk) ||	\
> > +		    (!clear && asoc->base.sk != c->skb->sk))	\
> > +			cb(c);	\
> > +	}			\
> > +	prev_msg = msg;		\
> > +} while (0)
> 
> Should this be function?
> 
> Do you see how it does "continue"? But the do {} while(0) wrapper eats
> the continue. "break" would be more clear here, but they are really
> equivalent due to way this macro is used.
> 
> It is just very, very confusing.

Agree. The 'continue' itself slipped in on a refactoring and I didn't
notice the confusing aspect of it. Initially, the code was written
without the macro, and the continue refererred to the outter
list_for_each_entry().

  Marcelo

