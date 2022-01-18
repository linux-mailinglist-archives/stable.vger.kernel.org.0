Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D8D491DCC
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347334AbiARDm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353564AbiARDCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:02:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D69C034008;
        Mon, 17 Jan 2022 18:47:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF59FB81195;
        Tue, 18 Jan 2022 02:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D259BC36AF3;
        Tue, 18 Jan 2022 02:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474049;
        bh=5AK/ZD+OO4TiPDAZvOFjQFvLrOlNWLTVM/ikSQ8BP24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cj/Oc2aRnWFdDHwtZqUugPQEaaMTURJhQlQpRXq5gtZ8OB+picKCbP95YSXMM6YFF
         PuECV/Ps3uJ0KkotV8uv/H11BsqtDqq9O/3N+16CGtr2ujjcEfKveJFH7YK50zHSgF
         vdbKmdbOdPTsXml3cVXDFs2UcT6GrJ36dgv14A/cvoGLmv0HfCMA5VmOqwEEHcBb5s
         X5WAabigmgxJEEklD0dPpgB0iPP8rf+1NUonQImBHb4OG9tJUc42Jv1DcTEDg/3Dza
         fPm0bRUhMQEI35N0h8zUQ1HfTyZVoaf6jqHfsOCuLokoLtCaI7x83PM/yJda3Il+gU
         6NYzgTBwnbBgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org
Subject: [PATCH AUTOSEL 4.19 12/59] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 17 Jan 2022 21:46:13 -0500
Message-Id: <20220118024701.1952911-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
 drivers/hsi/hsi_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/hsi_core.c b/drivers/hsi/hsi_core.c
index 71895da63810b..daf2de837a30a 100644
--- a/drivers/hsi/hsi_core.c
+++ b/drivers/hsi/hsi_core.c
@@ -115,6 +115,7 @@ struct hsi_client *hsi_new_client(struct hsi_port *port,
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", info->name);
 		put_device(&cl->device);
+		goto err;
 	}
 
 	return cl;
-- 
2.34.1

