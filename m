Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9677A6B05A7
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 12:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCHLRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 06:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjCHLQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 06:16:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08995B5B7D;
        Wed,  8 Mar 2023 03:16:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 848DF61769;
        Wed,  8 Mar 2023 11:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B883DC433EF;
        Wed,  8 Mar 2023 11:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678274209;
        bh=QvBtY96SpBwzqiwlyNQBPDVTsFicwouO2HvLFCqvFNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TdZrSKV2pWKofYZlIV+1/BtRzOSJ3CPpBS/Rf/NMUbnnsFKgQwHN50DJi1/x7JIhC
         ShejteOgv62BL7DDHVB6wiFc4mMJVkVne4uV/U4c338Vfw6Ls0rUVsw4m2WALuzE+s
         M+YGmLvpDF6DkNX3YoNm6m8Hf0Ce3Q3kAq7a+isUKiXgclKBqErbVODe9P5otfpiSC
         ZRBrICYd24ICikqPAAzAXU/EEI2RBvkej+99XfTFQfjsSzdJ7qYDiXC07aTDLgDIu6
         znvvTBcyivrPU3lU4R/XfpYz3sFNQfw6+iX0buNj1Z6GQmJF7DBRwhbxntTiWVvSd9
         xO0yg7NLadjuA==
Date:   Wed, 8 Mar 2023 12:16:43 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] fork: allow CLONE_NEWTIME in clone3 flags
Message-ID: <20230308111643.dfa5zgiumdairdhn@wittgenstein>
References: <20230308105126.10107-1-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230308105126.10107-1-tklauser@distanz.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 11:51:26AM +0100, Tobias Klauser wrote:
> Currently, calling clone3() with CLONE_NEWTIME in clone_args->flags
> fails with -EINVAL. This is because CLONE_NEWTIME intersects with
> CSIGNAL. However, CSIGNAL was deprecated when clone3 was introduced in
> commit 7f192e3cd316 ("fork: add clone3"), allowing re-use of that part
> of clone flags.
> 
> Fix this by explicitly allowing CLONE_NEWTIME in clone3_args_valid. This
> is also in line with the respective check in check_unshare_flags which
> allow CLONE_NEWTIME for unshare().
> 
> Fixes: 769071ac9f20 ("ns: Introduce Time Namespace")
> Cc: Andrey Vagin <avagin@openvz.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---

Oh I either forgot or missed that we use a CSIGNAL bit for
CLONE_NEWTIME. Looks good,

Reviewed-by: Christian Brauner <brauner@kernel.org>
