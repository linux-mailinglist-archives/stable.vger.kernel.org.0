Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F429627EE8
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbiKNMxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbiKNMxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:53:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200AE252B5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD798B80EBC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16107C433C1;
        Mon, 14 Nov 2022 12:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430382;
        bh=s2Aja3Zlk1oYU412sCWCYubleI2enra5LK8grBc+kH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFK6EFTkx9Ch8KRoNY/ZMNoG4I10YSlXiREr9el4BoRfmYrDK88H9zxv0LnxYZb2X
         C4HjzDBVUoHPhfg7TwqyRQmy1J7RYIvL5yfA6kJbW6nt7QkWjeg4D+7pPxdQtI5CHs
         V1LBmBpncEo3ajuYY07EJL6rehwYvFU1Lf+0s8DM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Bill Wendling <morbo@google.com>, Lorenz Bauer <oss@lmb.io>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/131] bpf, verifier: Fix memory leak in array reallocation for stack state
Date:   Mon, 14 Nov 2022 13:44:42 +0100
Message-Id: <20221114124449.295365530@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 42378a9ca55347102bbf86708776061d8fe3ece2 ]

If an error (NULL) is returned by krealloc(), callers of realloc_array()
were setting their allocation pointers to NULL, but on error krealloc()
does not touch the original allocation. This would result in a memory
resource leak. Instead, free the old allocation on the error handling
path.

The memory leak information is as follows as also reported by Zhengchao:

  unreferenced object 0xffff888019801800 (size 256):
  comm "bpf_repo", pid 6490, jiffies 4294959200 (age 17.170s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000b211474b>] __kmalloc_node_track_caller+0x45/0xc0
    [<0000000086712a0b>] krealloc+0x83/0xd0
    [<00000000139aab02>] realloc_array+0x82/0xe2
    [<00000000b1ca41d1>] grow_stack_state+0xfb/0x186
    [<00000000cd6f36d2>] check_mem_access.cold+0x141/0x1341
    [<0000000081780455>] do_check_common+0x5358/0xb350
    [<0000000015f6b091>] bpf_check.cold+0xc3/0x29d
    [<000000002973c690>] bpf_prog_load+0x13db/0x2240
    [<00000000028d1644>] __sys_bpf+0x1605/0x4ce0
    [<00000000053f29bd>] __x64_sys_bpf+0x75/0xb0
    [<0000000056fedaf5>] do_syscall_64+0x35/0x80
    [<000000002bd58261>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: c69431aab67a ("bpf: verifier: Improve function state reallocation")
Reported-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Bill Wendling <morbo@google.com>
Cc: Lorenz Bauer <oss@lmb.io>
Link: https://lore.kernel.org/bpf/20221029025433.2533810-1-keescook@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c3a4158e838e..259248306056 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -770,12 +770,17 @@ static void *copy_array(void *dst, const void *src, size_t n, size_t size, gfp_t
  */
 static void *realloc_array(void *arr, size_t old_n, size_t new_n, size_t size)
 {
+	void *new_arr;
+
 	if (!new_n || old_n == new_n)
 		goto out;
 
-	arr = krealloc_array(arr, new_n, size, GFP_KERNEL);
-	if (!arr)
+	new_arr = krealloc_array(arr, new_n, size, GFP_KERNEL);
+	if (!new_arr) {
+		kfree(arr);
 		return NULL;
+	}
+	arr = new_arr;
 
 	if (new_n > old_n)
 		memset(arr + old_n * size, 0, (new_n - old_n) * size);
-- 
2.35.1



