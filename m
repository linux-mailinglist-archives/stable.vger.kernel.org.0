Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB8566C50C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjAPQBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjAPQA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5846919B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 173E8B8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2ACC433EF;
        Mon, 16 Jan 2023 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884853;
        bh=e2MSWj94IR5+M3v5Wv/qjLDQZ8/vs4jUFWSZe/1Uxvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUHVhzrlUM+VfBkt3vkpoKlVS9h2+W2Y91l4wfnpgwjzc1fPCzEh/1KdYo71n+AHF
         vDWvKdyUIOxwXb/O61NEf7ke5UPCEgANWd2K7yjtcqXCdWS+c6bqm46kR4H7UQAPTe
         8O66sIeUnGlOddepZ+mYBZZKkKxkwmXYjaRG/oVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/183] selftests/net: l2_tos_ttl_inherit.sh: Ensure environment cleanup on failure.
Date:   Mon, 16 Jan 2023 16:51:26 +0100
Message-Id: <20230116154810.198183048@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit d68ff8ad3351b8fc8d6f14b9a4f5cc8ba3e8bd13 ]

Use 'set -e' and an exit handler to stop the script if a command fails
and ensure the test environment is cleaned up in any case. Also, handle
the case where the script is interrupted by SIGINT.

The only command that's expected to fail is 'wait $ping_pid', since
it's killed by the script. Handle this case with '|| true' to make it
play well with 'set -e'.

Finally, return the Kselftest SKIP code (4) when the script breaks
because of an environment problem or a command line failure. The 0 and
1 return codes should now reliably indicate that all tests have been
run (0: all tests run and passed, 1: all tests run but at least one
failed, 4: test script didn't run completely).

Fixes: b690842d12fd ("selftests/net: test l2 tunnel TOS/TTL inheriting")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/l2_tos_ttl_inherit.sh       | 40 +++++++++++++++++--
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
index cf56680d598f..f11756e7df2f 100755
--- a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
+++ b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
@@ -12,13 +12,16 @@
 # In addition this script also checks if forcing a specific field in the
 # outer header is working.
 
+# Return 4 by default (Kselftest SKIP code)
+ERR=4
+
 if [ "$(id -u)" != "0" ]; then
 	echo "Please run as root."
-	exit 0
+	exit $ERR
 fi
 if ! which tcpdump > /dev/null 2>&1; then
 	echo "No tcpdump found. Required for this test."
-	exit 0
+	exit $ERR
 fi
 
 expected_tos="0x00"
@@ -340,7 +343,7 @@ verify() {
 		fi
 	fi
 	kill -9 $ping_pid
-	wait $ping_pid 2>/dev/null
+	wait $ping_pid 2>/dev/null || true
 	result="FAIL"
 	if [ "$outer" = "4" ]; then
 		captured_ttl="$(get_field "ttl" "$out")"
@@ -380,6 +383,31 @@ cleanup() {
 	ip netns del "${NS1}" 2>/dev/null
 }
 
+exit_handler() {
+	# Don't exit immediately if one of the intermediate commands fails.
+	# We might be called at the end of the script, when the network
+	# namespaces have already been deleted. So cleanup() may fail, but we
+	# still need to run until 'exit $ERR' or the script won't return the
+	# correct error code.
+	set +e
+
+	cleanup
+
+	exit $ERR
+}
+
+# Restore the default SIGINT handler (just in case) and exit.
+# The exit handler will take care of cleaning everything up.
+interrupted() {
+	trap - INT
+
+	exit $ERR
+}
+
+set -e
+trap exit_handler EXIT
+trap interrupted INT
+
 printf "┌────────┬───────┬───────┬──────────────┬"
 printf "──────────────┬───────┬────────┐\n"
 for type in gre vxlan geneve; do
@@ -409,6 +437,10 @@ done
 printf "└────────┴───────┴───────┴──────────────┴"
 printf "──────────────┴───────┴────────┘\n"
 
+# All tests done.
+# Set ERR appropriately: it will be returned by the exit handler.
 if $failed; then
-	exit 1
+	ERR=1
+else
+	ERR=0
 fi
-- 
2.35.1



