Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA19765E5DA
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjAEHRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjAEHRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:17:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19842003;
        Wed,  4 Jan 2023 23:17:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 211D86187F;
        Thu,  5 Jan 2023 07:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9FDC433EF;
        Thu,  5 Jan 2023 07:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672903027;
        bh=uqC5T7gHkPgSmHQyWRnqVzA6IK7878G62q9D9DJhf3w=;
        h=From:To:Cc:Subject:Date:From;
        b=ssUm73cgM5aNNNtvl8PRoWpnw0yHHMTSNNNES+iSR9MwWXCwfaVL/GywPtvPV51Fh
         F7gCjBSV7Q3qCDXJu9wFSZdKdecGTf4iJHRfd/13RcIsIg40h+PiVsWA/EuxUdMtZW
         7/wwQR4CwFOg1k9AeFeGo29MwOuVq+RBsUawIDNEnuRQkK8OfUDznbuR51Kf7xfliq
         DNE3/c019FOGC85HSFUEAdnWOCiMRUMvbDtTpWBhdlVEuwMXL1GY/85rj12fh5Ojrz
         W4+Nrsx/aEqM0CvAE8KfGnR9iT8BOTh1/S0rNf6yF91fimCeMXHn9Pa82//RBfWbb9
         Q2bdqDfVYq7Rw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH 5.15 00/10] ext4 fast-commit fixes for 5.15-stable
Date:   Wed,  4 Jan 2023 23:13:49 -0800
Message-Id: <20230105071359.257952-1-ebiggers@kernel.org>
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

This series backports 6 commits with 'Cc stable' that had failed to be
applied, and 4 related commits that made the backports much easier.
Please apply this series to 5.15-stable.

I verified that this series does not cause any regressions with
'gce-xfstests -c ext4/fast_commit -g auto'.  There is one test failure
both before and after (ext4/050).

Eric Biggers (5):
  ext4: disable fast-commit of encrypted dir operations
  ext4: don't set up encryption key during jbd2 transaction
  ext4: add missing validation of fast-commit record lengths
  ext4: fix unaligned memory access in ext4_fc_reserve_space()
  ext4: fix off-by-one errors in fast-commit block filling

Jan Kara (1):
  ext4: use ext4_debug() instead of jbd_debug()

Ritesh Harjani (1):
  ext4: remove unused enum EXT4_FC_COMMIT_FAILED

Ye Bin (3):
  ext4: introduce EXT4_FC_TAG_BASE_LEN helper
  ext4: factor out ext4_fc_get_tl()
  ext4: fix potential out of bound read in ext4_fc_replay_scan()

 fs/ext4/balloc.c            |   2 +-
 fs/ext4/ext4.h              |   4 +-
 fs/ext4/ext4_jbd2.c         |   3 +-
 fs/ext4/fast_commit.c       | 284 +++++++++++++++++++++---------------
 fs/ext4/fast_commit.h       |   7 +-
 fs/ext4/indirect.c          |   4 +-
 fs/ext4/inode.c             |   2 +-
 fs/ext4/namei.c             |  44 +++---
 fs/ext4/orphan.c            |  24 +--
 fs/ext4/super.c             |   2 +-
 include/trace/events/ext4.h |   7 +-
 11 files changed, 222 insertions(+), 161 deletions(-)

-- 
2.39.0

