Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860C758DEEB
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343891AbiHIS2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347209AbiHIS07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:26:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B624F29C9B;
        Tue,  9 Aug 2022 11:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82805B81912;
        Tue,  9 Aug 2022 18:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16E8C433C1;
        Tue,  9 Aug 2022 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068479;
        bh=UinAzkFxj+BLJyuf4XCMytJV/KED8ZQPD9DVBguyrlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBSYpoll6/Jd+vuDo7q2Oy8iMXBS7P6WVFaJcLp5Ua0JmugV9cUmoHT9fhzTo9cGw
         4oYgJxr9dQF9kp7iAZtir286AI7dwvL5YMUEjQzQdMd5UPt3N01unxJmm5kuvctlB+
         OuKPOEGAVzlefTFnvENRY6Q8wgm1zmyCkSOU8HeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.19 02/21] tools/vm/slabinfo: Handle files in debugfs
Date:   Tue,  9 Aug 2022 20:00:54 +0200
Message-Id: <20220809175513.423515300@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
References: <20220809175513.345597655@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Stéphane Graber <stgraber@ubuntu.com>

commit 0c7e0d699ef1430d7f4cf12b4b1d097af58b5515 upstream.

Commit 64dd68497be76 relocated and renamed the alloc_calls and
free_calls files from /sys/kernel/slab/NAME/*_calls over to
/sys/kernel/debug/slab/NAME/*_calls but didn't update the slabinfo tool
with the new location.

This change will now have slabinfo look at the new location (and filenames)
with a fallback to the prior files.

Fixes: 64dd68497be76 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
Cc: stable@vger.kernel.org
Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
Tested-by: Stéphane Graber <stgraber@ubuntu.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/vm/slabinfo.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/tools/vm/slabinfo.c
+++ b/tools/vm/slabinfo.c
@@ -233,6 +233,24 @@ static unsigned long read_slab_obj(struc
 	return l;
 }
 
+static unsigned long read_debug_slab_obj(struct slabinfo *s, const char *name)
+{
+	char x[128];
+	FILE *f;
+	size_t l;
+
+	snprintf(x, 128, "/sys/kernel/debug/slab/%s/%s", s->name, name);
+	f = fopen(x, "r");
+	if (!f) {
+		buffer[0] = 0;
+		l = 0;
+	} else {
+		l = fread(buffer, 1, sizeof(buffer), f);
+		buffer[l] = 0;
+		fclose(f);
+	}
+	return l;
+}
 
 /*
  * Put a size string together
@@ -409,14 +427,18 @@ static void show_tracking(struct slabinf
 {
 	printf("\n%s: Kernel object allocation\n", s->name);
 	printf("-----------------------------------------------------------------------\n");
-	if (read_slab_obj(s, "alloc_calls"))
+	if (read_debug_slab_obj(s, "alloc_traces"))
+		printf("%s", buffer);
+	else if (read_slab_obj(s, "alloc_calls"))
 		printf("%s", buffer);
 	else
 		printf("No Data\n");
 
 	printf("\n%s: Kernel object freeing\n", s->name);
 	printf("------------------------------------------------------------------------\n");
-	if (read_slab_obj(s, "free_calls"))
+	if (read_debug_slab_obj(s, "free_traces"))
+		printf("%s", buffer);
+	else if (read_slab_obj(s, "free_calls"))
 		printf("%s", buffer);
 	else
 		printf("No Data\n");


