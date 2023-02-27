Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18966A3825
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjB0CQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjB0CPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:15:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8381E5C3;
        Sun, 26 Feb 2023 18:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47E88B80D28;
        Mon, 27 Feb 2023 02:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD1AC433D2;
        Mon, 27 Feb 2023 02:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463881;
        bh=+w6xRfnl0rTwGBZqJJDym/Ma7rrvgFKMziUfFS+k078=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEYymvwRalxse7heVnCGa0/FDJcwDIMkR+6kS39GwS+Q1LkvtS3QJJrlgl33v4PHB
         UlQrxtjVGTKfG1xj1AtlTzGWWAus1kTFFTD67diFhAbXG44YT6DGztTrIR6MrGMknJ
         KbFK2vBn7FalvHCe4UFiM125Rwbh4qeJBG2KZefF/KE2sncEOIFhMW6rGOh7GtgNN7
         jIGii6q8RnS1Jur+amrPAWi6ysJGEC+zj0WfMW/8lqqvRy6QVzyGnpOLGKTePLtJfa
         KjeceeRM5DfKkJawHhR7APl1rZYqAFC1k8vV7wML02jTg5M1OY04sRIeBHqhO+Xnt7
         sn8gEEnt/g29A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakob Koschel <jkl820.git@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/10] docs/scripts/gdb: add necessary make scripts_gdb step
Date:   Sun, 26 Feb 2023 21:11:01 -0500
Message-Id: <20230227021110.1053474-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021110.1053474-1-sashal@kernel.org>
References: <20230227021110.1053474-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Koschel <jkl820.git@gmail.com>

[ Upstream commit 6b219431037bf98c9efd49716aea9b68440477a3 ]

In order to debug the kernel successfully with gdb you need to run
'make scripts_gdb' nowadays.

This was changed with the following commit:

Commit 67274c083438340ad16c ("scripts/gdb: delay generation of gdb
constants.py")

In order to have a complete guide for beginners this remark
should be added to the offial documentation.

Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
Link: https://lore.kernel.org/r/20230112-documentation-gdb-v2-1-292785c43dc9@gmail.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/dev-tools/gdb-kernel-debugging.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/dev-tools/gdb-kernel-debugging.rst b/Documentation/dev-tools/gdb-kernel-debugging.rst
index 19df79286f000..afe4bc206486c 100644
--- a/Documentation/dev-tools/gdb-kernel-debugging.rst
+++ b/Documentation/dev-tools/gdb-kernel-debugging.rst
@@ -39,6 +39,10 @@ Setup
   this mode. In this case, you should build the kernel with
   CONFIG_RANDOMIZE_BASE disabled if the architecture supports KASLR.
 
+- Build the gdb scripts (required on kernels v5.1 and above)::
+
+    make scripts_gdb
+
 - Enable the gdb stub of QEMU/KVM, either
 
     - at VM startup time by appending "-s" to the QEMU command line
-- 
2.39.0

