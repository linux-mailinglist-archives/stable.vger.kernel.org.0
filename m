Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6A35408C3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349436AbiFGSDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350297AbiFGSAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:00:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8414F737A3;
        Tue,  7 Jun 2022 10:42:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C851E6146F;
        Tue,  7 Jun 2022 17:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B1EC385A5;
        Tue,  7 Jun 2022 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623775;
        bh=EI6kyMEv2r+oMfMB12oZQKomnwfH3xTNuKb7+f/Swr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQXNwjPthVDHfBFXqV3LdC69c9N+lhk+7W3vJAE/JV/hrSm38+ca/zeaXQoDD3huK
         zGOf1vuVUAGgwrkintcFq1v+RrisuUwIu3AC8usk5BWGl73O1xPHZckjWHOJmtyRQ8
         QjPNbeOy2+h8kt0OOL0v+4n0JGlCZPpP3NVQT6ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/667] selftests/bpf: Fix vfs_link kprobe definition
Date:   Tue,  7 Jun 2022 18:55:11 +0200
Message-Id: <20220607164936.184442617@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit e299bcd4d16ff86f46c48df1062c8aae0eca1ed8 ]

Since commit 6521f8917082 ("namei: prepare for idmapped mounts")
vfs_link's prototype was changed, the kprobe definition in
profiler selftest in turn wasn't updated. The result is that all
argument after the first are now stored in different registers. This
means that self-test has been broken ever since. Fix it by updating the
kprobe definition accordingly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220331140949.1410056-1-nborisov@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/profiler.inc.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
index 4896fdf816f7..92331053dba3 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -826,8 +826,9 @@ int kprobe_ret__do_filp_open(struct pt_regs* ctx)
 
 SEC("kprobe/vfs_link")
 int BPF_KPROBE(kprobe__vfs_link,
-	       struct dentry* old_dentry, struct inode* dir,
-	       struct dentry* new_dentry, struct inode** delegated_inode)
+	       struct dentry* old_dentry, struct user_namespace *mnt_userns,
+	       struct inode* dir, struct dentry* new_dentry,
+	       struct inode** delegated_inode)
 {
 	struct bpf_func_stats_ctx stats_ctx;
 	bpf_stats_enter(&stats_ctx, profiler_bpf_vfs_link);
-- 
2.35.1



