Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D08593F71
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiHOVED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242801AbiHOVDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:03:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12A9D2EA4;
        Mon, 15 Aug 2022 12:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E81A1B81109;
        Mon, 15 Aug 2022 19:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B33DC433C1;
        Mon, 15 Aug 2022 19:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590867;
        bh=Axapi9ZUMEYfwtt328vt8/8TF7uU1uOdwcal1zqH1e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnJY/e4inu3ooTbQPwuyLgZtqYEAOqNiyVxej2bEVY9pB/DGwNkCbojy3qSirpECg
         8uMG33YhIP3dSnsmvqVeJ/aDwzQxgrQvr7oEm17+QS+7CEjut1X1Tkehmie4NX+24x
         XESva6ZmxktbYsZAaaCO4taLEbDs2L++gfna9bLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0365/1095] rcutorture: Make kvm.sh allow more memory for --kasan runs
Date:   Mon, 15 Aug 2022 19:56:04 +0200
Message-Id: <20220815180444.817283309@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 31015625768e6d8bc808a892b221b69afaaa8d07 ]

KASAN allots significant memory to track allocation state, and the amount
of memory has increased recently, which results in frequent OOMs on a
few of the rcutorture scenarios.  This commit therefore provides 2G of
memory for --kasan runs, up from the 512M default.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 55b2c1533282..b9f4d41da30e 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -44,6 +44,7 @@ TORTURE_KCONFIG_KASAN_ARG=""
 TORTURE_KCONFIG_KCSAN_ARG=""
 TORTURE_KMAKE_ARG=""
 TORTURE_QEMU_MEM=512
+torture_qemu_mem_default=1
 TORTURE_REMOTE=
 TORTURE_SHUTDOWN_GRACE=180
 TORTURE_SUITE=rcu
@@ -180,6 +181,10 @@ do
 		;;
 	--kasan)
 		TORTURE_KCONFIG_KASAN_ARG="CONFIG_DEBUG_INFO=y CONFIG_KASAN=y"; export TORTURE_KCONFIG_KASAN_ARG
+		if test -n "$torture_qemu_mem_default"
+		then
+			TORTURE_QEMU_MEM=2G
+		fi
 		;;
 	--kconfig|--kconfigs)
 		checkarg --kconfig "(Kconfig options)" $# "$2" '^CONFIG_[A-Z0-9_]\+=\([ynm]\|[0-9]\+\)\( CONFIG_[A-Z0-9_]\+=\([ynm]\|[0-9]\+\)\)*$' '^error$'
@@ -202,6 +207,7 @@ do
 	--memory)
 		checkarg --memory "(memory size)" $# "$2" '^[0-9]\+[MG]\?$' error
 		TORTURE_QEMU_MEM=$2
+		torture_qemu_mem_default=
 		shift
 		;;
 	--no-initrd)
-- 
2.35.1



