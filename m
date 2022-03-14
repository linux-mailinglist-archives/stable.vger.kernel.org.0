Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A958D4D8434
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbiCNMXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242866AbiCNMTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEAA50B37;
        Mon, 14 Mar 2022 05:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A42608C4;
        Mon, 14 Mar 2022 12:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01E7C340EC;
        Mon, 14 Mar 2022 12:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260085;
        bh=YeTe//0SAgavio9Xw86XZZ+I6TczDnfWm8tRimdCf7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9aoYKLPn2xkkXddZ3CmF1F2TQEj+xao1TZrJEwJ69UWh9tIpH1K+MqYRjjEzffiO
         69+RlnODEaL1IZ7Piq2fyFp+3M/F2KTsUQO5tOmZOktQB05mG/Ln8CO7YSSvabMAF0
         8znOhQKsKTtDkKV5hi89grMkCePjl4Stxo17qDxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 051/121] selftests: pmtu.sh: Kill nettest processes launched in subshell.
Date:   Mon, 14 Mar 2022 12:53:54 +0100
Message-Id: <20220314112745.550881854@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 94a4a4fe4c696413932eed8bdec46574de9576b8 ]

When using "run_cmd <command> &", then "$!" refers to the PID of the
subshell used to run <command>, not the command itself. Therefore
nettest_pids actually doesn't contain the list of the nettest commands
running in the background. So cleanup() can't kill them and the nettest
processes run until completion (fortunately they have a 5s timeout).

Fix this by defining a new command for running processes in the
background, for which "$!" really refers to the PID of the command run.

Also, double quote variables on the modified lines, to avoid shellcheck
warnings.

Fixes: ece1278a9b81 ("selftests: net: add ESP-in-UDP PMTU test")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 2e8972573d91..694732e4b344 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -374,6 +374,16 @@ run_cmd() {
 	return $rc
 }
 
+run_cmd_bg() {
+	cmd="$*"
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "    COMMAND: %s &\n" "${cmd}"
+	fi
+
+	$cmd 2>&1 &
+}
+
 # Find the auto-generated name for this namespace
 nsname() {
 	eval echo \$NS_$1
@@ -670,10 +680,10 @@ setup_nettest_xfrm() {
 	[ ${1} -eq 6 ] && proto="-6" || proto=""
 	port=${2}
 
-	run_cmd ${ns_a} nettest ${proto} -q -D -s -x -p ${port} -t 5 &
+	run_cmd_bg "${ns_a}" nettest "${proto}" -q -D -s -x -p "${port}" -t 5
 	nettest_pids="${nettest_pids} $!"
 
-	run_cmd ${ns_b} nettest ${proto} -q -D -s -x -p ${port} -t 5 &
+	run_cmd_bg "${ns_b}" nettest "${proto}" -q -D -s -x -p "${port}" -t 5
 	nettest_pids="${nettest_pids} $!"
 }
 
-- 
2.34.1



