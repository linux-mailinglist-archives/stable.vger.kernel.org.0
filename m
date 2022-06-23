Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D45558AE8
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 23:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiFWVp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 17:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWVp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 17:45:57 -0400
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDBF5DF0E
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 14:45:56 -0700 (PDT)
Received: by mail-qv1-f48.google.com with SMTP id t16so2037581qvh.1
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 14:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=0CKIvS9aMMD66vxtqOCpuSRDl9nO4eJxY8IunK0l4JM=;
        b=U4fvShdJCpRX8t1U4xvZMRV4hD7Zi7hX9TmDsu9D1D8CpwQbZDrorznJKwjzZ0AziF
         t52I7iOPE+FDNvPpbi6s7d7ZZUuZ1K7GiwAuSZzQm0mpSrPnVeeN9vB3D/toLeDGa7PG
         5z9CTJBSJuUjI7gMx5wKuZSZesPy31j6dxEv2WVU/m6ENLppLFQKC7jzWPBWGoDrFRiu
         gK/lnGjzc3vEyBtOqJXTY6WVkn/RC0p9DSUMcXmMs4Ch6M1rWxVtXpQ+3zt5qN6SKK4Q
         hUyzyodTTzeZNpFvcg9VCUqyf6cNr0Cs0kS7y4V4qfK9bNknvUYvZF4YDsZi/TwmmddK
         sdPQ==
X-Gm-Message-State: AJIora/aF0WZj2sVcrf6g043diOcEZF0Q0Ht+0shjDmlR/ylUJpxBaAQ
        2GDQC9O5zN9+8Lvql29yZYot8w==
X-Google-Smtp-Source: AGRyM1v2usadGTyZlqb6Ml0femKSWEGiKQVOdlevtUzZRfFJcHhEqUEnKteRGPis2XQ5p5NCS+A1cw==
X-Received: by 2002:a05:6214:e83:b0:470:54c3:e18e with SMTP id hf3-20020a0562140e8300b0047054c3e18emr13015049qvb.3.1656020755830;
        Thu, 23 Jun 2022 14:45:55 -0700 (PDT)
Received: from castiana ([2602:fc62:a:35::50])
        by smtp.gmail.com with ESMTPSA id n8-20020a05620a222800b006ab935c1563sm483237qkh.8.2022.06.23.14.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 14:45:55 -0700 (PDT)
Date:   Thu, 23 Jun 2022 16:45:52 -0500
From:   =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH RESEND] tools/vm/slabinfo: Handle files in debugfs
Message-ID: <YrTfEHvpysJAVWWr@castiana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mailer: git-send-email 2.34.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 tools/vm/slabinfo.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/vm/slabinfo.c b/tools/vm/slabinfo.c
index 9b68658b6bb8..5b98f3ee58a5 100644
--- a/tools/vm/slabinfo.c
+++ b/tools/vm/slabinfo.c
@@ -233,6 +233,24 @@ static unsigned long read_slab_obj(struct slabinfo *s, const char *name)
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
@@ -409,14 +427,18 @@ static void show_tracking(struct slabinfo *s)
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
-- 
2.34.1

