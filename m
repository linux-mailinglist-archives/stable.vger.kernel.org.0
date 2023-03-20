Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD62C6C0CFE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjCTJT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjCTJT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:19:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE7849D8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AFFD612CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F696C433D2;
        Mon, 20 Mar 2023 09:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303961;
        bh=FlO9Io5FczpwE7j4mm/lYA6NeuLE47sAjP5m7SYZnJM=;
        h=Subject:To:Cc:From:Date:From;
        b=anqMLAE27BZVTZW2CvZ5rw0hHLCni5FD+V8xCOxb1bwaxDWjs3DDJbzewjPsK9yXx
         m7PHGCBSX6QMJMtFLe1nWb2Zf4TS1eu9BcfRu/YQL72HZ4ACxl3IZGaqr9q5UHVd2b
         oVbGwmUJkh93id4gnRpUVbQQP+pc0CRCbsqNQVBA=
Subject: FAILED: patch "[PATCH] interconnect: fix icc_provider_del() error handling" failed to apply to 5.4-stable tree
To:     johan+linaro@kernel.org, djakov@kernel.org,
        konrad.dybcio@linaro.org, luca.ceresoli@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:19:09 +0100
Message-ID: <167930394920337@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x e0e7089bf9a87bc5e3997422e4e24563424f9018
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930394920337@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

e0e7089bf9a8 ("interconnect: fix icc_provider_del() error handling")
680f8666baf6 ("interconnect: Make icc_provider_del() return void")
1521e22bfa12 ("interconnect: Introduce xlate_extended() callback")
8a307d3601bc ("interconnect: Export of_icc_get_from_provider()")
1597d453289b ("interconnect: Add of_icc_get_by_index() helper function")
3791163602f7 ("interconnect: Handle memory allocation errors")
05309830e1f8 ("interconnect: Add a name to struct icc_path")
dd018a9cf910 ("interconnect: Move internal structs into a separate file")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e0e7089bf9a87bc5e3997422e4e24563424f9018 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 08:56:30 +0100
Subject: [PATCH] interconnect: fix icc_provider_del() error handling

The interconnect framework currently expects that providers are only
removed when there are no users and after all nodes have been removed.

There is currently nothing that guarantees this to be the case and the
framework does not do any reference counting, but refusing to remove the
provider is never correct as that would leave a dangling pointer to a
resource that is about to be released in the global provider list (e.g.
accessible through debugfs).

Replace the current sanity checks with WARN_ON() so that the provider is
always removed.

Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
Cc: stable@vger.kernel.org      # 5.1: 680f8666baf6: interconnect: Make icc_provider_del() return void
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # i.MX8MP MSC SM2-MB-EP1 Board
Link: https://lore.kernel.org/r/20230306075651.2449-3-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 5217f449eeec..cabb6f5df83e 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1065,18 +1065,8 @@ EXPORT_SYMBOL_GPL(icc_provider_add);
 void icc_provider_del(struct icc_provider *provider)
 {
 	mutex_lock(&icc_lock);
-	if (provider->users) {
-		pr_warn("interconnect provider still has %d users\n",
-			provider->users);
-		mutex_unlock(&icc_lock);
-		return;
-	}
-
-	if (!list_empty(&provider->nodes)) {
-		pr_warn("interconnect provider still has nodes\n");
-		mutex_unlock(&icc_lock);
-		return;
-	}
+	WARN_ON(provider->users);
+	WARN_ON(!list_empty(&provider->nodes));
 
 	list_del(&provider->provider_list);
 	mutex_unlock(&icc_lock);

