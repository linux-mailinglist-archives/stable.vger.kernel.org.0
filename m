Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E76546700
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 15:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbiFJNBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 09:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiFJNBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 09:01:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE7FE77F1
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 06:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A1A8B8348D
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 13:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD12C34114;
        Fri, 10 Jun 2022 13:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654866100;
        bh=QLOQ2yk9PRjVD6UGvC1kCCj/5eNYDNx+e4F1IGvT1OE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F8KYEiIYSfpe/7vVUhK/waQ7fBaeJ6UtjpdccbMpaLlevxoFKaPMNdna1L6VWb38j
         61Cm2F5B8PTZivw8Dy51Qytp1mPudLNrvv0YY+6fP3MtMJMLu+2ForOpciVs8aVBCn
         O83YUSBsI8k/ExjQeieAB2ikNr0+cqYOz7IY7tFlu3dgfA/wGsC8vVnNZl8k6IVHvi
         GbWGMCisTJIX/KhdV0bm9HD/4Q55quUxRDJwCq+yc++9QrJUGIqgmPmUR12kW6M2wT
         bXdSOnzubdahQ9NqJkQuPvZKL+kxogVmYnZkKlkFB4gBd8W6YE9XXyUwEM1AdlaIXd
         B8ddMGD/vrUnQ==
Date:   Fri, 10 Jun 2022 09:01:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Greg Kroah-Hartman <gregkh@google.com>,
        Sasha Levin <sashalevin@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 4.9 LTS inclusion request for "net: fix nla_strcmp to handle
 more then one trailing null character"
Message-ID: <YqNAspwWkbEDXpji@sashalap>
References: <CANP3RGezxyXRmX3_cuXksjjcNkzbi+EOe7biMQRAdroV9DMhkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGezxyXRmX3_cuXksjjcNkzbi+EOe7biMQRAdroV9DMhkA@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 05:50:55AM -0700, Maciej Żenczykowski wrote:
>Please pull into 4.9 LTS:
>
>https://gitlab.arm.com/linux-arm/linux-power/-/commit/2c16db6c92b0ee4aa61e88366df82169e83c3f7e
>"net: fix nla_strcmp to handle more then one trailing null character"
>
>+++ lib/nlattr.c
>@@ -379,7 +379,7 @@ int nla_strcmp(const struct nlattr *nla, const char *str)
>-       if (attrlen > 0 && buf[attrlen - 1] == '\0')
>+       while (attrlen > 0 && buf[attrlen - 1] == '\0')
>
>which appears to be present in 4.14.233 (and presumably newer LTS),
>but not in 4.9:
>
>$ git log --oneline -n1
>remotes/linux-stable/v4.14.233..143722a05028ebb8691d349007f85656a4e90a8e
>
>We've got some code that is confirmed failing due to the lack of this one-liner,
>and the fix is obvious enough...

Queued up, thanks!

>(assuming it applies it presumably wouldn't hurt in 4.4 LTS either,
>but I think that tree isn't even maintained, and I don't care about it
>there)

No, no one cares :)

-- 
Thanks,
Sasha
