Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6C037BF01
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 15:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhELN6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 09:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhELN6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 09:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C279A613E6;
        Wed, 12 May 2021 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620827812;
        bh=/SwytpLER53SoKzsVJV7vjHf+tL0HeRqhOfb5H2UgdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=COSfFeTxRcJc1odUwvtipkiiOeYT4ZyF7gHFY0Z0hQfA0xVDrFUIYuUeyqNNp6dNf
         ul3krEiHIX40EsAAQHE3/TEAspzMU01SmtLbJ0dmBWiC3CeAXb7jZX4Rz6haRPhi2R
         RL1+UU8RbEOlTjxDr6oIpjmJ3W+IlTA2I8yY+pfs=
Date:   Wed, 12 May 2021 15:56:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     lucien.xin@gmail.com, davem@davemloft.net,
        orcohen@paloaltonetworks.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] sctp: delay auto_asconf init until
 binding the first addr" failed to apply to 5.12-stable tree
Message-ID: <YJveoauWrzbeJ6U/@kroah.com>
References: <162082148164230@kroah.com>
 <YJvLguBJ8zTUptlX@eldamar.lan>
 <YJvMxr1XwARM1ClT@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJvMxr1XwARM1ClT@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 02:40:38PM +0200, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Wed, May 12, 2021 at 02:35:16PM +0200, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > [disclaimer, just commenting as a bystander, noticing this failed
> > apply]
> > 
> > On Wed, May 12, 2021 at 02:11:21PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.12-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > > From 34e5b01186858b36c4d7c87e1a025071e8e2401f Mon Sep 17 00:00:00 2001
> > > From: Xin Long <lucien.xin@gmail.com>
> > > Date: Mon, 3 May 2021 05:11:42 +0800
> > > Subject: [PATCH] sctp: delay auto_asconf init until binding the first addr
> > > 
> > > As Or Cohen described:
> > > 
> > >   If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
> > >   held and sp->do_auto_asconf is true, then an element is removed
> > >   from the auto_asconf_splist without any proper locking.
> > > 
> > >   This can happen in the following functions:
> > >   1. In sctp_accept, if sctp_sock_migrate fails.
> > >   2. In inet_create or inet6_create, if there is a bpf program
> > >      attached to BPF_CGROUP_INET_SOCK_CREATE which denies
> > >      creation of the sctp socket.
> > > 
> > > This patch is to fix it by moving the auto_asconf init out of
> > > sctp_init_sock(), by which inet_create()/inet6_create() won't
> > > need to operate it in sctp_destroy_sock() when calling
> > > sk_common_release().
> > > 
> > > It also makes more sense to do auto_asconf init while binding the
> > > first addr, as auto_asconf actually requires an ANY addr bind,
> > > see it in sctp_addr_wq_timeout_handler().
> > > 
> > > This addresses CVE-2021-23133.
> > > 
> > > Fixes: 610236587600 ("bpf: Add new cgroup attach type to enable sock modifications")
> > > Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > 
> > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > index 76a388b5021c..40f9f6c4a0a1 100644
> > > --- a/net/sctp/socket.c
> > > +++ b/net/sctp/socket.c
> > > @@ -357,6 +357,18 @@ static struct sctp_af *sctp_sockaddr_af(struct sctp_sock *opt,
> > >  	return af;
> > >  }
> > >  
> > > +static void sctp_auto_asconf_init(struct sctp_sock *sp)
> > > +{
> > > +	struct net *net = sock_net(&sp->inet.sk);
> > > +
> > > +	if (net->sctp.default_auto_asconf) {
> > > +		spin_lock(&net->sctp.addr_wq_lock);
> > > +		list_add_tail(&sp->auto_asconf_list, &net->sctp.auto_asconf_splist);
> > > +		spin_unlock(&net->sctp.addr_wq_lock);
> > > +		sp->do_auto_asconf = 1;
> > > +	}
> > > +}
> > > +
> > >  /* Bind a local address either to an endpoint or to an association.  */
> > >  static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> > >  {
> > > @@ -418,8 +430,10 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
> > >  		return -EADDRINUSE;
> > >  
> > >  	/* Refresh ephemeral port.  */
> > > -	if (!bp->port)
> > > +	if (!bp->port) {
> > >  		bp->port = inet_sk(sk)->inet_num;
> > > +		sctp_auto_asconf_init(sp);
> > > +	}
> > >  
> > >  	/* Add the address to the bind address list.
> > >  	 * Use GFP_ATOMIC since BHs will be disabled.
> > > @@ -4993,19 +5007,6 @@ static int sctp_init_sock(struct sock *sk)
> > >  	sk_sockets_allocated_inc(sk);
> > >  	sock_prot_inuse_add(net, sk->sk_prot, 1);
> > >  
> > > -	/* Nothing can fail after this block, otherwise
> > > -	 * sctp_destroy_sock() will be called without addr_wq_lock held
> > > -	 */
> > > -	if (net->sctp.default_auto_asconf) {
> > > -		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
> > > -		list_add_tail(&sp->auto_asconf_list,
> > > -		    &net->sctp.auto_asconf_splist);
> > > -		sp->do_auto_asconf = 1;
> > > -		spin_unlock(&sock_net(sk)->sctp.addr_wq_lock);
> > > -	} else {
> > > -		sp->do_auto_asconf = 0;
> > > -	}
> > > -
> > >  	local_bh_enable();
> > >  
> > >  	return 0;
> > > @@ -9401,6 +9402,8 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> > >  			return err;
> > >  	}
> > >  
> > > +	sctp_auto_asconf_init(newsp);
> > > +
> > >  	/* Move any messages in the old socket's receive queue that are for the
> > >  	 * peeled off association to the new socket's receive queue.
> > >  	 */
> > > 
> > 
> > Before applying this patch one needs to revert first
> > b166a20b07382b8bc1dcee2a448715c9c2c81b5b .
> > 
> > So first apply 01bfe5e8e428 ("Revert "net/sctp: fix race condition in
> > sctp_destroy_sock"") and then apply 34e5b0118685 ("sctp: delay
> > auto_asconf init until binding the first addr").
> 
> Forgot to mention: At least for back to 5.10.y this should be the
> problem for the patch not applying. Not checked for older series
> further.

Thank you, that worked!

greg k-h
