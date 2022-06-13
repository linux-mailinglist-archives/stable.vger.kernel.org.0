Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6105497B8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352501AbiFMLRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353599AbiFMLQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313F0387A9;
        Mon, 13 Jun 2022 03:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3BE560EF5;
        Mon, 13 Jun 2022 10:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC052C34114;
        Mon, 13 Jun 2022 10:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116708;
        bh=3Bc0OlBA8b6xAmGr56Nb3OPEg8WWchx+CJz90cFBMV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VW46tyj4qZd7jzW6v6uxhQKHooTzE9pAjMUKMhBbuFwBczy5C2E6GuP1MtqoH5k9S
         mGSNfndwV9n36Q2dy3SGfEA8GY7V/LrXhjDQEQsnpdjCUiSzQlo3vWhggAoG85DZna
         GdLuTJSGFtv3UUloiLHcCndkJREwuRILcxsBgLYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/411] ext4: reject the commit option on ext2 filesystems
Date:   Mon, 13 Jun 2022 12:06:57 +0200
Message-Id: <20220613094932.988304493@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index c13879bd2168..eba2506f4399 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1703,6 +1703,7 @@ static const struct mount_opts {
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_warn_on_error, EXT4_MOUNT_WARN_ON_ERROR, MOPT_SET},
 	{Opt_nowarn_on_error, EXT4_MOUNT_WARN_ON_ERROR, MOPT_CLEAR},
+	{Opt_commit, 0, MOPT_NO_EXT2},
 	{Opt_nojournal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
-- 
2.35.1



