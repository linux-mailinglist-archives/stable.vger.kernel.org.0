Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7063D650A7D
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 11:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiLSK7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 05:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiLSK7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 05:59:44 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C75BB;
        Mon, 19 Dec 2022 02:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iwo/jJFl/Dhn1CRlJw0Sj+lFmQiUDcd14xHBrPkn8OQ=; b=LNQnpk7bSgySSRdqxKBA17IL1Z
        j1QYdfSCgQerCEdQIcsmbMu4TV5/8Pg/BLHOvCzgeD7BOq6VvMNBSEBd8DVpYFoRC/JNnqpMRW71I
        WI2otZOTLfxYGWOCPVrraT6QUnSpGBkaiSmGYWr+AXBwrJxbDWAGao6U/eRb/EnvkxRHwjiHWDyyk
        ZTvazOkVA3oyM9KpTxjvtJ2zA35Zs5VlZRsFVHD7or+wuVAIY4G/ZH/iX+D9vyHAqqt9ydO+Fm6Ys
        8Hs0eNf3TqChdiADU+ql3ZD0m2vHAX/TXsXIdvZSELhDTURgGCFwQJwez75XSp/Ks/lJjoLCXbiaF
        rnBu8Dxg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p7DrK-00CYLT-3A;
        Mon, 19 Dec 2022 10:59:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 498E1300348;
        Mon, 19 Dec 2022 11:59:01 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 27714202FE504; Mon, 19 Dec 2022 11:59:01 +0100 (CET)
Date:   Mon, 19 Dec 2022 11:59:01 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Greg KH <greg@kroah.com>
Cc:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net,
        kernel-dev@igalia.com, kernel@gpiccoli.net, fenghua.yu@intel.com,
        joshua@froggi.es, pgofman@codeweavers.com, pavel@denx.de,
        pgriffais@valvesoftware.com, zfigura@codeweavers.com,
        cristian.ciocaltea@collabora.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andre Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH 6.0.y / 6.1.y] x86/split_lock: Add sysctl to control the
 misery mode
Message-ID: <Y6BD9W7hk4CjhSdh@hirez.programming.kicks-ass.net>
References: <20221218234400.795055-1-gpiccoli@igalia.com>
 <Y6A6Q57/qz7w7cxM@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6A6Q57/qz7w7cxM@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 11:17:39AM +0100, Greg KH wrote:

> What specific programs have this problem and what are the exact results
> of it?

IIRC it was God of War (2018) that triggered this initially. But it's
possible more games were found to tickle this specific thing. Since it's
binary only gunk that is unlikely to ever get fixed we need something to
allow for it.

(slow motion Kratos yelling B...o...y...)

> Also, this is really a new feature and not really a "fix", but one could
> argue a lot that this is a "resolve a performance problem" if you want
> to and have the numbers to back it up  {hint}

Right, there were some, they should indeed have been included.
