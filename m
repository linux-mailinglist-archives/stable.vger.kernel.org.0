Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672745C00A2
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiIUPBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiIUPBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:01:38 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED684CE32;
        Wed, 21 Sep 2022 08:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZgLg+iakMwAKwuSgDkBgwsil74YzMrT0fyk7bQYAOaQ=; b=XrLeRhY5JtnJeibn5eLYKGs/k/
        kaDfxLHdPX29zp0ITprBqKREL4QTASMn/eztBwMmgH3pJrLLHaTTg5veLBCdAB/Lzv0U3v3nLgxfZ
        Mdru50MXu7B0BShJdbdJ6c6PKgJAynmhiktQVKO/+49RQZFiAZE3ZCI6gMckzvTty/ny6FYGQvKGG
        f7xNUKvRi8OtAZYugKWykDuQrrXc0obnnX2m02tTbx+rMxujO1jN8do4wGhS5qlNOPyOaQGV+458+
        Hm79BtCllUhozaE4sE6I10vAX7EJyyvnzGpUxGKNirxuO8VxjoXtMcvTN0SlPW+rc+w8Hh6KIHOBl
        3ntoLTUg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ob1DK-00EhIH-98; Wed, 21 Sep 2022 15:00:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E6CF6300202;
        Wed, 21 Sep 2022 17:00:35 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C70682BB5A386; Wed, 21 Sep 2022 17:00:35 +0200 (CEST)
Date:   Wed, 21 Sep 2022 17:00:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     K Prateek Nayak <kprateek.nayak@amd.com>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        andi@lisas.de, puwen@hygon.cn, mario.limonciello@amd.com,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <YysnE8rcZAOOj28A@hirez.programming.kicks-ass.net>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921063638.2489-1-kprateek.nayak@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 12:06:38PM +0530, K Prateek Nayak wrote:
> Processors based on the Zen microarchitecture support IOPORT based deeper
> C-states. 

I've just gotta ask; why the heck are you using IO port based idle
states in 2022 ?!?! You have have MWAIT, right?
