Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C741D64EBA7
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiLPM4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLPM4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:56:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7EA511E2;
        Fri, 16 Dec 2022 04:56:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8F19B81D66;
        Fri, 16 Dec 2022 12:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010E1C433EF;
        Fri, 16 Dec 2022 12:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195401;
        bh=2QLoVGk209SaUKWKo2tocCt1tw8d0JNmir9rlSGElQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJV+0gLE7Az0wuEv0yY4um0DcCJUJmpxLa1bcGFYw1CRAjVVQ5AbTEC2rXNBv5mpF
         D2r1qfYYr7TCE6BnlXXKg2JU7rDjCZgK7i9BVUwmPUN0ACf5bXyWRHnRtKLOvmtEBU
         v+QxftCvZbFbFbQj4nkhlF0mDTB4bci2d8NYIxxZkBYtjIQYBDNnRslkIlduysNx25
         Xj2dE14hVhjGmKO2uqLMSXfn6S3Xr5xFDLfMw6Z75qLA3fh/OFxskvWT7Ht9eb+8Rq
         nc5W6WdyZv6tPdNZclfQq+NwEh8mE5/gOGgc9VuBKVNGXdb1M1iGGLbT0uSvXlMyVc
         WPsmwKss9pIsw==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
        bpf@vger.kernel.org, Martynas Pumputis <m@lambda.lt>
Subject: [PATCH stable 6.0 1/8] kallsyms: Make module_kallsyms_on_each_symbol generally available
Date:   Fri, 16 Dec 2022 13:56:21 +0100
Message-Id: <20221216125628.1622505-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221216125628.1622505-1-jolsa@kernel.org>
References: <20221216125628.1622505-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 73feb8d5fa3b755bb51077c0aabfb6aa556fd498 upstream.

Making module_kallsyms_on_each_symbol generally available, so it
can be used outside CONFIG_LIVEPATCH option in following changes.

Rather than adding another ifdef option let's make the function
generally available (when CONFIG_KALLSYMS and CONFIG_MODULES
options are defined).

Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-2-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/module.h   | 9 +++++++++
 kernel/module/kallsyms.c | 2 --
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 518296ea7f73..e72db35fbf75 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -879,8 +879,17 @@ static inline bool module_sig_ok(struct module *module)
 }
 #endif	/* CONFIG_MODULE_SIG */
 
+#if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
 int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data);
+#else
+static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+						 struct module *, unsigned long),
+						 void *data)
+{
+	return -EOPNOTSUPP;
+}
+#endif  /* CONFIG_MODULES && CONFIG_KALLSYMS */
 
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index f5c5c9175333..4523f99b0358 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -494,7 +494,6 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	return ret;
 }
 
-#ifdef CONFIG_LIVEPATCH
 int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data)
@@ -531,4 +530,3 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	mutex_unlock(&module_mutex);
 	return ret;
 }
-#endif /* CONFIG_LIVEPATCH */
-- 
2.38.1

