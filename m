Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3DA1E1C9E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 09:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbgEZH5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 03:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731406AbgEZH5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 03:57:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6922CC08C5C0;
        Tue, 26 May 2020 00:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R5qQvczynsAgfGpBqLmrdkhBv7EbYOge1iugVDT5SBA=; b=TE//yoNU7+3UOMY3O60qcivn8i
        sZ3MnaWQtU9hZ2Qo3MhIJmOUtCiv6O3ZcG1Tsi8Hz1VMx9j1zQ0TxV/YT2FhskgmFKR2xjU6B9OdW
        bpis4SfDnCWwt1BhW0SYlcgQnsrzPaaTVISdrJjCzTZkaKlZBkdUCBCa60+cDdl11SFiJavhylT1t
        rjUm4J6lqpyylhU5qBeAt42mB6HNTXXyOcGp6iSDuQwpcIBSobd8LnuwvOzebFrrc04h8AkYOVZ2H
        HfYk7eu/QFgf+v8NhYuLShFW9xsYjvitpuMY59+eqpNnj5ylqeiXH2WbSL/kuLwgcNzvLy+AWmzbi
        RODjFOFg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdUSx-0008AQ-TD; Tue, 26 May 2020 07:57:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1000930280E;
        Tue, 26 May 2020 09:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F277320BE0DF0; Tue, 26 May 2020 09:57:36 +0200 (CEST)
Date:   Tue, 26 May 2020 09:57:36 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, Andi Kleen <ak@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526075736.GH317569@hirez.programming.kicks-ass.net>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526065618.GC2580410@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Since there seem to be kernel modules floating around that set
> > FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> > CR4 pinning just checks that bits are set, this also checks
> > that the FSGSBASE bit is not set, and if it is clears it again.
> 
> So we are trying to "protect" ourselves from broken out-of-tree kernel
> modules now?  Why stop with this type of check, why not just forbid them
> entirely if we don't trust them?  :)

Oh, I have a bunch of patches pending for that :-)

It will basically decode the module text and refuse to load the module
for most CPL0 instruction.
