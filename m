Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FBD4F2F9F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356038AbiDEKWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347989AbiDEJ3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:29:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E6DFFB1;
        Tue,  5 Apr 2022 02:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BA73B81B14;
        Tue,  5 Apr 2022 09:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A48C385A2;
        Tue,  5 Apr 2022 09:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150158;
        bh=YyaqKt4emR4QrHkLMVt4S1mW679qGg2lM39pkxvrAYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0CMHKrPpyjVeD2FLMXVjvr89shnEb5OMWXfohD+xpCTnlw6au8qSDZIIW/13WsHC
         XGG2w5ggrApZIh9NQv8gs5QwolJ0CfUsUosx5F0P/XU7OtnpvO92k5nTbF01kYzpMh
         2XomJjLnx4+EKQRcEkzm4Xj1w/bM4NfqRWhUY67Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.16 0976/1017] libbpf: Define BTF_KIND_* constants in btf.h to avoid compilation errors
Date:   Tue,  5 Apr 2022 09:31:29 +0200
Message-Id: <20220405070423.175749554@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit eaa266d83a3730a15de2ceebcc89e8f6290e8cf6 upstream.

The btf.h header included with libbpf contains inline helper functions to
check for various BTF kinds. These helpers directly reference the
BTF_KIND_* constants defined in the kernel header, and because the header
file is included in user applications, this happens in the user application
compile units.

This presents a problem if a user application is compiled on a system with
older kernel headers because the constants are not available. To avoid
this, add #defines of the constants directly in btf.h before using them.

Since the kernel header moved to an enum for BTF_KIND_*, the #defines can
shadow the enum values without any errors, so we only need #ifndef guards
for the constants that predates the conversion to enum. We group these so
there's only one guard for groups of values that were added together.

  [0] Closes: https://github.com/libbpf/libbpf/issues/436

Fixes: 223f903e9c83 ("bpf: Rename BTF_KIND_TAG to BTF_KIND_DECL_TAG")
Fixes: 5b84bd10363e ("libbpf: Add support for BTF_KIND_TAG")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/bpf/20220118141327.34231-1-toke@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/btf.h |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -313,8 +313,28 @@ btf_dump__dump_type_data(struct btf_dump
 			 const struct btf_dump_type_data_opts *opts);
 
 /*
- * A set of helpers for easier BTF types handling
+ * A set of helpers for easier BTF types handling.
+ *
+ * The inline functions below rely on constants from the kernel headers which
+ * may not be available for applications including this header file. To avoid
+ * compilation errors, we define all the constants here that were added after
+ * the initial introduction of the BTF_KIND* constants.
  */
+#ifndef BTF_KIND_FUNC
+#define BTF_KIND_FUNC		12	/* Function	*/
+#define BTF_KIND_FUNC_PROTO	13	/* Function Proto	*/
+#endif
+#ifndef BTF_KIND_VAR
+#define BTF_KIND_VAR		14	/* Variable	*/
+#define BTF_KIND_DATASEC	15	/* Section	*/
+#endif
+#ifndef BTF_KIND_FLOAT
+#define BTF_KIND_FLOAT		16	/* Floating point	*/
+#endif
+/* The kernel header switched to enums, so these two were never #defined */
+#define BTF_KIND_DECL_TAG	17	/* Decl Tag */
+#define BTF_KIND_TYPE_TAG	18	/* Type Tag */
+
 static inline __u16 btf_kind(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info);


