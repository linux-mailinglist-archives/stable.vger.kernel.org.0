Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5D5952E2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 08:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiHPGqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 02:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiHPGps (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 02:45:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680BB11A2F
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 18:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 299E0B80EB2
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 01:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F1AC433D6;
        Tue, 16 Aug 2022 01:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660614313;
        bh=hMXcBSjYd0sKmBDs2vFeKVgBAxRiXE87s2bernVuAZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gi46uXBx7d9CN3Ny5dW0yWVPxKJXpy6kW+YB+G7Zx24bxlTNtyndsgmC2dnN+BKpQ
         nTL8WbESCAu7l44MmGgRF6hCo5WpPE8tfeSCNQajRXrYr2DIGnAJhli2TxWIT0KwMQ
         GhJWLe84faCcJqWiRh7x6+5BE+1kaCsVHWEDh/yivA29mfkX6rm+mgrp4+CjQoZG3p
         C6ZoKf01ptzOISP/27RiUsQWbMYp6y8p99Okoo/biWtjnzWKGzlnds8m0G9+P8CkPX
         DijrvNb2sZua0yxo4e08s4A/tLf7IBCjKnlFtW3T8jcTxRwxojFx3zDmoltkzvnZ+c
         9o+JQ4Jd+wlJw==
Date:   Mon, 15 Aug 2022 18:45:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     <stable@vger.kernel.org>, Wei Wang <weiwan@google.com>,
        LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Eric Dumazet" <edumazet@google.com>
Subject: Re: [PATCH stable 5.4] Revert "tcp: change pingpong threshold to 3"
Message-ID: <20220815184512.515a7fa6@kernel.org>
In-Reply-To: <20220815205129.6335-1-kuniyu@amazon.com>
References: <165919469116877@kroah.com>
        <20220815205129.6335-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Aug 2022 20:51:29 +0000 Kuniyuki Iwashima wrote:
> From: Wei Wang <weiwan@google.com>
> 
> commit 4d8f24eeedc58d5f87b650ddda73c16e8ba56559 upstream.
> 
> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> 
> This to-be-reverted commit was meant to apply a stricter rule for the
> stack to enter pingpong mode. However, the condition used to check for
> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> jiffy based and might be too coarse, which delays the stack entering
> pingpong mode.
> We revert this patch so that we no longer use the above condition to
> determine interactive session, and also reduce pingpong threshold to 1.
> 
> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> Reported-by: LemmyHuang <hlm3280@163.com>
> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Link: https://lore.kernel.org/r/20220721204404.388396-1-weiwan@google.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Should we wait for the resolution in the original thread first?

https://lore.kernel.org/all/ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org/
