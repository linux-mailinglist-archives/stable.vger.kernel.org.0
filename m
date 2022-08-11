Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB11590079
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiHKPlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbiHKPkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:40:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E696979DC;
        Thu, 11 Aug 2022 08:36:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4815EB82150;
        Thu, 11 Aug 2022 15:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8B7C43470;
        Thu, 11 Aug 2022 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232183;
        bh=k6nO4fjfTkhtJ138HaiEUBSacWXxEDdivO/PIUq8etQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDtuGe1Ns6N/K10//tHoX/rQS/5qgyllJ13q8jpo7X7ISeHwjQ5GNS891StyovsCs
         QwzHiWFom2hJugdsxn0eCg3ztNqWCcbb7OjV5h52pYz9nzP/yET7Sj3XTIXnPKyewn
         MRfviGR9jvZO4/saa5P8UE+WeY+H9GxnC2Vl/UUUI6hCp7+ciaarJuAD9EKNqjK/Lq
         WK++gxQiDrUDzXoJRWVNhFLGhUBv3inIn45i4n8oRjKXCSWGZDvX1eYVEs2z7VXqiA
         C+prbR0VGgostFXApK4wz4VWTGOkEtv1Owt1pHjGmdEekpIcBE+NVZB3oDZw8sAyTS
         V5xttWi4evFRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 067/105] libbpf: Disable SEC pragma macro on GCC
Date:   Thu, 11 Aug 2022 11:27:51 -0400
Message-Id: <20220811152851.1520029-67-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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
index fb04eaf367f1..7349b16b8e2f 100644
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

