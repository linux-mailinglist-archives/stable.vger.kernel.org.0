Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AFC1DE86E
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgEVOCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgEVOCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 10:02:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CB3C061A0E;
        Fri, 22 May 2020 07:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=OUXZvRPeiF/mojQsg9lMgwxM9yFtvY/919qhkqwilpw=; b=ZevlVQBr2F5sB8UdiKCzXAiinB
        wEz/2F3iQMF2ciSBjS6tDwa4wePtukgC3MZqR9w8H0XUTZiSy06U9Nx5uCAqsRVZGdcEF4uG8jwVP
        csbM6cPoiEmFdvkTNKmV5qFA3nDOaauvBQLB78jeUM3dBs31SQ/KUmcsbkcwu/8xTzx1qGT++dO4J
        x4ZbgV67lJxdRunmCONBsv26kwRUBDlB/rx6lPD6hZ1qKsjbIrLrEfNHGsp45zpAFcpnvepkOwnqA
        vOcXs4/ydGKCm8id2RB0x6i04c3++kAH2+gDIfUTTMlvjGxjCR0HK4qEbUN2akfkVj2aIwF6ukuMd
        BUxtmygw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jc8Fo-0000eh-RL; Fri, 22 May 2020 14:02:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7CD2F3011E8;
        Fri, 22 May 2020 16:02:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 43B9C236DF5BA; Fri, 22 May 2020 16:02:26 +0200 (CEST)
Date:   Fri, 22 May 2020 16:02:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Matthew Blecker <matthewb@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Mike Frysinger <vapier@google.com>,
        Christian Brauner <christian@brauner.io>,
        Vineeth Remanan Pillai <vpillai@digitalocean.com>,
        vineethrp@gmail.com, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RFC] sched/headers: Fix sched_setattr userspace
 compilation issues
Message-ID: <20200522140226.GT317569@hirez.programming.kicks-ass.net>
References: <20200521155346.168413-1-joel@joelfernandes.org>
 <CAEXW_YTj83gO0STovrOuL9zgDwEYWRJusUZ3ebVw_jOG6yJxTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXW_YTj83gO0STovrOuL9zgDwEYWRJusUZ3ebVw_jOG6yJxTg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 11:55:21AM -0400, Joel Fernandes wrote:
> On Thu, May 21, 2020 at 11:53 AM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
> >
> > On a modern Linux distro, compiling the following program fails:
> >  #include<stdlib.h>
> >  #include<stdint.h>
> >  #include<pthread.h>
> >  #include<linux/sched/types.h>
> >
> >  void main() {
> >          struct sched_attr sa;
> >
> >          return;
> >  }
> >
> > with:
> > /usr/include/linux/sched/types.h:8:8: \
> >                         error: redefinition of ‘struct sched_param’
> >     8 | struct sched_param {
> >       |        ^~~~~~~~~~~
> > In file included from /usr/include/x86_64-linux-gnu/bits/sched.h:74,
> >                  from /usr/include/sched.h:43,
> >                  from /usr/include/pthread.h:23,
> >                  from /tmp/s.c:4:
> > /usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:23:8:
> > note: originally defined here
> >    23 | struct sched_param
> >       |        ^~~~~~~~~~~
> >
> > This is also causing a problem on using sched_attr Chrome. The issue is
> > sched_param is already provided by glibc.
> >
> > Guard the kernel's UAPI definition of sched_param with __KERNEL__ so
> > that userspace can compile.
> >
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> If it is more preferable, another option is to move sched_param to
> include/linux/sched/types.h

Yeah, not sure. Ingo, you got a preference?

Also, this very much misses a Fixes tag.
