Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254C2696D6B
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjBNSzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjBNSzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:55:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B623C2B;
        Tue, 14 Feb 2023 10:55:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EFA36177D;
        Tue, 14 Feb 2023 18:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A88C433EF;
        Tue, 14 Feb 2023 18:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676400942;
        bh=hsziXFWBEJIv+asnoJ5UADxji1cYX8chWCG9SQy3nKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aN7KO+J6HDjSG+1TiGld0IWqnTfF53nr/7YFPZP0JIl6xRxdb3WVo6/OvtGEg80+q
         6JgxsZHfd5d23by8g4Gts6przoa1EsCvyKutUw5uPWncnhXipwUsiO00c7rL96WivE
         m0uAiqKSmt3YTcSfUZZtyyUjDBQ20Bb3r2bUYBHr/9uJv79taE/puvcbIUh+M0oMTe
         3KPVK6ea/Q29xm0Yyjald62dFCOtWpgbARfYa1nPmfNjpxeSjxzy7kuTiZSi22R56G
         R7faRSq9REkRPThewPKfrESbfwdWiAg1WVmS0K/VvAdzPyo9V75yDkowDy4wBg4K9L
         5YG3g7vLzFQ+g==
Date:   Tue, 14 Feb 2023 18:55:41 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Munehisa Kamata <kamatam@amazon.com>
Cc:     surenb@google.com, hannes@cmpxchg.org, hdanton@sina.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mengcc@amazon.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] sched/psi: fix use-after-free in
 ep_remove_wait_queue()
Message-ID: <Y+vZLQXlkf/7XvVB@gmail.com>
References: <CAJuCfpGiktjjPZYPp8LNtbmvYhkxh_icEWXOVgsq9qeq+w6s+g@mail.gmail.com>
 <20230214181335.3946674-1-kamatam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214181335.3946674-1-kamatam@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 10:13:35AM -0800, Munehisa Kamata wrote:
> Using wake_up_pollfree() here might be less than ideal, but it also is not
> fully contradicting the comment at commit 42288cb44c4b ("wait: add
> wake_up_pollfree()") since the waitqueue's lifetime is not tied to file's
> one and can be considered as another special case.

If that comment is outdated now, then please update the comment too.  We can do
better than "not fully contradicting".

- Eric
