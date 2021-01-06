Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C612EBC84
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 11:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbhAFKgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 05:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbhAFKgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 05:36:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63CAC061357;
        Wed,  6 Jan 2021 02:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bVpL1mGdE1znAIBZqUAoV1hHGWEPvW8K3ojw3xc9b+M=; b=omZNe+9FXXLxjBfSEMIE4cUKb3
        rnyZVbDU3fbqcK9qpv/Ck2jBkMrwr3aQiL//361OiVvEoUbCdEFQu18X82YROGTWUED3YQ0MyJzgM
        h9Zaw3jVVldE335/DSoyOnvxXo+jexl+7ddRehUhOV5JaqMmuLtlcSvDPEh8L8ZAhX77gtaNDYnJP
        hBql9d3ZRNJfxEAyuCUpFDxIvk5GCmmht89lB5rnLjmnN+YFvZLcoJDI2kX3Mp5mV/MiowQoGMXi3
        PBaiGYGtxll9pO/IlDnllQlS7f3wCuHU0XTGFXujT4c3l6p/wvHRX0iukAPsj5JAnvCPsRMELE7/r
        AAuiuMMA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kx68E-002Ewa-Ib; Wed, 06 Jan 2021 10:34:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 99A053013E5;
        Wed,  6 Jan 2021 11:33:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 88C6E2029F4C3; Wed,  6 Jan 2021 11:33:33 +0100 (CET)
Date:   Wed, 6 Jan 2021 11:33:33 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/4] sched/idle: Fix missing need_resched() check after
 rcu_idle_enter()
Message-ID: <X/WR/QSrKTdfRgGt@hirez.programming.kicks-ass.net>
References: <20210104152058.36642-1-frederic@kernel.org>
 <20210104152058.36642-2-frederic@kernel.org>
 <20210105095503.GF3040@hirez.programming.kicks-ass.net>
 <20210105125722.GA68490@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105125722.GA68490@lothringen>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 01:57:22PM +0100, Frederic Weisbecker wrote:

> > Something like the below, combined with a fixup for all callers (which
> > the compiler will help us find thanks to __must_check).
> 
> Right, I just need to make sure that the wake up is local as the kthread
> awaken can be queued anywhere. But a simple need_resched() check after the
> wake up should be fine to get that.

Duh, yes. Clearly I'm having startup problems after the holidays ;-)
