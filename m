Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379EE526D7F
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 01:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiEMXXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 19:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiEMXX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 19:23:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C63C2FDA18;
        Fri, 13 May 2022 16:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FB80B83220;
        Fri, 13 May 2022 23:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102ABC34113;
        Fri, 13 May 2022 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652484055;
        bh=b92LkAqhO5PUVsDiRTBhHHeNaJDTEdm3bJ8lN4kNIfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXmYdsz0VOS5bnNgZiePUFvY4PBeM7didV6ZMHJAFIjZZs4OxD+YKw2GWUImfihKT
         I8p8PLNSwblLJPzYS1xBLQqBf3UyVdPRXQs5c6Q3ZcvtDXZ1T0ZYBdfkaCNlPlX/nx
         huOW+ydQXjo9tTd/MnOeIjMJeZqu+6rIbUWJyArYj9QWq/CTnSgQYXYC6w45Y6WtpG
         XzXGz36/vK8xYXOKx28jqW5Oy/gvZW1zVTH9FOXNZuyC3HmOK640v0tJapmDRcKgdU
         p6ktSn+1jBvoJ4nOagefuu1EsctNc3giLo6APE847uxu1aYEDfdlJljZI3kyaHHC5i
         +E/A/Nb3JLh7w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 1/5] ext4: fix memory leak in parse_apply_sb_mount_options()
Date:   Fri, 13 May 2022 16:16:01 -0700
Message-Id: <20220513231605.175121-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513231605.175121-1-ebiggers@kernel.org>
References: <20220513231605.175121-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If processing the on-disk mount options fails after any memory was
allocated in the ext4_fs_context, e.g. s_qf_names, then this memory is
leaked.  Fix this by calling ext4_fc_free() instead of kfree() directly.

Reproducer:

    mkfs.ext4 -F /dev/vdc
    tune2fs /dev/vdc -E mount_opts=usrjquota=file
    echo clear > /sys/kernel/debug/kmemleak
    mount /dev/vdc /vdc
    echo scan > /sys/kernel/debug/kmemleak
    sleep 5
    echo scan > /sys/kernel/debug/kmemleak
    cat /sys/kernel/debug/kmemleak

Fixes: 7edfd85b1ffd ("ext4: Completely separate options parsing and sb setup")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1466fbdbc8e34..60fa2f2623e07 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2625,8 +2625,10 @@ static int parse_apply_sb_mount_options(struct super_block *sb,
 	ret = ext4_apply_options(fc, sb);
 
 out_free:
-	kfree(s_ctx);
-	kfree(fc);
+	if (fc) {
+		ext4_fc_free(fc);
+		kfree(fc);
+	}
 	kfree(s_mount_opts);
 	return ret;
 }
-- 
2.36.1

