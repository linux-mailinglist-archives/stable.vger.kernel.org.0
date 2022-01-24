Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C249923B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345194AbiAXUS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:18:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53858 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355652AbiAXUO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:14:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7A2EB8124F;
        Mon, 24 Jan 2022 20:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD89C340E5;
        Mon, 24 Jan 2022 20:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055264;
        bh=eSFAMSNBJ2+1DUCDbG0cVf4bszUJGYhA/TtF+L2iozU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddtTIOpeRFOX1VNXQcSd1ht1Fg1sKDohlteT0ZXjdKMIxucg8/2zzlcXQWnkSIuS/
         T34qVakn/ZUdmNb9X8gYiwv+N61h/bv0jTptjv4lCmkMuNNASs3lvaeWGITdCv1z5Z
         pvx9SZfkFPU6ezFRpB1EReLXcLPhMJZ9+KXMc4xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/846] drm/bridge: display-connector: fix an uninitialized pointer in probe()
Date:   Mon, 24 Jan 2022 19:33:14 +0100
Message-Id: <20220124184103.649101971@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 189723fbe9aca18d6f7d638c59a40288030932b5 ]

The "label" pointer is used for debug output.  The code assumes that it
is either NULL or valid, but it is never set to NULL.  It is either
valid or uninitialized.

Fixes: 0c275c30176b ("drm/bridge: Add bridge driver for display connectors")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013080825.GE6010@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/display-connector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/display-connector.c b/drivers/gpu/drm/bridge/display-connector.c
index 05eb759da6fc6..847a0dce7f1d3 100644
--- a/drivers/gpu/drm/bridge/display-connector.c
+++ b/drivers/gpu/drm/bridge/display-connector.c
@@ -107,7 +107,7 @@ static int display_connector_probe(struct platform_device *pdev)
 {
 	struct display_connector *conn;
 	unsigned int type;
-	const char *label;
+	const char *label = NULL;
 	int ret;
 
 	conn = devm_kzalloc(&pdev->dev, sizeof(*conn), GFP_KERNEL);
-- 
2.34.1



