Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C204F2D44
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbiDEJKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244433AbiDEIwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A832AD5E9A;
        Tue,  5 Apr 2022 01:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBA1FB81C15;
        Tue,  5 Apr 2022 08:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF6CC385A1;
        Tue,  5 Apr 2022 08:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148033;
        bh=mosdTcOT6RSLCeVL6avH9J0yKmMDzV2xBu0IjWr+Kk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uah0iEzbLFDgQNs8NFbmWv0SmQOEdCqkhbKO5ZRMWQESkhlKxjX4dVCUm1dcHgyvP
         94hF0okC9sYqHy6ho9r7zhC01a8tOPqRrq05vzEyr7rCUcrlmA26iL+PLqq+d3mGWa
         nkA5tqNGs3AKRPHxz55YMLWlprNIpREu6a2uD0eY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0210/1017] thermal: int340x: Check for NULL after calling kmemdup()
Date:   Tue,  5 Apr 2022 09:18:43 +0200
Message-Id: <20220405070400.484742119@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 68f61a738930..7ec2d6c7fe42 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -468,6 +468,11 @@ static void int3400_setup_gddv(struct int3400_thermal_priv *priv)
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



