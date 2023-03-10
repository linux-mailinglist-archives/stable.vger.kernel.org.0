Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0916B464D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjCJOlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjCJOlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:41:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5449611F62D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:41:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04E66B822DD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51682C4339C;
        Fri, 10 Mar 2023 14:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459302;
        bh=jd39PS82pDz6Wt8ImWUHrr2bVMTeUg0SRYtS1eWzK4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MNZI5krj3FTdmErmYQ3iMkwcWoYCB0+U8BeFtx1Nmf21kzJcgWqDXKFnwJI1BXpX
         K8elsYnbB8BfTI5Rp99PDcp68jw3dCVenWbYvnc/pF92jDx3IDoINbahQUxIY8X5sv
         7FaeGgPA8NUsJtIKwzMIwNJXSrgG7pE75qtfgW+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        Simon Horman <simon.horman@corigine.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 315/357] 9p/xen: fix version parsing
Date:   Fri, 10 Mar 2023 14:40:04 +0100
Message-Id: <20230310133748.592145876@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit f1956f4ec15195ec60976d9b5625326285ab102e ]

When connecting the Xen 9pfs frontend to the backend, the "versions"
Xenstore entry written by the backend is parsed in a wrong way.

The "versions" entry is defined to contain the versions supported by
the backend separated by commas (e.g. "1,2"). Today only version "1"
is defined. Unfortunately the frontend doesn't look for "1" being
listed in the entry, but it is expecting the entry to have the value
"1".

This will result in failure as soon as the backend will support e.g.
versions "1" and "2".

Fix that by scanning the entry correctly.

Link: https://lkml.kernel.org/r/20230130113036.7087-2-jgross@suse.com
Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index f043938ae782d..131757aa0e6e2 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -395,13 +395,19 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 	int ret, i;
 	struct xenbus_transaction xbt;
 	struct xen_9pfs_front_priv *priv = NULL;
-	char *versions;
+	char *versions, *v;
 	unsigned int max_rings, max_ring_order, len = 0;
 
 	versions = xenbus_read(XBT_NIL, dev->otherend, "versions", &len);
 	if (IS_ERR(versions))
 		return PTR_ERR(versions);
-	if (strcmp(versions, "1")) {
+	for (v = versions; *v; v++) {
+		if (simple_strtoul(v, &v, 10) == 1) {
+			v = NULL;
+			break;
+		}
+	}
+	if (v) {
 		kfree(versions);
 		return -EINVAL;
 	}
-- 
2.39.2



