Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B62A541B6E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381369AbiFGVrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382039AbiFGVqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:46:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAFB23527D;
        Tue,  7 Jun 2022 12:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2AD9B82182;
        Tue,  7 Jun 2022 19:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF90C385A2;
        Tue,  7 Jun 2022 19:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628860;
        bh=QawVH5XJK4WTWh1gfW7u/zbDDesGoYCTL7NMv1kBu1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGSA83ur1RUaD47cykhYEYnNwuAGvz/dtqhgcutak0SYt9nuodoqemhRWRvn9q8Up
         CsTpt9fKZpqTmE9sqhQ4bazTQFY5C83PkXRXFEtgsLtJy47elPTKWcTg4dROeO/yC0
         +3uPxf1r37SJTTuiKTSuYwi6/cqYFzt5rFjb0aUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 482/879] ext4: reject the commit option on ext2 filesystems
Date:   Tue,  7 Jun 2022 19:00:00 +0200
Message-Id: <20220607165016.865680072@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit cb8435dc8ba33bcafa41cf2aa253794320a3b8df ]

The 'commit' option is only applicable for ext3 and ext4 filesystems,
and has never been accepted by the ext2 filesystem driver, so the ext4
driver shouldn't allow it on ext2 filesystems.

This fixes a failure in xfstest ext4/053.

Fixes: 8dc0aa8cf0f7 ("ext4: check incompatible mount options while mounting ext2/3")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Link: https://lore.kernel.org/r/20220510183232.172615-1-ebiggers@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1466fbdbc8e3..f1987c0690a4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1913,6 +1913,7 @@ static const struct mount_opts {
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_warn_on_error, EXT4_MOUNT_WARN_ON_ERROR, MOPT_SET},
 	{Opt_nowarn_on_error, EXT4_MOUNT_WARN_ON_ERROR, MOPT_CLEAR},
+	{Opt_commit, 0, MOPT_NO_EXT2},
 	{Opt_nojournal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
-- 
2.35.1



