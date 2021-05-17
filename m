Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC69A38367E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244949AbhEQPdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343583AbhEQPbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:31:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBA7E613F4;
        Mon, 17 May 2021 14:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262291;
        bh=fngY5Z8pt3dkBwALJzRZGtAqNPMwfFVcNbPbxtMCDN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybLBR8bdoxLjAmXfC2OKExo6h3MbOZgM1ihlUy+tcn/f0IBGE0H0nHw4dttl9WTEz
         YXaC9A45GIG4NmwpMlP5x8Dn4Ci8cOCCq4sv95TMDg7JrfqCLTpew6YcymsJI+BMcW
         06tvNQA22cywYm/D/H3WWqyffS0E+oMHbfJjEqYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 258/329] xen/unpopulated-alloc: fix error return code in fill_list()
Date:   Mon, 17 May 2021 16:02:49 +0200
Message-Id: <20210517140310.835517390@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit dbc03e81586fc33e4945263fd6e09e22eb4b980f ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: a4574f63edc6 ("mm/memremap_pages: convert to 'struct range'")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20210508021913.1727-1-thunder.leizhen@huawei.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/unpopulated-alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/unpopulated-alloc.c b/drivers/xen/unpopulated-alloc.c
index e64e6befc63b..87e6b7db892f 100644
--- a/drivers/xen/unpopulated-alloc.c
+++ b/drivers/xen/unpopulated-alloc.c
@@ -39,8 +39,10 @@ static int fill_list(unsigned int nr_pages)
 	}
 
 	pgmap = kzalloc(sizeof(*pgmap), GFP_KERNEL);
-	if (!pgmap)
+	if (!pgmap) {
+		ret = -ENOMEM;
 		goto err_pgmap;
+	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
 	pgmap->range = (struct range) {
-- 
2.30.2



