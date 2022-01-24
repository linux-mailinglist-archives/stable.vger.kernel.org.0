Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B90C498139
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243051AbiAXNhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbiAXNhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:37:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9BEC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E5AB80F9C
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A89C340E1;
        Mon, 24 Jan 2022 13:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643031435;
        bh=QRchrMCN1FjJTP08T3bxI6zSfUiZyfs5uJavYrEVUfc=;
        h=Subject:To:Cc:From:Date:From;
        b=ZAD23lEYwVDIXXLxmKJVbXYiQWEQxs+RiXvoziHSvNG4huHtGzwNS0jnKBT2FYiK/
         hA2IZ5YdK+7l7RnccyYUwoQkTDTOF6CkWhz3YFf2qoSF+glRH1zywxoR4J2/3B61jH
         Rb6JXDr2IrV6n49pzECz+F00VKUjTWTfOvzTvX8w=
Subject: FAILED: patch "[PATCH] net: ipa: fix atomic update in ipa_endpoint_replenish()" failed to apply to 5.10-stable tree
To:     elder@linaro.org, davem@davemloft.net, mka@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:37:13 +0100
Message-ID: <164303143324018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c0e3b5ce94947b311348c367db9e11dcb2ccc93 Mon Sep 17 00:00:00 2001
From: Alex Elder <elder@linaro.org>
Date: Wed, 12 Jan 2022 07:30:10 -0600
Subject: [PATCH] net: ipa: fix atomic update in ipa_endpoint_replenish()

In ipa_endpoint_replenish(), if an error occurs when attempting to
replenish a receive buffer, we just quit and try again later.  In
that case we increment the backlog count to reflect that the attempt
was unsuccessful.  Then, if the add_one flag was true we increment
the backlog again.

This second increment is not included in the backlog local variable
though, and its value determines whether delayed work should be
scheduled.  This is a bug.

Fix this by determining whether 1 or 2 should be added to the
backlog before adding it in a atomic_add_return() call.

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 49d9a077d037..8b055885cf3c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1080,6 +1080,7 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 {
 	struct gsi *gsi;
 	u32 backlog;
+	int delta;
 
 	if (!endpoint->replenish_enabled) {
 		if (add_one)
@@ -1097,10 +1098,8 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 
 try_again_later:
 	/* The last one didn't succeed, so fix the backlog */
-	backlog = atomic_inc_return(&endpoint->replenish_backlog);
-
-	if (add_one)
-		atomic_inc(&endpoint->replenish_backlog);
+	delta = add_one ? 2 : 1;
+	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
 
 	/* Whenever a receive buffer transaction completes we'll try to
 	 * replenish again.  It's unlikely, but if we fail to supply even

