Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223FA4FD116
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiDLG5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351468AbiDLGxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDCC37A2C;
        Mon, 11 Apr 2022 23:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A5AF60A69;
        Tue, 12 Apr 2022 06:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51495C385A1;
        Tue, 12 Apr 2022 06:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745669;
        bh=kX4KcUYRaVhPsyVP5Sgr82WLRQrhbX5hiCyoRvaApR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=my8NlRYr74viNjJfrXBiAnKJu8wWTar0cRBxTggf+z8YyXWqMbqJIHGc50ksIszfI
         KW3DbTLaXiEjV17SWVRbaK6OoHQc8yzxoDD0a9Dm3NhOVYrNibUb7Qjv/ZJH8F7zL9
         MgqJk2gFXy4yWoehaYxL3DED2rpypYx6768cWkk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 164/171] selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
Date:   Tue, 12 Apr 2022 08:30:55 +0200
Message-Id: <20220412062932.644583284@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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
@@ -219,7 +219,7 @@ int cg_find_unified_root(char *root, siz
 
 int cg_create(const char *cgroup)
 {
-	return mkdir(cgroup, 0644);
+	return mkdir(cgroup, 0755);
 }
 
 int cg_wait_for_proc_count(const char *cgroup, int count)


