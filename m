Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1356E4649
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 13:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjDQLWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 07:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjDQLWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 07:22:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F986135;
        Mon, 17 Apr 2023 04:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GgEqcuO3bbvAsK7wAkwmlSOx0DBqrerOevI4PeRVwUY=; b=JbKPCR55W8FRNyQwTjDNOYTFMP
        NhkgQR8f0KlF4XiO4AnQCAtsntHHCrzvt8nuHC76oWWaO059gRqanmeTfqiD3mQS+sGPHmdX+jgi9
        3uWDql5rkAQQz8QSEyXzGFyWenFe0oOS7Wc4LnALvJjSQeUdAszYeHvd3lmFSLLPzdGZ5JdqwNg86
        4YP7caJWIrFeeLc3nUqOrDSYZ4kA+0435y6jzNu1r9eZmBNR+Q9qkIV/jrcwJCIhG2hEd8mzy2RKR
        v5Et+5Ro7qmeps+u0xZm49qQGVFfLgBDIdS6q3XS9fBSznqHU9sRdbLnsqKtu+8QIl+py0f8Ztcv5
        PboVCvjw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1poMti-00BHe6-Cy; Mon, 17 Apr 2023 11:19:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DD55E3001E5;
        Mon, 17 Apr 2023 13:19:49 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B95C224248706; Mon, 17 Apr 2023 13:19:49 +0200 (CEST)
Date:   Mon, 17 Apr 2023 13:19:49 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     John Stultz <jstultz@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Tim Murray <timmurray@google.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] locking/rwsem: Add __always_inline annotation to
 __down_read_common()
Message-ID: <20230417111949.GJ83892@hirez.programming.kicks-ass.net>
References: <20230412023839.2869114-1-jstultz@google.com>
 <20230412035905.3184199-1-jstultz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412035905.3184199-1-jstultz@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 03:59:05AM +0000, John Stultz wrote:
> Apparently despite it being marked inline, the compiler
> may not inline __down_read_common() which makes it difficult
> to identify the cause of lock contention, as the blocked
> function will always be listed as __down_read_common().
> 
> So this patch adds __always_inline annotation to the
> function to force it to be inlines so the calling function
> will be listed.

I'm a wee bit confused; what are you looking at? Wchan? What is stopping
the compiler from now handing you
__down_read{,_interruptible,_killable}() instead? Is that fine?
