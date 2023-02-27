Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42256A37CA
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjB0CLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjB0CKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:10:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD081C325;
        Sun, 26 Feb 2023 18:09:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C158F60DB5;
        Mon, 27 Feb 2023 02:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959CCC433D2;
        Mon, 27 Feb 2023 02:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463775;
        bh=eF84hPSUlq0NnK3I0lJ1wPe3Vof4mcdSUvR4+5Y5PYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdNLKAYijoLjnvCdKezoaqWkov1J076fMONfJV8MydK+MgwG5v06tQQb0UzPm4zpI
         RLSUHAracgC/8MH0qRh9+fX3Fu8oUpOLfrK1mZXIHKiWtG7Lwnrt7I7PiKgOHIF1t9
         MY1U7NF2TgbQpG+WFJcF0ZtJNp2rxKPaoCqfQt62QGzxC+QYJrrgEOJ47TgXKgrWgS
         cf7ZwfqidOeBAf3/3QitPEcw4h7AJZZ1VtbgdTHZRuNsn2TsPrnN43lYn+R1lVmyp8
         /IPC8pucKEAsMa2JmpdoAt0VZVtgUm/TDSPmM3NsOJiaNoM/u7WcuOm9ISY6wR5L7c
         vcAiqySSqdmzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakob Koschel <jkl820.git@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/25] docs/scripts/gdb: add necessary make scripts_gdb step
Date:   Sun, 26 Feb 2023 21:08:35 -0500
Message-Id: <20230227020855.1051605-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
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
index 8e0f1fe8d17ad..895285c037c72 100644
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

