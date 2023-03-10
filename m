Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02496B47F7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjCJO4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbjCJO4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:56:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14627126F1B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1531BB822EA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806DCC433D2;
        Fri, 10 Mar 2023 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459870;
        bh=okWJFnxiQZE3oJeuASECpxcvqjJCSvJr3Au3CnQwfaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ihsk1hMYuXoEjMh6IuZABHnc2frFDOMzCJDPxciAz7zczG4sMGOvMKAv4DGyvGbTq
         sYB9RHQWr/p/k8HTC+ic8vOGqGBxpWihv44DHSIqoPEkninX4EdMsWNQ/lmgfKB7W5
         P0Ci0S4yRBltbvA5upi+Fcrh/+OucRDAV21Z3VfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Roxana Nicolescu <roxana.nicolescu@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/529] selftest: fib_tests: Always cleanup before exit
Date:   Fri, 10 Mar 2023 14:34:49 +0100
Message-Id: <20230310133811.723868793@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roxana Nicolescu <roxana.nicolescu@canonical.com>

[ Upstream commit b60417a9f2b890a8094477b2204d4f73c535725e ]

Usage of `set -e` before executing a command causes immediate exit
on failure, without cleanup up the resources allocated at setup.
This can affect the next tests that use the same resources,
leading to a chain of failures.

A simple fix is to always call cleanup function when the script exists.
This approach is already used by other existing tests.

Fixes: 1056691b2680 ("selftests: fib_tests: Make test results more verbose")
Signed-off-by: Roxana Nicolescu <roxana.nicolescu@canonical.com>
Link: https://lore.kernel.org/r/20230220110400.26737-2-roxana.nicolescu@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_tests.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 0f3bf90e04d36..8f42e17db5d09 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1773,6 +1773,8 @@ EOF
 ################################################################################
 # main
 
+trap cleanup EXIT
+
 while getopts :t:pPhv o
 do
 	case $o in
-- 
2.39.2



