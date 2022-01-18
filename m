Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8C4491D60
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346426AbiARDfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376561AbiARDch (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:32:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36E5C014F2D;
        Mon, 17 Jan 2022 19:08:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D93860439;
        Tue, 18 Jan 2022 03:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5042C36AEF;
        Tue, 18 Jan 2022 03:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475324;
        bh=ltfBF/t0KEK7VJPJMB0V8iusdFPJKGVQeC+PLK7eJGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CocaQCQ7e3eTEwsrmiZaP+Z3Ylk24V6z3HbsD9tayEHprntGYMgbfWiP5taOUvTaz
         rMYocf+03dkfJu91B7GylD/VVJFiw51wBK+Qs+Fs9LzbgSVadMvr/Rgl/T93hVnG1W
         okWGzKkjjk0eGX9wcQabIAIbOj+t7v4CKLGCpfDwiMfjzVtBQmshoVPeY3L0m9IiU/
         Kmv6ljlMkLkOzGIf8yekY/7eHdZ+lH82SKjLs7TNWczJE2vszWf6umvtSNyo63cBhF
         caDk7FLbDrxgcTRwGFG3/D9krvTFm7xG2uWZn2i7/C1X9RKRasxeSLiK2XbFtGceQB
         MB4cbQrAnVuyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org
Subject: [PATCH AUTOSEL 4.4 07/29] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 17 Jan 2022 22:08:00 -0500
Message-Id: <20220118030822.1955469-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit a1ee1c08fcd5af03187dcd41dcab12fd5b379555 ]

cl is freed on error of calling device_register, but this
object is return later, which will cause uaf issue. Fix it
by return NULL on error.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/hsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 55e36fcd7ff35..e1080f005a19e 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -115,6 +115,7 @@ struct hsi_client *hsi_new_client(struct hsi_port *port,
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", info->name);
 		put_device(&cl->device);
+		goto err;
 	}
 
 	return cl;
-- 
2.34.1

