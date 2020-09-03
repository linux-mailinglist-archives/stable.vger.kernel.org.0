Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51A925C650
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 18:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgICQM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 12:12:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42265 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728129AbgICQM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Sep 2020 12:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599149576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jb6az/wiJ7iQDSTih1JXhdvoZ61BGF79Va40zCSQyzA=;
        b=geW/g40yDeDIbj7/OKMAZUouSn0P3eu2QWuNVSTreqDcrmP5mRAkS4gEXXTXNfkTtPohzH
        CaoduUS7WCDikCl3Zjup3bbh8vbHAQo2g6ZHHJD503mVGqfosOE9NxOFBGE7uVYQvu5HCq
        Tx3FUlfT3cuCcglN5y0MzrjtfGfmYjU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-vX8ldPkDOVm1ZQ9ioxF1lw-1; Thu, 03 Sep 2020 12:12:54 -0400
X-MC-Unique: vX8ldPkDOVm1ZQ9ioxF1lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09A5480B702;
        Thu,  3 Sep 2020 16:12:52 +0000 (UTC)
Received: from treble (ovpn-117-249.rdu2.redhat.com [10.10.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 067215C1C2;
        Thu,  3 Sep 2020 16:12:47 +0000 (UTC)
Date:   Thu, 3 Sep 2020 11:12:45 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Kyle Huey <me@kylehuey.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robert O'Callahan <rocallahan@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Brian Gerst <brgerst@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/13] x86/debug: Allow a single level of #DB recursion
Message-ID: <20200903161245.dp56m3p3oimgppcf@treble>
References: <20200902132549.496605622@infradead.org>
 <20200902133200.726584153@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200902133200.726584153@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 03:25:51PM +0200, Peter Zijlstra wrote:
> @@ -863,6 +849,18 @@ static void handle_debug(struct pt_regs
>  static __always_inline void exc_debug_kernel(struct pt_regs *regs,
>  					     unsigned long dr6)
>  {
> +	/*
> +	 * Disable breakpoints during exception handling; recursive exceptions
> +	 * are exceedingly 'fun'.
> +	 *
> +	 * Since this function is NOKPROBE, and that also applies to
> +	 * HW_BREAKPOINT_X, we can't hit a breakpoint before this (XXX except a
> +	 * HW_BREAKPOINT_W on our stack)
> +	 *
> +	 * Entry text is excluded for HW_BP_X and cpu_entry_area, which
> +	 * includes the entry stack is excluded for everything.
> +	 */

I know this comment was copy/pasted, but I had to stare at the last
paragraph like one of those 3D paintings they used to have at the mall.

Recommended rewording:

	 * HW_BREAKPOINT_X is disallowed for entry text; all breakpoints
	 * are disallowed for cpu_entry_area (which includes the entry
	 * stack).

-- 
Josh

