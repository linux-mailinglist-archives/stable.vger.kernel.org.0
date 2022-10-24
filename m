Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFEB60AD3D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiJXOUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbiJXOTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:19:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62FF94116;
        Mon, 24 Oct 2022 05:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED84612B2;
        Mon, 24 Oct 2022 12:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32432C433C1;
        Mon, 24 Oct 2022 12:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615345;
        bh=+6nKuQUQQhp/DPGhaTRSC6cZh6rw96mQOZjAlDCFnuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/61IlxmHw4zshUIAwtM29OHglqaxv+DBFY+itEI2CVgW1dVjCCJ+o/7c+Onlvtiv
         O68x6F2h9j5Pz61v0nkx/eyIMgjM+K6tt/nq/11HqD5iO1nYGH5WbbGSMsO40TDeHI
         8kTRHTttSXRSdYVuSiaUd0uU3PpXk4P1X2kVygnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/530] drm:pl111: Add of_node_put() when breaking out of for_each_available_child_of_node()
Date:   Mon, 24 Oct 2022 13:29:19 +0200
Message-Id: <20221024113054.814419464@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit e0686dc6f2252e009c455fe99e2ce9d62a60eb47 ]

The reference 'child' in the iteration of for_each_available_child_of_node()
is only escaped out into a local variable which is only used to check
its value. So we still need to the of_node_put() when breaking of the
for_each_available_child_of_node() which will automatically increase
and decrease the refcount.

Fixes: ca454bd42dc2 ("drm/pl111: Support the Versatile Express")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220711131550.361350-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/pl111/pl111_versatile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/pl111/pl111_versatile.c b/drivers/gpu/drm/pl111/pl111_versatile.c
index bdd883f4f0da..963a5d5e6987 100644
--- a/drivers/gpu/drm/pl111/pl111_versatile.c
+++ b/drivers/gpu/drm/pl111/pl111_versatile.c
@@ -402,6 +402,7 @@ static int pl111_vexpress_clcd_init(struct device *dev, struct device_node *np,
 		if (of_device_is_compatible(child, "arm,pl111")) {
 			has_coretile_clcd = true;
 			ct_clcd = child;
+			of_node_put(child);
 			break;
 		}
 		if (of_device_is_compatible(child, "arm,hdlcd")) {
-- 
2.35.1



