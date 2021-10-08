Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC1A426658
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhJHJMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 05:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhJHJMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 05:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C41326103C;
        Fri,  8 Oct 2021 09:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633684256;
        bh=cRTZAOr+OnqMcQqKUZYCy+0dx50CX/Fm2+LAZGp0FoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B/iOn7fZ65LZbl5QV7sdyzjoLrjGnzq//t3LqwuvyG997DPjx9Etqz/kxuNLPTPjB
         rVNqZVf5vqnJCLPczb2U4HlrMFZj8/IeRTtJXS384SyfitL4p4khNLtQFXbJo+pbmQ
         JFY9sDl2uFcBXSEmf++Ss96sQMfuzNsM8scnu4HY=
Date:   Fri, 8 Oct 2021 11:10:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Davidlohr Bueso <dbueso@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH for 4.14 and 4.19] lib/timerqueue: Rely on rbtree
 semantics for next timer
Message-ID: <YWALHdipnUQT6mBQ@kroah.com>
References: <20211007123243.595438-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007123243.595438-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 07, 2021 at 09:32:43PM +0900, Nobuhiro Iwamatsu wrote:
> From: Davidlohr Bueso <dave@stgolabs.net>
> 
> commit 511885d7061eda3eb1faf3f57dcc936ff75863f1 upstream.
> 
> Simplify the timerqueue code by using cached rbtrees and rely on the tree
> leftmost node semantics to get the timer with earliest expiration time.
> This is a drop in conversion, and therefore semantics remain untouched.
> 
> The runtime overhead of cached rbtrees is be pretty much the same as the
> current head->next method, noting that when removing the leftmost node,
> a common operation for the timerqueue, the rb_next(leftmost) is O(1) as
> well, so the next timer will either be the right node or its parent.
> Therefore no extra pointer chasing. Finally, the size of the struct
> timerqueue_head remains the same.
> 
> Passes several hours of rcutorture.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lkml.kernel.org/r/20190724152323.bojciei3muvfxalm@linux-r8p5
> Reference: CVE-2021-20317
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---

Now queued up, thanks.

greg k-h
