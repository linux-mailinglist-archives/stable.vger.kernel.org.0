Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D8A1E2B6D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391450AbgEZTFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390801AbgEZTFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA4B020849;
        Tue, 26 May 2020 19:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519900;
        bh=0kG7rzBhywYYe9vAfuxYEHFHGEYOAtH8A3jXzEB/jls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jvuEjPKcYkWoflCiaaUx54ZxfLKDof0eYPr5mhuEWu9FJdqE41TrcODB9cNlDb4k
         zDA7OQ9nB3ntJbyY0pgZ4qyblEfajS/WGz4O4ULeKFnOSeF/ys4f2JqiezeFZsbWjM
         RBcNfpQOXipXEXV6U7ufm9v/5YSNNRYajt0pekHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/81] staging: most: core: replace strcpy() by strscpy()
Date:   Tue, 26 May 2020 20:53:29 +0200
Message-Id: <20200526183933.091481328@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

[ Upstream commit 3970d0d81816310175b6272e709ee09dd3e05171 ]

The strcpy() function is being deprecated. Replace it by the safer
strscpy() and fix the following Coverity warning:

"You might overrun the 80-character fixed-size string iface->p->name
by copying iface->description without checking the length."

Addresses-Coverity-ID: 1444760 ("Copy into fixed size buffer")
Fixes: 131ac62253db ("staging: most: core: use device description as name")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/most/core.c b/drivers/staging/most/core.c
index 25a077f4ea94..08f60ce6293d 100644
--- a/drivers/staging/most/core.c
+++ b/drivers/staging/most/core.c
@@ -1412,7 +1412,7 @@ int most_register_interface(struct most_interface *iface)
 
 	INIT_LIST_HEAD(&iface->p->channel_list);
 	iface->p->dev_id = id;
-	strcpy(iface->p->name, iface->description);
+	strscpy(iface->p->name, iface->description, sizeof(iface->p->name));
 	iface->dev.init_name = iface->p->name;
 	iface->dev.bus = &mc.bus;
 	iface->dev.parent = &mc.dev;
-- 
2.25.1



