Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629914AA810
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 11:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379682AbiBEKZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 05:25:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56028 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379582AbiBEKZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 05:25:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A614B800A0;
        Sat,  5 Feb 2022 10:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED48C340E8;
        Sat,  5 Feb 2022 10:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644056714;
        bh=m5/8Lj0nKxs/YQ8i1NLT5kNMA/irs6BRBsv3oIJ/Pok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t9Wf7YX/pe4yj5VB4fEwkCMwe+EpK1xTkK91h0DFzTlTpEB/W9uG5ujnFnK6aFVq2
         Xh36OHA8mxopKwjU2KM3iP5h4t62eJGohHxFO4z8T2BGffJWh17H7+XudSDGCYW74y
         14mEONEO+ilPkBH+O+ZOLKitTpd87tNpOLWr/wqw=
Date:   Sat, 5 Feb 2022 11:25:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH 5.10 08/25] perf: Rework perf_event_exit_event()
Message-ID: <Yf5QhydMcw5IcJj9@kroah.com>
References: <20220204091914.280602669@linuxfoundation.org>
 <20220204091914.560626177@linuxfoundation.org>
 <20220204093734.GA27857@amd>
 <Yfz0nWtyap5Y3ogJ@kroah.com>
 <20220204101249.GB27857@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204101249.GB27857@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 11:12:49AM +0100, Pavel Machek wrote:
> On Fri 2022-02-04 10:40:45, Greg Kroah-Hartman wrote:
> > On Fri, Feb 04, 2022 at 10:37:35AM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > From: Peter Zijlstra <peterz@infradead.org>
> > > > 
> > > > commit ef54c1a476aef7eef26fe13ea10dc090952c00f8 upstream.
> > > > 
> > > > Make perf_event_exit_event() more robust, such that we can use it from
> > > > other contexts. Specifically the up and coming remove_on_exec.
> > > 
> > > Do we need this in 5.10? AFAICT the remove_on_exec work is not queued
> > > for 5.10, and this patch is buggy and needs following one to fix it
> > > up.
> > 
> > It's needed by the following patch, which says 5.10 is affected.
> 
> 9/25 says this patch broke 5.10: Fixes: ef54c1a476ae ("perf: Rework
> perf_event_exit_event()"). 8/25 is not claiming to fix anything.
> 
> Simply drop 8/25 and 9/25, and 5.10 is okay...

Ah, yeah, the patch this was to fix was added and then reverted which
confused things.  I'll go drop both of these now, thanks.

greg k-h
