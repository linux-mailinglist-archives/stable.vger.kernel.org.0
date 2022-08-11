Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD7559020C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiHKQDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbiHKQDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:03:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88C840BFA;
        Thu, 11 Aug 2022 08:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5065860EFD;
        Thu, 11 Aug 2022 15:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363FC433D7;
        Thu, 11 Aug 2022 15:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232992;
        bh=Zdu0pGnp+BN7k6SBK11UDmJyAeMoemju4zLntExZYlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meSYX2SRBmuCLzVlIART2SvlRWqjT22D5DwE+HksGDNclirh2TaLoDZlJlxmZqXYj
         cQ6H/nDlvnudPGCFR1mN60uDTx81E6f88sPcZ4SYTS2LKqfYr/yN5fxa+9Z25eLQHI
         LHCIRlIWdteAr0ttzXANWgo7absk7xbURVhEa8ccuk5GFmsVnQzgc1KLzlNWJRDllo
         WvLXZP4JiBV2lV3G+cQUMzgakbu/wEBvYVIE5v44pgIezZQQv21DKUSN/251AwsGBj
         Goz6iB+PMcqZzStAEMjXgl56Dswf29b4t4u0wR0BF+vAiWhUezVcscfCB97nz7cdvm
         S4+rijcxc3tTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 60/93] libbpf: Disable SEC pragma macro on GCC
Date:   Thu, 11 Aug 2022 11:41:54 -0400
Message-Id: <20220811154237.1531313-60-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 18410251f66aee7e82234073ce6656ca20a732a9 ]

It seems the gcc preprocessor breaks with pragmas when surrounding
__attribute__.

Disable these pragmas on GCC due to upstream bugs see:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=55578
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=90400

Fixes errors like:
error: expected identifier or '(' before '#pragma'
  106 | SEC("cgroup/bind6")
      | ^~~

error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
  114 | char _license[] SEC("license") = "GPL";
      | ^~~

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220706111839.1247911-1-james.hilliard1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_helpers.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 44df982d2a5c..e1ba0f3bb1ff 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -22,12 +22,25 @@
  * To allow use of SEC() with externs (e.g., for extern .maps declarations),
  * make sure __attribute__((unused)) doesn't trigger compilation warning.
  */
+#if __GNUC__ && !__clang__
+
+/*
+ * Pragma macros are broken on GCC
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=55578
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=90400
+ */
+#define SEC(name) __attribute__((section(name), used))
+
+#else
+
 #define SEC(name) \
 	_Pragma("GCC diagnostic push")					    \
 	_Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")	    \
 	__attribute__((section(name), used))				    \
 	_Pragma("GCC diagnostic pop")					    \
 
+#endif
+
 /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
 #undef __always_inline
 #define __always_inline inline __attribute__((always_inline))
-- 
2.35.1

