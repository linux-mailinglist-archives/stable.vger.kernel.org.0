Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0698594943
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354212AbiHOXn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354355AbiHOXl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D171326D4;
        Mon, 15 Aug 2022 13:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A40F260F0C;
        Mon, 15 Aug 2022 20:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2793C433C1;
        Mon, 15 Aug 2022 20:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594394;
        bh=qEpQ0ORfio4GJ377cmHUYJ9BxN5FNFj0Pwgm6gFsi3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGCVphEezcamr4mUz1Ye2rBvO4lozTMQq9+vs8C/p2RgiFuwJfoJiEk0aEC2R6Oeo
         tqLg4mO6X9nyzFEu64MA51jT/OWG3FmXSSCnmMwVKlnh9a3X9P03EUD2tlpMKQ5Ytm
         Y1XKqn6t2XyJuSCOSTCD4S0jCKkGxCyZeb2eO4HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0431/1157] selftests: net: fib_rule_tests: fix support for running individual tests
Date:   Mon, 15 Aug 2022 19:56:27 +0200
Message-Id: <20220815180456.899438908@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>

[ Upstream commit 9c154ab47f5e5ff632d2b7af6342c027d7e04b92 ]

parsing and usage of -t got missed in the previous patch.
this patch fixes it

Fixes: 816cda9ae531 ("selftests: net: fib_rule_tests: add support to select a test to run")
Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index bbe3b379927a..c245476fa29d 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -303,6 +303,29 @@ run_fibrule_tests()
 	log_section "IPv6 fib rule"
 	fib_rule6_test
 }
+################################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $TESTS)
+EOF
+}
+
+################################################################################
+# main
+
+while getopts ":t:h" opt; do
+	case $opt in
+		t) TESTS=$OPTARG;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
 
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
-- 
2.35.1



