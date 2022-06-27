Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B187655C16B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiF0GrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiF0GrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:47:17 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEE255B6;
        Sun, 26 Jun 2022 23:47:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q9so11541403wrd.8;
        Sun, 26 Jun 2022 23:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cXA+/dAUwgRQc5EpwS/X0n2pUieK6tax4HxbsNJh6Rw=;
        b=AglMghDCcYelUNa+FlJ4cqnR5TZFdH4ZpMUoOiGgqxuPR4aYFDXoxdhmrb4NbNibPt
         8KwUIJwYWkM5Av0cE0Mj9Xf8IJ+ahNPV/344xxIQm+or0fcXIB8w2cgwmNU2pYZlSAr7
         ExC7OejjoFnxTWk0OW3udQMCc4Adyh54ctJn8xVDNpZkNZghlqJMiZwIjhG8NvOFTY1z
         /u/v9mX2dJxitaos5TueTi/3zjfKe6zaLRo8MlJTwkouIlJUZwip66AA7URUFlB0J0Ef
         mmD+mrFPLZE/nQ0wer/HZqfEcPk8/hRLmuYCTtPMfZzUGi6A5MZS2ybLJvAf7GaoIRxO
         gUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cXA+/dAUwgRQc5EpwS/X0n2pUieK6tax4HxbsNJh6Rw=;
        b=c247SQ1jlLQWCWETbANNSmy6QI6isV5LDqEmjfQCHxFUgw9I1DZfm3mh9uG1mkIB5+
         2OitFccxkCI62Qqk5p3MjaSH2fPo1Cb6D2w3dsxRuqrtu349wW2rJh9dXbKfYu3ZywQy
         QfD6+km6D9hZgZ8Ju/8R2W+hlne6E3aoH4Kjx2XZVUstjJ82BJksTGfgRpETFPpkT3H/
         OgXnSFvyGfqEXjAlg9r8v+NGinEZMv6Aph1ipWqoWvX5U+cM2BXmt13XCAf6IG+GA6IA
         NDr/MNGPP/HFDU3oX8v8z7NYxAe+CCKYnM5kYorgt5bkrVemCGf6j86ERJh9KVUXU0LV
         YScA==
X-Gm-Message-State: AJIora/1pGufYRWQoNeRpJfDMfs6Qj51wsuH+JqccviH/rujUswTLDgn
        J3fK4LRK9ioOz4jqeq+GQZE=
X-Google-Smtp-Source: AGRyM1s2p12oTWEW/4GvSYxLlL25AAMDH1X/oykz5dgBbCdM4JBdKiCCA3ak7bKLHONdAtVq+V9kAw==
X-Received: by 2002:a5d:5941:0:b0:21a:342d:510f with SMTP id e1-20020a5d5941000000b0021a342d510fmr10795345wri.700.1656312433375;
        Sun, 26 Jun 2022 23:47:13 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm16460839wmq.26.2022.06.26.23.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:47:12 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [PATCH v3 3/5] xfs: Fix the free logic of state in xfs_attr_node_hasname
Date:   Mon, 27 Jun 2022 09:47:01 +0300
Message-Id: <20220627064703.2798133-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627064703.2798133-1-amir73il@gmail.com>
References: <20220627064703.2798133-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit a1de97fe296c52eafc6590a3506f4bbd44ecb19a upstream.

When testing xfstests xfs/126 on lastest upstream kernel, it will hang on some machine.
Adding a getxattr operation after xattr corrupted, I can reproduce it 100%.

The deadlock as below:
[983.923403] task:setfattr        state:D stack:    0 pid:17639 ppid: 14687 flags:0x00000080
[  983.923405] Call Trace:
[  983.923410]  __schedule+0x2c4/0x700
[  983.923412]  schedule+0x37/0xa0
[  983.923414]  schedule_timeout+0x274/0x300
[  983.923416]  __down+0x9b/0xf0
[  983.923451]  ? xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
[  983.923453]  down+0x3b/0x50
[  983.923471]  xfs_buf_lock+0x33/0xf0 [xfs]
[  983.923490]  xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
[  983.923508]  xfs_buf_get_map+0x4c/0x320 [xfs]
[  983.923525]  xfs_buf_read_map+0x53/0x310 [xfs]
[  983.923541]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923560]  xfs_trans_read_buf_map+0x1cf/0x360 [xfs]
[  983.923575]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923590]  xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923606]  xfs_da3_node_read+0x1f/0x40 [xfs]
[  983.923621]  xfs_da3_node_lookup_int+0x69/0x4a0 [xfs]
[  983.923624]  ? kmem_cache_alloc+0x12e/0x270
[  983.923637]  xfs_attr_node_hasname+0x6e/0xa0 [xfs]
[  983.923651]  xfs_has_attr+0x6e/0xd0 [xfs]
[  983.923664]  xfs_attr_set+0x273/0x320 [xfs]
[  983.923683]  xfs_xattr_set+0x87/0xd0 [xfs]
[  983.923686]  __vfs_removexattr+0x4d/0x60
[  983.923688]  __vfs_removexattr_locked+0xac/0x130
[  983.923689]  vfs_removexattr+0x4e/0xf0
[  983.923690]  removexattr+0x4d/0x80
[  983.923693]  ? __check_object_size+0xa8/0x16b
[  983.923695]  ? strncpy_from_user+0x47/0x1a0
[  983.923696]  ? getname_flags+0x6a/0x1e0
[  983.923697]  ? _cond_resched+0x15/0x30
[  983.923699]  ? __sb_start_write+0x1e/0x70
[  983.923700]  ? mnt_want_write+0x28/0x50
[  983.923701]  path_removexattr+0x9b/0xb0
[  983.923702]  __x64_sys_removexattr+0x17/0x20
[  983.923704]  do_syscall_64+0x5b/0x1a0
[  983.923705]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[  983.923707] RIP: 0033:0x7f080f10ee1b

When getxattr calls xfs_attr_node_get function, xfs_da3_node_lookup_int fails with EFSCORRUPTED in
xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
free state in internal and xfs_attr_node_get doesn't do xfs_buf_trans release job.

Then subsequent removexattr will hang because of it.

This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
in this case. But xfs_attr_node_hasname will free state itself instead of caller if
xfs_da3_node_lookup_int fails.

Fix this bug by moving the step of free state into caller.

[amir: this text from original commit is not relevant for 5.10 backport:
Also, use "goto error/out" instead of returning error directly in xfs_attr_node_addname_find_attr and
xfs_attr_node_removename_setup function because we should free state ourselves.
]

Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 96ac7e562b87..fcca36bbd997 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -876,21 +876,18 @@ xfs_attr_node_hasname(
 
 	state = xfs_da_state_alloc(args);
 	if (statep != NULL)
-		*statep = NULL;
+		*statep = state;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error) {
-		xfs_da_state_free(state);
-		return error;
-	}
+	if (error)
+		retval = error;
 
-	if (statep != NULL)
-		*statep = state;
-	else
+	if (!statep)
 		xfs_da_state_free(state);
+
 	return retval;
 }
 
-- 
2.25.1

