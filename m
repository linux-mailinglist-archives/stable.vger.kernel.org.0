Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CD3ACDB3
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbfIHMwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733079AbfIHMwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:32 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06772082C;
        Sun,  8 Sep 2019 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947152;
        bh=kVhIA2VRlTtUs/TO0Zv+rRP6M6nsaEFIOYgZBjeOGxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSeFCyHMxJeSXUPb8xEqB5Qr+d7CNLfcNetaTpj2znDYUsfWbkFmGwThU1huLYnyJ
         w0QkIy5Jj1bCncSrU7CFmb+wqtZYuHd5hEtEsPZapAbjoBSxix/gOl3+AvMDTpn5XX
         OXhONOqxBiAEenti3fHrrLvwfns3AjI6XxevZulM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 54/94] clk: Fix potential NULL dereference in clk_fetch_parent_index()
Date:   Sun,  8 Sep 2019 13:41:50 +0100
Message-Id: <20190908121151.983360317@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 24876f09a7dfe36a82f53d304d8c1bceb3257a0f ]

Don't compare the parent clock name with a NULL name in the
clk_parent_map. This prevents a kernel crash when passing NULL
core->parents[i].name to strcmp().

An example which triggered this is a mux clock with four parents when
each of them is referenced in the clock driver using
clk_parent_data.fw_name and then calling clk_set_parent(clk, 3rd_parent)
on this mux.
In this case the first parent is also the HW default so
core->parents[i].hw is populated when the clock is registered. Calling
clk_set_parent(clk, 3rd_parent) will then go through all parents and
skip the first parent because it's hw pointer doesn't match. For the
second parent no hw pointer is cached yet and clk_core_get(core, 1)
returns a non-matching pointer (which is correct because we are comparing
the second with the third parent). Comparing the result of
clk_core_get(core, 2) with the requested parent gives a match. However
we don't reach this point because right after the clk_core_get(core, 1)
mismatch the old code tried to !strcmp(parent->name, NULL) (where the
second argument is actually core->parents[i].name, but that was never
populated by the clock driver).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lkml.kernel.org/r/20190815223155.21384-1-martin.blumenstingl@googlemail.com
Fixes: fc0c209c147f ("clk: Allow parents to be specified without string names")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 498cd7bbe8984..3a4961dc58313 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1657,7 +1657,8 @@ static int clk_fetch_parent_index(struct clk_core *core,
 			break;
 
 		/* Fallback to comparing globally unique names */
-		if (!strcmp(parent->name, core->parents[i].name))
+		if (core->parents[i].name &&
+		    !strcmp(parent->name, core->parents[i].name))
 			break;
 	}
 
-- 
2.20.1



