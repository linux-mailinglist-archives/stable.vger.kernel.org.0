Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B3A4F2D70
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347152AbiDEKtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343696AbiDEJlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC82BD2F5;
        Tue,  5 Apr 2022 02:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3167AB81CB1;
        Tue,  5 Apr 2022 09:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85103C385B1;
        Tue,  5 Apr 2022 09:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150838;
        bh=Qu8MHTsIc7m023b0AUDv6WD8HQbm7Xu0XOgmCZuC4Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuNqEP+8tFDnlwFSTmLgV86sNij+DWgzN4QPgiLiUUF1Hdb986hnnkfJMyN8bEFH7
         +DmcqBLJxqWGx2J0UkmmDv6+SFDuvK/qQsaJagZBc9GyLAYm0ttnLqz3c1ec6uMdm/
         wVk5P4cJiLS79fYmfJjyFXDd0qX3EE6xraKFft3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/913] thermal: int340x: Check for NULL after calling kmemdup()
Date:   Tue,  5 Apr 2022 09:21:01 +0200
Message-Id: <20220405070345.823703273@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 38b16d6cfe54c820848bcfc999bc5e8a7da1cefb ]

As the potential failure of the allocation, kmemdup() may return NULL.

Then, 'bin_attr_data_vault.private' will be NULL, but
'bin_attr_data_vault.size' is not 0, which is not consistent.

Therefore, it is better to check the return value of kmemdup() to
avoid the confusion.

Fixes: 0ba13c763aac ("thermal/int340x_thermal: Export GDDV")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 176b8e5d2124..258f56eba859 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -469,6 +469,11 @@ static void int3400_setup_gddv(struct int3400_thermal_priv *priv)
 	priv->data_vault = kmemdup(obj->package.elements[0].buffer.pointer,
 				   obj->package.elements[0].buffer.length,
 				   GFP_KERNEL);
+	if (!priv->data_vault) {
+		kfree(buffer.pointer);
+		return;
+	}
+
 	bin_attr_data_vault.private = priv->data_vault;
 	bin_attr_data_vault.size = obj->package.elements[0].buffer.length;
 	kfree(buffer.pointer);
-- 
2.34.1



