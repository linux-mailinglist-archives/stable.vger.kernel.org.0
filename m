Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8788E147F36
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbgAXLAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733234AbgAXLAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:00:32 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B8732075D;
        Fri, 24 Jan 2020 11:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863631;
        bh=Nn4xNqbd1F1HyJdVecORxYUIPoXruY18BweCdCHykoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5gCD0y2e2So1PPAlNgF+uWftZrbn4sV4vGmxsgpUlKTh48lUsdT2+NarmP38n0B1
         B5b7bl5YtrzUz23YjXc118UpCoY6cpwDJA0B5R55lsBH1tHtRnUX1TZ7rx6TItIGZu
         BFLjsVaJWZ/59Un9OAOBG/vFM+t79IsOt6Q2Jwko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/639] of: Fix property name in of_node_get_device_type
Date:   Fri, 24 Jan 2020 10:23:35 +0100
Message-Id: <20200124093053.072444667@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 5d5a0ab1a7918fce5ca5c0fb1871a3e2000f85de ]

Commit 0413bedabc88 ("of: Add device_type access helper functions")
added a new helper not yet used in preparation for some treewide clean
up of accesses to 'device_type' properties. Unfortunately, there's an
error and 'type' was used for the property name. Fix this.

Fixes: 0413bedabc88 ("of: Add device_type access helper functions")
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index d5a863c1ee390..dac0201eacef7 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1001,7 +1001,7 @@ static inline struct device_node *of_find_matching_node(
 
 static inline const char *of_node_get_device_type(const struct device_node *np)
 {
-	return of_get_property(np, "type", NULL);
+	return of_get_property(np, "device_type", NULL);
 }
 
 static inline bool of_node_is_type(const struct device_node *np, const char *type)
-- 
2.20.1



