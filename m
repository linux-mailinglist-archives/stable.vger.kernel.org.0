Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E99B6EA4B1
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 09:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjDUH3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 03:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjDUH3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 03:29:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3051FC7
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 00:29:11 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1682062148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CHtFwSveKfuMEcbKMHJasq/dcyK7D9aijgtCVbUg9Qk=;
        b=MoOH+fOrhdDRpVs2ti+9HB5aUucKCjjEAxJCj7M0U1OTVFEtVuPqeEOa5iH40S4xN+M7PZ
        Semk/yGw/Q2JHIxKLEiHqEkQ3yPtFCqZ+KzuEnmqbFABrWFNWotq1MXZiIygi45xqv4zI5
        nJQVVA+jR7s3yb5m/BFEDth7vjBHPs/WfOWWoF5PNMFazfAzH3BX671MbFr4KKQ2yUvbBc
        h8U6AyJU2SQlye0mqyWC8fAuJ2ANPiAlZGxwvggYdwYdmTWhySXTwAAz7fN4vRfcXiRzs8
        5ApLYaxnaqdxE4l24V5rS3zil4lZ/rHU7gsdF121ZOjKOLe7l/XqqtSvq1uupA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1682062148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CHtFwSveKfuMEcbKMHJasq/dcyK7D9aijgtCVbUg9Qk=;
        b=UZ2SwKvS+1LfD0PHD7AD++nLyz63iI54rraM7WTShdTAwxyaiyHmxaghBE19ZfWq/m90dv
        PatRBg74H6lISiCQ==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] rtmutex: Add acquire semantics for rtmutex lock
 acquisition slow path
In-Reply-To: <20230419072546.gD_YO2-K@linutronix.de>
References: <20230418154315.9PD52J2N@linutronix.de>
 <2023041854-cranium-prone-b9fa@gregkh>
 <20230419072546.gD_YO2-K@linutronix.de>
Date:   Fri, 21 Apr 2023 09:29:08 +0200
Message-ID: <87pm7x3d8b.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19 2023 at 09:25, Sebastian Andrzej Siewior wrote:
> On 2023-04-18 18:25:48 [+0200], Greg KH wrote:
>> > Could this be please backported to 5.15 and earlier? It is already part
>> > of the 6.X kernels. I asked about this by the end of January and I'm
>> > kindly asking again ;)
>> 
>> I thought this was only an issues when using the out-of-tree RT patches
>> with these kernels, right?  Or is it relevant for 5.15.y from kernel.org
>> without anything else?
>
> The out-of-tree RT patches make extensive use of the code. Since it is
> upstream code, I assumed it should go via the official stable trees.
> Without RT, the code is limited the rt_mutex_lock() used by I2C and the
> RCU booster-mutex.

Which is a reason to route it through the upstream stable trees, no?

Thanks,

        tglx
