Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33595498A1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356989AbiFMLzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357158AbiFMLxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:53:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2A72EA37;
        Mon, 13 Jun 2022 03:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E945560EFE;
        Mon, 13 Jun 2022 10:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06706C34114;
        Mon, 13 Jun 2022 10:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117741;
        bh=7B6Q9xxBeao43cVsBV0jSdgwxpsYwSK1CIoCX6P4GGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5hQwDJK+lk4ldJepnP5AqFc/ZlcAaOz3i8JT2Eow0r0HCUIra/h5vRWilXMmAZbn
         cP7kQVvHuun42KHG5q+jsrLQwqC9D44XUWXWeHCCFgWeFp7NQc9X2JVkmkuzsj3QHt
         FP70AEHNRnBU+7KTWO3TooOaIL+Auju4bNgsgQHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/287] ext4: reject the commit option on ext2 filesystems
Date:   Mon, 13 Jun 2022 12:08:47 +0200
Message-Id: <20220613094927.002780450@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index 6893b87c7354..bf120842a307 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1688,6 +1688,7 @@ static const struct mount_opts {
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_warn_on_error, EXT4_MOUNT_WARN_ON_ERROR, MOPT_SET},
 	{Opt_nowarn_on_error, EXT4_MOUNT_WARN_ON_ERROR, MOPT_CLEAR},
+	{Opt_commit, 0, MOPT_NO_EXT2},
 	{Opt_nojournal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
-- 
2.35.1



