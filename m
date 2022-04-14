Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD340501CAA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 22:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346299AbiDNUcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 16:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiDNUcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 16:32:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1C799EE5;
        Thu, 14 Apr 2022 13:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 276ECB82B9B;
        Thu, 14 Apr 2022 20:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5B0C385A1;
        Thu, 14 Apr 2022 20:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649968187;
        bh=UK4HRG23mKXLkm6rpA/BwBKA58oQpPcAKodZxTGowVc=;
        h=Date:From:To:Cc:Subject:From;
        b=SLWFsfBhjUDrZOeseBKhf86OMoxqGwYiiHp9g46ZfdfQi294OzElbzNP00dxuxja7
         3SybmIJhXwaR9bHKdI75mKsHYIOT2Sy4Ls3E8SJ1AorOo5goOnpU88HDwgQM0ya4cE
         /q6eDpNc8nFgn3bm+xQNnVASm3nhuFznag0ndeaWZ+8el+ptENcLyRiAoz8X8pLUHx
         pUsgCpQD/wYbp+K1qz4LNcy2xnnqO/dy8AsIiRmXOXricEiyC65NuV2r3Cby8WbVxa
         BkVjFzO1DY+o3qwKN7DgegWHbxkOBUdrtRwxDiDXwdqKAHSrCCjPVTkCYugawbts++
         U+JkRVQaMNYkQ==
Date:   Thu, 14 Apr 2022 13:29:45 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-btrfs@vger.kernel.org
Subject: btrfs warning fixes for 5.15 and 5.17
Message-ID: <YliEOSL8z3/s7DGG@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

Please apply

ad3fc7946b18 ("btrfs: remove no longer used counter when reading data page")
6d4a6b515c39 ("btrfs: remove unused variable in btrfs_{start,write}_dirty_block_groups()")

to 5.15 and 5.17 and

cd9255be6980 ("btrfs: remove unused parameter nr_pages in add_ra_bio_pages()")

to 5.15 (it landed in 5.16), as they all resolve build errors with
CONFIG_WERROR=y and tip of tree clang, which recently added support for
unary operations in -Wunused-but-set-variable. They all apply cleanly
and I do not see any additional build warnings and errors.

Commit 6d4a6b515c39 was specifically tagged for stable back to 5.4,
which should be fine, but it really only needs to go back to 5.12+, as
btrfs turned on W=1 (which includes this warning) for itself in commit
e9aa7c285d20 ("btrfs: enable W=1 checks for btrfs"), which landed in
5.12-rc1. Prior that that change, none of these warnings will be
visible under a normal build.

Cheers,
Nathan
