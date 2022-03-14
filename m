Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319774D8274
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbiCNMEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240303AbiCNMDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:03:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBB44889D;
        Mon, 14 Mar 2022 05:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34857612E3;
        Mon, 14 Mar 2022 12:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335F8C340E9;
        Mon, 14 Mar 2022 12:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259283;
        bh=TivhPATrwMOW+9avUqaU3TJ/EDryf9WqIBl9mw7mW6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ezxFeyaSUYlnHJ2lYQhBglLSWLVdPU2b3jpm8lG3vvoeZ8BZ0W3FgZHBhp25Kczm
         9t/KQZwF8adIOtebg5mP2OXhcUXLY5ErYT8jt7CFRzW1gkPNPNeF5qNR106YGyselP
         GPp3YfUUz71tovktTp1GQCx4QGN3zrAa2wuU/Pn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/71] mISDN: Remove obsolete PIPELINE_DEBUG debugging information
Date:   Mon, 14 Mar 2022 12:52:59 +0100
Message-Id: <20220314112738.111482270@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 2682ea324b000709dafec7e9210caa5189377c45 ]

As Leon Romanovsky's tips:
The definition of macro PIPELINE_DEBUG is commented more than 10 years ago
and can be seen as a dead code that should be removed.

Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/dsp_pipeline.c | 46 ++-----------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 40588692cec7..e11ca6bbc7f4 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -17,9 +17,6 @@
 #include "dsp.h"
 #include "dsp_hwec.h"
 
-/* uncomment for debugging */
-/*#define PIPELINE_DEBUG*/
-
 struct dsp_pipeline_entry {
 	struct mISDN_dsp_element *elem;
 	void                *p;
@@ -104,10 +101,6 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 		}
 	}
 
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: %s registered\n", __func__, elem->name);
-#endif
-
 	return 0;
 
 err2:
@@ -129,10 +122,6 @@ void mISDN_dsp_element_unregister(struct mISDN_dsp_element *elem)
 	list_for_each_entry_safe(entry, n, &dsp_elements, list)
 		if (entry->elem == elem) {
 			device_unregister(&entry->dev);
-#ifdef PIPELINE_DEBUG
-			printk(KERN_DEBUG "%s: %s unregistered\n",
-			       __func__, elem->name);
-#endif
 			return;
 		}
 	printk(KERN_ERR "%s: element %s not in list.\n", __func__, elem->name);
@@ -145,10 +134,6 @@ int dsp_pipeline_module_init(void)
 	if (IS_ERR(elements_class))
 		return PTR_ERR(elements_class);
 
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline module initialized\n", __func__);
-#endif
-
 	dsp_hwec_init();
 
 	return 0;
@@ -168,10 +153,6 @@ void dsp_pipeline_module_exit(void)
 		       __func__, entry->elem->name);
 		kfree(entry);
 	}
-
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline module exited\n", __func__);
-#endif
 }
 
 int dsp_pipeline_init(struct dsp_pipeline *pipeline)
@@ -181,10 +162,6 @@ int dsp_pipeline_init(struct dsp_pipeline *pipeline)
 
 	INIT_LIST_HEAD(&pipeline->list);
 
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline ready\n", __func__);
-#endif
-
 	return 0;
 }
 
@@ -210,15 +187,11 @@ void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
 		return;
 
 	_dsp_pipeline_destroy(pipeline);
-
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline destroyed\n", __func__);
-#endif
 }
 
 int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 {
-	int incomplete = 0, found = 0;
+	int found = 0;
 	char *dup, *tok, *name, *args;
 	struct dsp_element_entry *entry, *n;
 	struct dsp_pipeline_entry *pipeline_entry;
@@ -251,7 +224,6 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 					printk(KERN_ERR "%s: failed to add "
 					       "entry to pipeline: %s (out of "
 					       "memory)\n", __func__, elem->name);
-					incomplete = 1;
 					goto _out;
 				}
 				pipeline_entry->elem = elem;
@@ -268,20 +240,12 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 					if (pipeline_entry->p) {
 						list_add_tail(&pipeline_entry->
 							      list, &pipeline->list);
-#ifdef PIPELINE_DEBUG
-						printk(KERN_DEBUG "%s: created "
-						       "instance of %s%s%s\n",
-						       __func__, name, args ?
-						       " with args " : "", args ?
-						       args : "");
-#endif
 					} else {
 						printk(KERN_ERR "%s: failed "
 						       "to add entry to pipeline: "
 						       "%s (new() returned NULL)\n",
 						       __func__, elem->name);
 						kfree(pipeline_entry);
-						incomplete = 1;
 					}
 				}
 				found = 1;
@@ -290,11 +254,9 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 
 		if (found)
 			found = 0;
-		else {
+		else
 			printk(KERN_ERR "%s: element not found, skipping: "
 			       "%s\n", __func__, name);
-			incomplete = 1;
-		}
 	}
 
 _out:
@@ -303,10 +265,6 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 	else
 		pipeline->inuse = 0;
 
-#ifdef PIPELINE_DEBUG
-	printk(KERN_DEBUG "%s: dsp pipeline built%s: %s\n",
-	       __func__, incomplete ? " incomplete" : "", cfg);
-#endif
 	kfree(dup);
 	return 0;
 }
-- 
2.34.1



