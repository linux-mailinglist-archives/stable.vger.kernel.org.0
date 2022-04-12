Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD514FD6F8
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbiDLHVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351826AbiDLHM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36DF15707;
        Mon, 11 Apr 2022 23:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F1C261451;
        Tue, 12 Apr 2022 06:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8F2C385A8;
        Tue, 12 Apr 2022 06:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746391;
        bh=RwYvmjlQ4mLJb+hslJdiDFl+xySrHXVuE9bcHdhFzdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkT/7+WXkNcX6OCCjIs8fPUd0hHtP/xlMHBopTZJnwFfmukRQpoFda80CYAvIiDMw
         jUXk1ngLG8x51BFWQicouxLfC0CjpXm5cksepidsTv6nk+g/YZYiY+eL4JkTsvq+c0
         H0zDUmVCxmpDcCc6paE4hLvntjgOwnfxWVD5lT9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 264/277] selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
Date:   Tue, 12 Apr 2022 08:31:07 +0200
Message-Id: <20220412062949.684407031@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit b09c2baa56347ae65795350dfcc633dedb1c2970 upstream.

0644 is an odd perm to create a cgroup which is a directory. Use the regular
0755 instead. This is necessary for euid switching test case.

Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -221,7 +221,7 @@ int cg_find_unified_root(char *root, siz
 
 int cg_create(const char *cgroup)
 {
-	return mkdir(cgroup, 0644);
+	return mkdir(cgroup, 0755);
 }
 
 int cg_wait_for_proc_count(const char *cgroup, int count)


