Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E071E6AEB02
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjCGRjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjCGRiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241759B9B0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CFBBCE1B30
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79039C433EF;
        Tue,  7 Mar 2023 17:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210504;
        bh=3HTfAfun+urXFEuCvdtSvGr5dV7XxHyOnkWjNHaYtzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qssg54OVBB3+bO3zl3N4pqKZaxL2780gG6gOZYGdstS6yfDe26k249WjDHn6pOxZN
         C/E1KCjzkNEhfqtY2YzCHA54WC6dWZXMOEFIhDhn0E0TX5jPH00rvh+TmQVn94x0ve
         JV8+CBWYlhB+nkFad++eh0wETK3RD8RtLG+k97qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0522/1001] misc: fastrpc: Fix an error handling path in fastrpc_rpmsg_probe()
Date:   Tue,  7 Mar 2023 17:54:54 +0100
Message-Id: <20230307170044.096085582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 11819ed2b70da94acc41fec34178a011c4d3d25d ]

If of_platform_populate() fails, some resources need to be freed as already
done in the other error handling paths.

Fixes: 278d56f970ae ("misc: fastrpc: Reference count channel context")
Fixes: 3abe3ab3cdab ("misc: fastrpc: add secure domain support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/b909d2f3273b794ea0f1f78d14bc24affb08ea5f.1669398274.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 5310606113fe5..7ccaca1b7cb8b 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2315,7 +2315,18 @@ static int fastrpc_rpmsg_probe(struct rpmsg_device *rpdev)
 	data->domain_id = domain_id;
 	data->rpdev = rpdev;
 
-	return of_platform_populate(rdev->of_node, NULL, NULL, rdev);
+	err = of_platform_populate(rdev->of_node, NULL, NULL, rdev);
+	if (err)
+		goto populate_error;
+
+	return 0;
+
+populate_error:
+	if (data->fdevice)
+		misc_deregister(&data->fdevice->miscdev);
+	if (data->secure_fdevice)
+		misc_deregister(&data->secure_fdevice->miscdev);
+
 fdev_error:
 	kfree(data);
 	return err;
-- 
2.39.2



