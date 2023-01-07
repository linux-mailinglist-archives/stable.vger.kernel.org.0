Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0106611A1
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 21:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjAGUhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 15:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGUhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 15:37:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DE93AB3D;
        Sat,  7 Jan 2023 12:37:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 21BA1CE0A12;
        Sat,  7 Jan 2023 20:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162C9C433EF;
        Sat,  7 Jan 2023 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673123864;
        bh=j8csDSVPiYuai7u+E3eO0R50pKJ4QjoOPV8qZR6iJ34=;
        h=From:To:Cc:Subject:Date:From;
        b=XdI9SgD+CRRNU53ZpA6b1VijpSjGaKr2LqqJvxVnvpDFzVwzLhJePMI66GDt9as/6
         C3qCydfj6vYTJp3oJ3Raumwl/JV6bPecZ+BPb0pkBlOUMMpsRe4XU2uMvG8DU7Xxf4
         N1I4zeB/LPNuKMRP7FA6grC1EL4KHO38EZ/uDVDxpTRt6AtiOq1iD/ftFOumKa3CEd
         vdg2CB+571/cuP9zBV8YWoX+94SCz1DG6362fLuwyc/CBZ2KVsXP+3QKBQhhqsCrHV
         LkcPuPy9yszPatgHnsVj/R04w+gfjJfupYSGwzU/8iRGMh7872TPgo9n2w5VRwZskg
         gZIyImjFVVdZA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH 5.10 0/2] Selected ext4 fast-commit fixes for 5.10-stable
Date:   Sat,  7 Jan 2023 12:37:11 -0800
Message-Id: <20230107203713.158042-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The recent ext4 fast-commit fixes with 'Cc stable' didn't apply to 5.10
due to conflicts.  Since the fast-commit support in 5.10 is rudimentary
and hard to backport fixes too, this series backports the two most
important fixes only.  Please apply to 5.10-stable.

Eric Biggers (2):
  ext4: disable fast-commit of encrypted dir operations
  ext4: don't set up encryption key during jbd2 transaction

 fs/ext4/ext4.h              |  4 ++--
 fs/ext4/fast_commit.c       | 42 +++++++++++++++++++++--------------
 fs/ext4/fast_commit.h       |  1 +
 fs/ext4/namei.c             | 44 ++++++++++++++++++++-----------------
 include/trace/events/ext4.h |  7 ++++--
 5 files changed, 57 insertions(+), 41 deletions(-)

-- 
2.39.0

