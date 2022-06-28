Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D18F55ECBF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiF1Sk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiF1SkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:40:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4332722B10;
        Tue, 28 Jun 2022 11:40:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so16881134pjr.0;
        Tue, 28 Jun 2022 11:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l+B7nHgbPu3e9hJDPsfW++qLQdgg6JWuPaSO/GjEMM0=;
        b=Um5nuUQLnqkabbapxKi4iPblsANUbV0CnOO5dV7Bzil2KhON9mP+BYqXHgXotj7NUz
         /yYFQKu7wb5rH1B5BvEhofo7rIOoLKlfFeBHuy9xEey8hePSwRJi8cMIvMjpatZaTiPu
         EDu5jwfnwBCvh+YqIlzmjaCcu0s3m+jdI7s5ozKGhqMCY5vfuZSFzbuqvEmhy+Sq2ujA
         OFmhAclTr/KaNl360FBvMI1Iff3ApDLIALbEAQKj48OGVLSwXhl6ndUPqUMGc62HVMOn
         QY4HBO+Juh7apPqeifaseQavEw2iXo1MZP/rogpw1jlN5JoIDbRxRwdEgzyyMEDYEp6M
         /hTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l+B7nHgbPu3e9hJDPsfW++qLQdgg6JWuPaSO/GjEMM0=;
        b=tFxk/J9DTN7BbToNNUbQnw19ZPbhicuib++JdhKIAxxZb2mU6fPTKurhY50CSLMiWl
         U04FEdlQR27smse4KYAzQQsxpGO/LsgCj3D6XuolwLJVJ8GsezkEXzO/k+jOjw4ksL2T
         GMMhrwyUn1wviAI722T5aqLZYXcS6ruU3WQy10Zt5cgld34TrH49zthzDFdZ1/8kJ/SZ
         xGnkcTIwzGDAlheYOJSERB0prktc7IzJJit4Slm8qZGS2TyzgxF3LGY8U+3rENZhmOU8
         VGuTUQ/RVmmqbDDHb1lIBPKMxmnGatgL5WROLsQJUPL/7ByDbm5fiLyUfe6kF8AjWO7W
         HfqA==
X-Gm-Message-State: AJIora+mq1E/PjdFutveKN0LM0cI5AQBZpFaQ0awxUZbsMpK1XbGzGsK
        hQyBsQk8GcWlUXWse/Ih1ZUYYA/6MFpfHQ==
X-Google-Smtp-Source: AGRyM1tGW5jAyV2E+PJHjb4Ks8esfAVKXfCvibZZVj3GSc41c+K7ReF6QxN70B6YSb137mrhdzer2Q==
X-Received: by 2002:a17:902:ea95:b0:16a:3084:2925 with SMTP id x21-20020a170902ea9500b0016a30842925mr5153978plb.166.1656441623518;
        Tue, 28 Jun 2022 11:40:23 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:1d5d:7791:41a3:902a])
        by smtp.gmail.com with ESMTPSA id a20-20020a621a14000000b005251bea0d53sm9743498pfa.83.2022.06.28.11.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:40:23 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v4 3/7] xfs: Fix the free logic of state in xfs_attr_node_hasname
Date:   Tue, 28 Jun 2022 11:39:47 -0700
Message-Id: <20220628183951.3425528-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220628183951.3425528-1-leah.rumancik@gmail.com>
References: <20220628183951.3425528-1-leah.rumancik@gmail.com>
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

[ Upstream commit a1de97fe296c52eafc6590a3506f4bbd44ecb19a ]

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

Also, use "goto error/out" instead of returning error directly in xfs_attr_node_addname_find_attr and
xfs_attr_node_removename_setup function because we should free state ourselves.

Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fbc9d816882c..23523b802539 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1077,21 +1077,18 @@ xfs_attr_node_hasname(
 
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
 
@@ -1112,7 +1109,7 @@ xfs_attr_node_addname_find_attr(
 	 */
 	retval = xfs_attr_node_hasname(args, &dac->da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		return retval;
+		goto error;
 
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto error;
@@ -1337,7 +1334,7 @@ int xfs_attr_node_removename_setup(
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
-		return error;
+		goto out;
 	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
-- 
2.37.0.rc0.161.g10f37bed90-goog

