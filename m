Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F326B65B5C0
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 18:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbjABRRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 12:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbjABRRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 12:17:00 -0500
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F3EAE4D;
        Mon,  2 Jan 2023 09:16:57 -0800 (PST)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id A91EE5C1492;
        Mon,  2 Jan 2023 17:08:41 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 25DAE5C1421;
        Mon,  2 Jan 2023 17:08:41 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1672679321; a=rsa-sha256;
        cv=none;
        b=CevlhpuvCBq2jFVL33vVTBEDTBVQF5cgs+s8EdRIzoR3Z5WnewBk5+DuOZvPk+zH7A3aqo
        ORrraxSe84STSKu9qmbO/NlhF+OMS1P8Rb7gbXQlcCWRVwd17MR4g7RuFUEIwjiP7zyb59
        l92kscaxN8BRjVwSRcBKMTC7cd/e4rAsNhUQGesz3SNKgB4gYvG53HLIsMjCZgmEY36Duo
        ZiV9UDl5oYjtilZPiPZNsuTgjJUw+X1oUoYkBA77lowTmqBvu9jMRBKcf9IAcxxXObHMOe
        7HOKuNXXWJMZtkla4R/RxonqemmT/e7K0Yl5/Fd89An5xCVvQ5f1ew27+d9dMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1672679321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=k2XYrG/4ynVE5z72/2qZf7cunlpfjJffh3IPZEvyC2s=;
        b=E7Dr26F8gR6way9QfDzz/uab3qvYWbVN3BDKSW2m5IqH61q8EnM6yxGfJjVOATRdCP3tCu
        nCWIKOrUzq7DZdyrC7tfmL8uNdg3eBLOufobKubNiOsIQzSQ8J5oQNIAmsv0cwHuTcFdXe
        35voTCzTuYun5TBt70gIf5My+S6UqHi4AB2676iS2yuuOGSk7avoYp/KprTAClF0Tqu0DF
        9un16KBeHGTk0aQoDkhea0RJR8G4ankPG7dicZWvOcBVVU7ixYZKLD046g2hdv8gRRUrhh
        3vIoQXCIEjurYiEWmSDFXOfW+h0JkD5GLoN6FP8xTtqOwsWevZPmWFjrTHJ/nw==
ARC-Authentication-Results: i=1;
        rspamd-698c4479bb-f67sb;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Chief-Gusty: 0777170e5748b443_1672679321469_2243893718
X-MC-Loop-Signature: 1672679321469:3072549138
X-MC-Ingress-Time: 1672679321469
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.109.138.37 (trex/6.7.1);
        Mon, 02 Jan 2023 17:08:41 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4Nm2Q02clQz4h;
        Mon,  2 Jan 2023 09:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1672679320;
        bh=k2XYrG/4ynVE5z72/2qZf7cunlpfjJffh3IPZEvyC2s=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=p17bCY0abgPnjRp/skiQ/ES/my3kDU9tHhi5HI5npaTR6FhNZ64unY1eJt7ws9kPa
         BoeP0RNH1orK+qj5SAu3L4yWbnTYdohVY7x62P7gj+mIHSPehkQ9MC9wkyqi4jLXGn
         M/2nWceKXlMjekdiCNCk488ToRGzMr3mwOq+PJ+iBzVP0RQuqBkF4gQESFwLYH1we6
         HMEZt9chRaRQ4hpzOo3yziWdFj2e74AhrcYwYHraYjGfBL5U3wwDKTLG92gHhGP9LY
         6nXefglPg1E9uOmP3/h0BeQOnDS8HCxMNJzzqPNmT4Jv8QgST4L8k6vK0kyfMed1st
         1wKKHIRfALVCw==
Date:   Mon, 2 Jan 2023 08:43:10 -0800
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Paul McKenney <paulmck@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
Message-ID: <20230102164310.2olg7xhwwhzmzg24@offworld>
References: <20230101061555.278129-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230101061555.278129-1-joel@joelfernandes.org>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 01 Jan 2023, Joel Fernandes (Google) wrote:

>During shutdown of rcutorture, the shutdown thread in
>rcu_torture_cleanup() calls torture_cleanup_begin() which sets fullstop
>to FULLSTOP_RMMOD. This is enough to cause the rcutorture threads for
>readers and fakewriters to breakout of their main while loop and start
>shutting down.
>
>Once out of their main loop, they then call torture_kthread_stopping()
>which in turn waits for kthread_stop() to be called, however
>rcu_torture_cleanup() has not even called kthread_stop() on those
>threads yet, it does that a bit later.  However, before it gets a chance
>to do so, torture_kthread_stopping() calls
>schedule_timeout_interruptible(1) in a tight loop. Tracing confirmed
>this makes the timer softirq constantly execute timer callbacks, while
>never returning back to the softirq exit path and is essentially "locked
>up" because of that. If the softirq preempts the shutdown thread,
>kthread_stop() may never be called.
>
>This commit improves the situation dramatically, by increasing timeout
>passed to schedule_timeout_interruptible() 1/20th of a second. This
>causes the timer softirq to not lock up a CPU and everything works fine.
>Testing has shown 100 runs of TREE07 passing reliably, which was not the
>case before because of RCU stalls.
>
>Cc: Paul McKenney <paulmck@kernel.org>
>Cc: Frederic Weisbecker <fweisbec@gmail.com>
>Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
>Cc: <stable@vger.kernel.org> # 6.0.x
>Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
