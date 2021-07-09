Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FE73C21CC
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 11:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhGIJwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 05:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGIJwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 05:52:31 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856A1C0613DD;
        Fri,  9 Jul 2021 02:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0kTIveI67GwL6RzLsniXf7MeZmiCrVUqw3VGiS33bq0=; b=WpHvRUhYxpZ05zPkTq65Oz/uwF
        WHHU1UAaYniBHgVWeCihpEM/hHJm4jX680Fc95f+t9jTT/XYMzndCBgdJs1V3NeNCjLxiOiStrxVe
        irMibyYgY7SCkfEeTFg/AP9nxl2ekh5Yxo2Vp9uWx4m9LKCbRLWQ3SBPqJ0JmB8ArCbk2SU0UFpj3
        i0Fn5doi7lq1G18NjSAmRtjgfnC6r+euHvy5QXIQsXtgGItQ0alPT5XZWPAzzGw51DnBGwxXsf9CH
        kMN+nJsrVMtgnGx+qA7GU4KF8Y7eSK1oPQ3vZg2fXAYJgdhAf1PC7iCHKUU4PM/8HudqNLRFRNguN
        7++kAY1w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1n8f-00G2tt-0j; Fri, 09 Jul 2021 09:49:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0534B30022B;
        Fri,  9 Jul 2021 11:49:39 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D66E2201F6C2E; Fri,  9 Jul 2021 11:49:39 +0200 (CEST)
Date:   Fri, 9 Jul 2021 11:49:39 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     kan.liang@linux.intel.com
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel: Apply early ACK for small core
Message-ID: <YOgbs6i9Q/EoGDj9@hirez.programming.kicks-ass.net>
References: <1625774073-153697-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625774073-153697-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 12:54:33PM -0700, kan.liang@linux.intel.com wrote:
> @@ -2921,7 +2920,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>  	 * No known reason to not always do late ACK,
>  	 * but just in case do it opt-in.
>  	 */

^^^ comment is now seriously out of date. Can you please update it?

> -	if (!x86_pmu.late_ack)
> +	if (!late_ack)
>  		apic_write(APIC_LVTPC, APIC_DM_NMI);
