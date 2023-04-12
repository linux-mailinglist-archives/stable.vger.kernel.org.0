Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C396DEA0B
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 05:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDLDue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 23:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDLDue (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 23:50:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A10E10C0;
        Tue, 11 Apr 2023 20:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9801E62CAC;
        Wed, 12 Apr 2023 03:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01009C433D2;
        Wed, 12 Apr 2023 03:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271432;
        bh=fu1hYI5jT4tiB4AU2l5sPWhTCilqWNeftIP5svSQfSk=;
        h=Date:Subject:From:To:Cc:From;
        b=hc1dgI+vbzzROsUuwgbg8MqTqNW8K295MIAVp+fbpU/MvsAMppUmSYc015F4/MKs/
         7LZ0GB+JJsXF0mKyvHL1xk0botyjzTsvGgKFH0t39VGmYwVoehas/ZPDFv6ISbn4xx
         shxpSIrven8ASVAjOuMDXlO8IsJU3HnCn2HxqAUZvjKbOuRjuIPolKeS48R+rvpd7M
         3Jgf6FfA/LtTBD8EkXxF5XRYUPoEx8hDQKigIilM3ZlQn0Kw+WdEo8jFPC47MZw5F7
         44lKA5QETDNwB+kNxsJJSHSig8yNH/isnfuCs8Xf30Jp04W1GBwi3jUA1p2Ogjh8DB
         zZ/arnY9ewBlw==
Date:   Tue, 11 Apr 2023 20:50:31 -0700
Subject: [GIT PULL 22/22] xfs: rollup of various bug fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com,
        yebin10@huawei.com
Message-ID: <168127095854.417736.18149025693130053322.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 7ba83850ca2691865713b307ed001bde5fddb084:

xfs: deprecate the ascii-ci feature (2023-04-11 19:05:19 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-bugs-6.4_2023-04-11

for you to fetch changes up to 4fe9cd8a34a1f934e5f936d4245e19300b52d440:

xfs: fix BUG_ON in xfs_getbmap() (2023-04-11 19:48:08 -0700)

----------------------------------------------------------------
xfs: rollup of various bug fixes

This is a rollup of miscellaneous bug fixes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: _{attr,data}_map_shared should take ILOCK_EXCL until iread_extents is completely done
xfs: verify buffer contents when we skip log replay

Dave Chinner (2):
xfs: remove WARN when dquot cache insertion fails
xfs: don't consider future format versions valid

Ye Bin (1):
xfs: fix BUG_ON in xfs_getbmap()

fs/xfs/libxfs/xfs_bmap.c       |  6 ++++++
fs/xfs/libxfs/xfs_inode_fork.c | 16 +++++++++++++++-
fs/xfs/libxfs/xfs_inode_fork.h |  6 ++++--
fs/xfs/libxfs/xfs_sb.c         | 11 ++++++-----
fs/xfs/xfs_bmap_util.c         | 14 ++++++--------
fs/xfs/xfs_buf_item_recover.c  | 10 ++++++++++
fs/xfs/xfs_dquot.c             |  1 -
7 files changed, 47 insertions(+), 17 deletions(-)

