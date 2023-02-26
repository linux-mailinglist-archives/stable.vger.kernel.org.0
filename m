Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CF56A2E0A
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 05:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBZEIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 23:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjBZEIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 23:08:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8387B6EAA;
        Sat, 25 Feb 2023 20:07:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EE5260BCA;
        Sun, 26 Feb 2023 04:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52003C433EF;
        Sun, 26 Feb 2023 04:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677384477;
        bh=43Ov0BMRH8YuoSnyQl5MauF5eVLVP/4BMSv5A8apjjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YqBUbWRrZKoij48z2Vy9Vf+lzywLzGks6i1UAfTQMIUfwUMX19bxCOzHKweLw6MTM
         QC22fxXMhsGqtmQ/nYRcGyLMR3QjxwrFSZFTiGK2w8KzJeTsLmkx6Dj2OItYxkt/QY
         2OEZW02FypCxjFbSPaom6Yt76mXcp72SL86FnrAEKbh2raV7wNprMflzxhJbCdJMlZ
         oOesKzqNklRu01STv0uwZW+2JrNUKxAgLjC1zxyfWYzW6qADywh+/yI5danPLESiL7
         Y+iQA0rpVWkV1AY/Xf9gzIGYAIG8j0M2a3OIooIjuySOZXwRVB0NI2KtFXEdQiO2t1
         xxrdoVrST9xpQ==
Date:   Sat, 25 Feb 2023 20:07:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 12/21] fs/super.c: stop calling
 fscrypt_destroy_keyring() from __put_super()
Message-ID: <Y/rbGxq8oAEsW28j@sol.localdomain>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230226034256.771769-12-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 25, 2023 at 10:42:47PM -0500, Sasha Levin wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> [ Upstream commit ec64036e68634231f5891faa2b7a81cdc5dcd001 ]
> 
> Now that the key associated with the "test_dummy_operation" mount option
> is added on-demand when it's needed, rather than immediately when the
> filesystem is mounted, fscrypt_destroy_keyring() no longer needs to be
> called from __put_super() to avoid a memory leak on mount failure.
> 
> Remove this call, which was causing confusion because it appeared to be
> a sleep-in-atomic bug (though it wasn't, for a somewhat-subtle reason).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Link: https://lore.kernel.org/r/20230208062107.199831-5-ebiggers@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Why is this being backported?

- Eric
