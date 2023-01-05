Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432EC65EB9A
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjAENAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjAENAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAB91CB02
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C65D61A10
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE25C433EF;
        Thu,  5 Jan 2023 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923618;
        bh=cncMIODGkBX/IuezY8Zev5w2WbkYL6NMs3r2C+eN168=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fomv+P/mYSE/975idTOEgpYIeCfDverWljwRbc8W2iC92txNUdpNX0KPSBjsTgkX+
         jliNcwdpsF85UkDrHgOKAzu19tzLtar+0VzQdGXqXcVjheIh0pKmx/1g0PCQybJhx4
         WAvFijwQg8B/npaj7TEFrkWTrYDPVJqvV7XdxGl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 078/251] regulator: core: fix module refcount leak in set_supply()
Date:   Thu,  5 Jan 2023 13:53:35 +0100
Message-Id: <20230105125338.353840975@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit da46ee19cbd8344d6860816b4827a7ce95764867 ]

If create_regulator() fails in set_supply(), the module refcount
needs be put to keep refcount balanced.

Fixes: e2c09ae7a74d ("regulator: core: Increase refcount for regulator supply's module")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221201122706.4055992-2-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e1f934fec562..cbc3397258f6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1157,6 +1157,7 @@ static int set_supply(struct regulator_dev *rdev,
 
 	rdev->supply = create_regulator(supply_rdev, &rdev->dev, "SUPPLY");
 	if (rdev->supply == NULL) {
+		module_put(supply_rdev->owner);
 		err = -ENOMEM;
 		return err;
 	}
-- 
2.35.1



