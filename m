Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE1D69CDC6
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjBTNwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjBTNwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:52:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6FE1E5E7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:52:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 267E3B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B24C433D2;
        Mon, 20 Feb 2023 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901157;
        bh=dlRG28eDaZZOb82X9D2oJ6HKZ0FJSaz4vxukc43/J/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLu6WiUgbsPBjlcMwg9t57kJbDk6xJ8gTkhvBpsQ1X0UX6V58idXfZbM7+SPmdAnW
         Us8Tt4CTvVV6B0hGao6w1ZoZlMy3L6qlY/4jxFo6uYnkJ27Zjv15XL2HTKQWXPDMTt
         19ybDKc4x9NI6PvgOlwECruaZ1TIDQnmnNwjQlIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Paniakin <apanyaki@amazon.com>
Subject: [PATCH 5.15 51/83] selftest/lkdtm: Skip stack-entropy test if lkdtm is not available
Date:   Mon, 20 Feb 2023 14:36:24 +0100
Message-Id: <20230220133555.441514982@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

commit 90091c367e74d5b58d9ebe979cc363f7468f58d3 upstream.

Exit with return code 4 if lkdtm is not available like other tests
in order to properly skip the test.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210805101236.1140381-1-misono.tomohiro@jp.fujitsu.com
Cc: Andrew Paniakin <apanyaki@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/lkdtm/stack-entropy.sh |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/lkdtm/stack-entropy.sh
+++ b/tools/testing/selftests/lkdtm/stack-entropy.sh
@@ -4,13 +4,27 @@
 # Measure kernel stack entropy by sampling via LKDTM's REPORT_STACK test.
 set -e
 samples="${1:-1000}"
+TRIGGER=/sys/kernel/debug/provoke-crash/DIRECT
+KSELFTEST_SKIP_TEST=4
+
+# Verify we have LKDTM available in the kernel.
+if [ ! -r $TRIGGER ] ; then
+	/sbin/modprobe -q lkdtm || true
+	if [ ! -r $TRIGGER ] ; then
+		echo "Cannot find $TRIGGER (missing CONFIG_LKDTM?)"
+	else
+		echo "Cannot write $TRIGGER (need to run as root?)"
+	fi
+	# Skip this test
+	exit $KSELFTEST_SKIP_TEST
+fi
 
 # Capture dmesg continuously since it may fill up depending on sample size.
 log=$(mktemp -t stack-entropy-XXXXXX)
 dmesg --follow >"$log" & pid=$!
 report=-1
 for i in $(seq 1 $samples); do
-        echo "REPORT_STACK" >/sys/kernel/debug/provoke-crash/DIRECT
+        echo "REPORT_STACK" > $TRIGGER
 	if [ -t 1 ]; then
 		percent=$(( 100 * $i / $samples ))
 		if [ "$percent" -ne "$report" ]; then


