Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED654FD10A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbiDLG5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351467AbiDLGxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C844737A2A;
        Mon, 11 Apr 2022 23:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 39630CE1C02;
        Tue, 12 Apr 2022 06:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B48C385A8;
        Tue, 12 Apr 2022 06:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745666;
        bh=QmWJ0ivznYz9uhX/TixXaHhncdD7ABFsjGGB3gSf3OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmEyN8PACrJrv+l86MK5Exbt54X2cP9sbzIzDbN6Nt7S5fToJ42KWuz8NScHq2Qax
         oqUyWYAyIkJUnFs+vdQbKTUJwdmv/S0vw/8OQoP2KzVyayJ+8FdJRGmnypjpPoOj/e
         nVStAC14fS8ChiH1lv7gopE5bOT6+IZu+3irsu8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>,
        Sachin Sant <sachinp@linux.vnet.ibm.com>
Subject: [PATCH 5.10 163/171] selftests/cgroup: Fix build on older distros
Date:   Tue, 12 Apr 2022 08:30:54 +0200
Message-Id: <20220412062932.615033744@linuxfoundation.org>
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

From: Sachin Sant <sachinp@linux.vnet.ibm.com>

commit c2e46f6b3e3551558d44c4dc518b9667cb0d5f8b upstream.

On older distros struct clone_args does not have a cgroup member,
leading to build errors:

 cgroup_util.c: In function 'clone_into_cgroup':
 cgroup_util.c:343:4: error: 'struct clone_args' has no member named 'cgroup'
 cgroup_util.c:346:33: error: invalid application of 'sizeof' to incomplete
  type 'struct clone_args'

But the selftests already have a locally defined version of the
structure which is up to date, called __clone_args.

So use __clone_args which fixes the error.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sachin Sant <sachinp@linux.vnet.ibm.com>>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -337,13 +337,13 @@ pid_t clone_into_cgroup(int cgroup_fd)
 #ifdef CLONE_ARGS_SIZE_VER2
 	pid_t pid;
 
-	struct clone_args args = {
+	struct __clone_args args = {
 		.flags = CLONE_INTO_CGROUP,
 		.exit_signal = SIGCHLD,
 		.cgroup = cgroup_fd,
 	};
 
-	pid = sys_clone3(&args, sizeof(struct clone_args));
+	pid = sys_clone3(&args, sizeof(struct __clone_args));
 	/*
 	 * Verify that this is a genuine test failure:
 	 * ENOSYS -> clone3() not available


