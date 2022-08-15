Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98464593F53
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiHOVED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244579AbiHOVDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:03:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C656D3446;
        Mon, 15 Aug 2022 12:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BC59B8110A;
        Mon, 15 Aug 2022 19:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C99C433C1;
        Mon, 15 Aug 2022 19:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590870;
        bh=PbzDN8uCwewUCe9w4bc9uBAOhKpKwxgwoFCKQ9tbr1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uY1ON80ycvGBQAPOqR7Pf5qh/wE8KEklwr+hHvyKp7Kt/oqiZnI9eOROpdyjK+jWw
         Psi2Jg6kaG4unodD4H7iGablU6l/htBZRoD6uUKoW43s0lnRTcczRPtuU2lX6Wmymt
         IRWkJlKl1kV8yxoSNZ7tje/AWST+px0KJQahDgAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0366/1095] torture: Adjust to again produce debugging information
Date:   Mon, 15 Aug 2022 19:56:05 +0200
Message-Id: <20220815180444.866585300@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 5c92d7501699a5deb72a579f808500db5bb6f92a ]

A recent change to the DEBUG_INFO Kconfig option means that simply adding
CONFIG_DEBUG_INFO=y to the .config file and running "make oldconfig" no
longer works.  It is instead necessary to add CONFIG_DEBUG_INFO_NONE=n
and (for example) CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y.
This combination will then result in CONFIG_DEBUG_INFO being selected.

This commit therefore updates the Kconfig options produced in response
to the kvm.sh --gdb, --kasan, and --kcsan Kconfig options.

Fixes: f9b3cd245784 ("Kconfig.debug: make DEBUG_INFO selectable from a choice")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index b9f4d41da30e..f2768994d861 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -164,7 +164,7 @@ do
 		shift
 		;;
 	--gdb)
-		TORTURE_KCONFIG_GDB_ARG="CONFIG_DEBUG_INFO=y"; export TORTURE_KCONFIG_GDB_ARG
+		TORTURE_KCONFIG_GDB_ARG="CONFIG_DEBUG_INFO_NONE=n CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y"; export TORTURE_KCONFIG_GDB_ARG
 		TORTURE_BOOT_GDB_ARG="nokaslr"; export TORTURE_BOOT_GDB_ARG
 		TORTURE_QEMU_GDB_ARG="-s -S"; export TORTURE_QEMU_GDB_ARG
 		;;
@@ -180,7 +180,7 @@ do
 		shift
 		;;
 	--kasan)
-		TORTURE_KCONFIG_KASAN_ARG="CONFIG_DEBUG_INFO=y CONFIG_KASAN=y"; export TORTURE_KCONFIG_KASAN_ARG
+		TORTURE_KCONFIG_KASAN_ARG="CONFIG_DEBUG_INFO_NONE=n CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y CONFIG_KASAN=y"; export TORTURE_KCONFIG_KASAN_ARG
 		if test -n "$torture_qemu_mem_default"
 		then
 			TORTURE_QEMU_MEM=2G
@@ -192,7 +192,7 @@ do
 		shift
 		;;
 	--kcsan)
-		TORTURE_KCONFIG_KCSAN_ARG="CONFIG_DEBUG_INFO=y CONFIG_KCSAN=y CONFIG_KCSAN_STRICT=y CONFIG_KCSAN_REPORT_ONCE_IN_MS=100000 CONFIG_KCSAN_VERBOSE=y CONFIG_DEBUG_LOCK_ALLOC=y CONFIG_PROVE_LOCKING=y"; export TORTURE_KCONFIG_KCSAN_ARG
+		TORTURE_KCONFIG_KCSAN_ARG="CONFIG_DEBUG_INFO_NONE=n CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y CONFIG_KCSAN=y CONFIG_KCSAN_STRICT=y CONFIG_KCSAN_REPORT_ONCE_IN_MS=100000 CONFIG_KCSAN_VERBOSE=y CONFIG_DEBUG_LOCK_ALLOC=y CONFIG_PROVE_LOCKING=y"; export TORTURE_KCONFIG_KCSAN_ARG
 		;;
 	--kmake-arg|--kmake-args)
 		checkarg --kmake-arg "(kernel make arguments)" $# "$2" '.*' '^error$'
-- 
2.35.1



