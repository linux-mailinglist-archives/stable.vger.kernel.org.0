Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0E31C0E64
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 08:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgEAGxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 02:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgEAGxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 02:53:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80A68206B8;
        Fri,  1 May 2020 06:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588316027;
        bh=xHpZtYqj3y198WrS0KhWjKFHdACJCDE4d5NVEHIU/+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=haov/6SaAnyNo3aOzXVG48dX6671D5xEd9/lF4w6jtlxRtFwzoodfNJSLwA6tXAZB
         UMBVaudd4LAkCL7UOXmD29xSGwYZUzmOU2NCuc+uOWfAGD6EOrr5P13uKUNJo0GDQ+
         ABMGXD7FCH87X8kF+8QO9I+VOQQ+axmfH2JTl2HU=
Date:   Fri, 1 May 2020 08:53:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wang YanQing <udknight@gmail.com>
Cc:     stable@vger.kernel.org, lukenels@cs.washington.edu, ast@kernel.org,
        luke.r.nels@gmail.com, xi.wang@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: Re: [PATCH] bpf, x86_32: Fix clobbering of dst for BPF_JSET
Message-ID: <20200501065344.GA874145@kroah.com>
References: <20200501031950.GA4782@udknight>
 <20200501034228.GA4956@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501034228.GA4956@udknight>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 11:42:28AM +0800, Wang YanQing wrote:
> On Fri, May 01, 2020 at 11:19:50AM +0800, Wang YanQing wrote:
> > commit 50fe7ebb6475711c15b3397467e6424e20026d94 upstream.
> > 
> > The current JIT clobbers the destination register for BPF_JSET BPF_X
> > and BPF_K by using "and" and "or" instructions. This is fine when the
> > destination register is a temporary loaded from a register stored on
> > the stack but not otherwise.
> > 
> > This patch fixes the problem (for both BPF_K and BPF_X) by always loading
> > the destination register into temporaries since BPF_JSET should not
> > modify the destination register.
> > 
> > This bug may not be currently triggerable as BPF_REG_AX is the only
> > register not stored on the stack and the verifier uses it in a limited
> > way.
> > 
> > Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
> > Signed-off-by: Xi Wang <xi.wang@gmail.com>
> > Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Acked-by: Wang YanQing <udknight@gmail.com>
> > Link: https://lore.kernel.org/bpf/20200422173630.8351-2-luke.r.nels@gmail.com
> > Signed-off-by: Wang YanQing <udknight@gmail.com>
> Cc: stable@vger.kernel.org #v4.19

Now queued up, thanks.

greg k-h
