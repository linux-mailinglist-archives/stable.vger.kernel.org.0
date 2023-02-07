Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4935A68E0B1
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjBGTAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjBGTAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2AA30EAB;
        Tue,  7 Feb 2023 11:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87F3C6113A;
        Tue,  7 Feb 2023 19:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8337C4339B;
        Tue,  7 Feb 2023 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675796417;
        bh=r6UlP/dJGLR+YQx8+K0+rvbOWs3Gze3w+cUIcIpyEcQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XBM05Z/dQUrHSGNNknUCuLAZG9cWOZ9cWABPZbwUMpodUiLcdKum9BtT12O8a0yia
         1HWxcxHFD2FVBF/KXz5LYM69l73EIKEBsLeMCrdP26fc7sMqglH2Wwd1GIvqVkFwq5
         C8V7pvQZaMSI/gsPO+C+ueqtxxFURWC4fjeZNGYFIoZhbLKObugpMCCq9ebyMAJrjw
         ZCDFkYTSntfj7St3RvGr85fOR7/kCkglkxDjxsskun3KXI6ODRBokquJyr2uGKe+cP
         qqA3jRzqJvOfSHyKETFgJbrv7w2vcDRW5xpktcd3ULzTAHGFGrxu4pNeaROxXI/sb8
         qLA9hpdpRutLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2E39E55EFD;
        Tue,  7 Feb 2023 19:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix kernel crash due to null io->bio
From:   patchwork-bot+f2fs@kernel.org
Message-Id: <167579641779.24576.11865638891088345725.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 19:00:17 +0000
References: <20230206034344.724593-1-jaegeuk@kernel.org>
In-Reply-To: <20230206034344.724593-1-jaegeuk@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Sun,  5 Feb 2023 19:43:44 -0800 you wrote:
> We should return when io->bio is null before doing anything. Otherwise, panic.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000010
> RIP: 0010:__submit_merged_write_cond+0x164/0x240 [f2fs]
> Call Trace:
>  <TASK>
>  f2fs_submit_merged_write+0x1d/0x30 [f2fs]
>  commit_checkpoint+0x110/0x1e0 [f2fs]
>  f2fs_write_checkpoint+0x9f7/0xf00 [f2fs]
>  ? __pfx_issue_checkpoint_thread+0x10/0x10 [f2fs]
>  __checkpoint_and_complete_reqs+0x84/0x190 [f2fs]
>  ? preempt_count_add+0x82/0xc0
>  ? __pfx_issue_checkpoint_thread+0x10/0x10 [f2fs]
>  issue_checkpoint_thread+0x4c/0xf0 [f2fs]
>  ? __pfx_autoremove_wake_function+0x10/0x10
>  kthread+0xff/0x130
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x2c/0x50
>  </TASK>
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] f2fs: fix kernel crash due to null io->bio
    https://git.kernel.org/jaegeuk/f2fs/c/267c159f9c7b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


