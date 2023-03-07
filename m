Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6216AF3C5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbjCGTJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjCGTJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:09:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0630AF0D1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:53:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 440B861520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37531C433D2;
        Tue,  7 Mar 2023 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215233;
        bh=efnEjqKVnr/KdPuNOmdr+o+2+lX01D2qmPN1uJ4cFvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOAyL+9rTD/z8mDbWgOUQ6u/YnY3PRtfJXI6QYaFCwBR7hujdWijf0DkL75D26GTv
         97w7otoNejaFocsvy8vF23agXVGe3xJKux3b6VCu+52Vk6yC4d/v2vfwS2FS/PfksU
         T2y1pDsJINMjHU803sUo8g6Z+9K/ZzVeSrjJKuWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Roxana Nicolescu <roxana.nicolescu@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/567] selftest: fib_tests: Always cleanup before exit
Date:   Tue,  7 Mar 2023 17:58:18 +0100
Message-Id: <20230307165912.955551236@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 7df066bf74b87..c64b0b1217621 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1921,6 +1921,8 @@ EOF
 ################################################################################
 # main
 
+trap cleanup EXIT
+
 while getopts :t:pPhv o
 do
 	case $o in
-- 
2.39.2



