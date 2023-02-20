Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E55E69CE9A
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbjBTOAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbjBTOAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3D8A249
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AD3FB80D3A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC9CC4339B;
        Mon, 20 Feb 2023 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901585;
        bh=hpX5RhqmE8LsUZC3W8HZj54TpXjhg0t0DD4ui0J6Ebc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOybwMIXlL9djtAfuz5j7NRqYi51DbnDauhKVmRlcIFYZjI5Uw0ynqFqmHglLhpY1
         9Hlx5fJ3HcLH0sUyF6N8k9NJ4E9EOFcK+mcCA7zANO9k2lfsasIgHYHpnpSooilIS6
         BkCfYmtU6zvcIaXi8Cdp/S+9eGgn+nCrKIn5avQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.1 074/118] coredump: Move dump_emit_page() to kill unused warning
Date:   Mon, 20 Feb 2023 14:36:30 +0100
Message-Id: <20230220133603.381642402@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 9c7417b5ec440242bb5b64521acd53d4e19130c1 upstream.

If CONFIG_ELF_CORE is not set:

    fs/coredump.c:835:12: error: ‘dump_emit_page’ defined but not used [-Werror=unused-function]
      835 | static int dump_emit_page(struct coredump_params *cprm, struct page *page)
          |            ^~~~~~~~~~~~~~

Fix this by moving dump_emit_page() inside the existing section
protected by #ifdef CONFIG_ELF_CORE.

Fixes: 06bbaa6dc53cb720 ("[coredump] don't use __kernel_write() on kmap_local_page()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -831,6 +831,30 @@ static int __dump_skip(struct coredump_p
 	}
 }
 
+int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+{
+	if (cprm->to_skip) {
+		if (!__dump_skip(cprm, cprm->to_skip))
+			return 0;
+		cprm->to_skip = 0;
+	}
+	return __dump_emit(cprm, addr, nr);
+}
+EXPORT_SYMBOL(dump_emit);
+
+void dump_skip_to(struct coredump_params *cprm, unsigned long pos)
+{
+	cprm->to_skip = pos - cprm->pos;
+}
+EXPORT_SYMBOL(dump_skip_to);
+
+void dump_skip(struct coredump_params *cprm, size_t nr)
+{
+	cprm->to_skip += nr;
+}
+EXPORT_SYMBOL(dump_skip);
+
+#ifdef CONFIG_ELF_CORE
 static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 {
 	struct bio_vec bvec = {
@@ -864,30 +888,6 @@ static int dump_emit_page(struct coredum
 	return 1;
 }
 
-int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
-{
-	if (cprm->to_skip) {
-		if (!__dump_skip(cprm, cprm->to_skip))
-			return 0;
-		cprm->to_skip = 0;
-	}
-	return __dump_emit(cprm, addr, nr);
-}
-EXPORT_SYMBOL(dump_emit);
-
-void dump_skip_to(struct coredump_params *cprm, unsigned long pos)
-{
-	cprm->to_skip = pos - cprm->pos;
-}
-EXPORT_SYMBOL(dump_skip_to);
-
-void dump_skip(struct coredump_params *cprm, size_t nr)
-{
-	cprm->to_skip += nr;
-}
-EXPORT_SYMBOL(dump_skip);
-
-#ifdef CONFIG_ELF_CORE
 int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		    unsigned long len)
 {


