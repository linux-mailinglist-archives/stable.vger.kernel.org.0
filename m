Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C3114AA5E
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 20:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgA0TTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 14:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgA0TTa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 14:19:30 -0500
Received: from tzanussi-mobl (c-98-220-238-81.hsd1.il.comcast.net [98.220.238.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 627C022527;
        Mon, 27 Jan 2020 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580152769;
        bh=l3hv0mBl+U89dePJkixtoIoZNEwUaj6eI67Zg/RJg4g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N8KfS023Mdid3RRKLAKE7tS2GQGgC4lvtfzfvp8gWJ8N09x42LX92iecxkakQ3G20
         gELH2uAzD2chEMJjOpqXJq+d9P5tXY5fSg1SRh+DxjTqzKPNMqxZk0/25bXf+KdcsX
         0rfXUStlhYgyUahVR2bAbmaRO1eClXLQETJYShg8=
Message-ID: <1580152768.2442.2.camel@kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Fix histogram code when
 expression has same var as" failed to apply to 4.19-stable tree
From:   Tom Zanussi <zanussi@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Date:   Mon, 27 Jan 2020 13:19:28 -0600
In-Reply-To: <20200127135147.5c1ae6d1@gandalf.local.home>
References: <15801394743854@kroah.com> <1580150181.5072.5.camel@kernel.org>
         <20200127135147.5c1ae6d1@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-01-27 at 13:51 -0500, Steven Rostedt wrote:
> On Mon, 27 Jan 2020 12:36:21 -0600
> Tom Zanussi <zanussi@kernel.org> wrote:
> 
> > Hi Steve,
> > 
> > For 4.19, this patch applies if these patches are applied first:
> > 
> > commit 656fe2ba85e81d00e4447bf77b8da2be3c47acb2
> > Author: Tom Zanussi <tom.zanussi@linux.intel.com>
> > Date:   Tue Dec 18 14:33:24 2018 -0600
> > 
> >     tracing: Use hist trigger's var_ref array to destroy var_refs
> > 
> > commit de40f033d4e84e843d6a12266e3869015ea9097c
> > Author: Tom Zanussi <tom.zanussi@linux.intel.com>
> > Date:   Tue Dec 18 14:33:23 2018 -0600
> > 
> >     tracing: Remove open-coding of hist trigger var_ref management
> > 
> > After applying all 3 to 4.19, I built and ran the ftrace/trigger
> > selftests and didn't see any problems.
> > 
> 
> Thanks, I was cherry-picking parts of those changes, but it wasn't
> fixing the issue itself. Let me just backport both of them in full
> and
> see if that works.

It does fix the issue for me and passes the selftests.  Remember that
4.19 doesn't have the .trace() hist action - you need to use the event
name e.g. .first()

Tom

> 
> -- Steve
