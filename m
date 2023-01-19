Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F0B674C2C
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 06:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjATF0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 00:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjATFZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 00:25:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C9E7D662;
        Thu, 19 Jan 2023 21:18:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D42CFB82160;
        Thu, 19 Jan 2023 09:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81734C433F1;
        Thu, 19 Jan 2023 09:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674121938;
        bh=1ORERmWCSjBa6DuNe+EuFeVeTH0DLJwDtrWMVQT58p4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dw2ycJzv26KqoH8PMJnC35LCFBo6OBWS8zm65/BqWjTXPTJC8bhVDrToc6VSbjm1+
         7rM0lsj9aNLCbNHSn38omEEw1Oy9ZFRbVjsXyKagI3s52LnuuNvQDrYACJESVnEG+i
         sG3H9QFFQYkqLBISQ9R1c2aHNyecf6WO4uAhFDW6MnpOIuHAHuyotT0BabRWZIAmdd
         369vmhEJVKZSCTJ/m1ZVrnz7N9QvVAAzIcLiJ4RUCE6zSwwl9xizpczCaH31bVh21b
         9gH2cg5jbqOPHIvPr1IyaRGdvoMVWCMN3VeyoU5m4Zeektx3IqpPPzwtLh40W9YMx5
         XmI1dPqILJA0Q==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pIRai-00326w-87;
        Thu, 19 Jan 2023 09:52:16 +0000
MIME-Version: 1.0
Date:   Thu, 19 Jan 2023 09:52:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     =?UTF-8?Q?=E5=88=98=E7=90=A6?= <liuqi405@icloud.com>
Cc:     daniel.lezcano@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        quic_ylal@quicinc.com, stable@vger.kernel.org, will@kernel.org,
        =?UTF-8?Q?=E7=8E=8B=E6=B3=95?= =?UTF-8?Q?=E6=9D=B0?= 
        <wangfajie@longcheer.com>, liurenwang@longcheer.com,
        zhanghui5@longcheer.com, liangke1@xiaomi.com
Subject: Re: [PATCH] clocksource/drivers/arm_arch_timer: Update sched_clock
 when non-boot CPUs need counter workaround
In-Reply-To: <757D0727-BB99-4FB0-8A7C-70410E9D7BAD@icloud.com>
References: <757D0727-BB99-4FB0-8A7C-70410E9D7BAD@icloud.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6ea81f6e27a3ec4a61088da045da053b@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: liuqi405@icloud.com, daniel.lezcano@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, mark.rutland@arm.com, quic_ylal@quicinc.com, stable@vger.kernel.org, will@kernel.org, wangfajie@longcheer.com, liurenwang@longcheer.com, zhanghui5@longcheer.com, liangke1@xiaomi.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-19 07:59, 刘琦 wrote:
> [Test Report]
> Result: Test Pass
> 
> A total of two rounds of pending testing
>      a. The first round of hanging test
>           Number of machines: 200
>           Hanging test duration: 48h
>           Hanging test results: no walt crash problem
>      b. The second round of hanging test
>           Number of machines: 200
>           Hanging test duration: 72h
>           Hanging test results: no walt crash problem
> 
> Tested-by: wangfajie <wangfajie@longcheer.com>
> Tested-by: liurenwang <liurenwang@longcheer.com>
> Tested-by: zhanghui <zhanghui5@longcheer.com>
> Tested-by: liangke <liangke1@xiaomi.com>

Thanks for this.

The only issue here is that that you don't explain what you tested,
nor how you tested it.

It is also a patch that has known defects (you just have to read the
thread for the details)... This makes this testing, no matter how
thorough it is, rather ineffective.

         M.
-- 
Jazz is not dead. It just smells funny...
