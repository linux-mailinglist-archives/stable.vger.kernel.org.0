Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20004EC1E8
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344948AbiC3L5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345787AbiC3LzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B740263647;
        Wed, 30 Mar 2022 04:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7BA4615F5;
        Wed, 30 Mar 2022 11:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FC4C340EE;
        Wed, 30 Mar 2022 11:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641094;
        bh=qW1x31HnZxqlWv9yLK7leVGiHSRFHxjgpFRqN+3ePM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/Hn/9Y+fIQAHKalGj2yAhLJ8q5I0HlAvDQ+YsjFXDDNkvOczSmtVB6/XuaZCMjQM
         vmEIhEIUyLeX1Ikp4EqQ1/ud58KTZnVoLVKIYsWdI+7BHnu4rXxCBLGb9V0hlwo8NZ
         anI46FBwymrwOVYyoa7tZkFrrnM9o6GGpyMxb5MQbQqxJ3QGTeYrHO5uuvDbUaMrLZ
         8BEJZc6HngJFyFswSU2eaMtPdWkfU2WfY1JnMtdo067RfrLeUqDuyVbttK5n+P0bXi
         6gb4BQ8Z7bOd6g3Tt7RW7CrnAulcV/7I/nbFjWF1JaBs48Fza+EMaknP4heoTCGilV
         5wxWky9Vpp4jQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Gardner <tim.gardner@canonical.com>,
        Antonino Daplas <adaplas@gmail.com>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        tomi.valkeinen@ti.com
Subject: [PATCH AUTOSEL 5.10 06/37] video: fbdev: nvidiafb: Use strscpy() to prevent buffer overflow
Date:   Wed, 30 Mar 2022 07:50:51 -0400
Message-Id: <20220330115122.1671763-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Tim Gardner <tim.gardner@canonical.com>

[ Upstream commit 37a1a2e6eeeb101285cd34e12e48a881524701aa ]

Coverity complains of a possible buffer overflow. However,
given the 'static' scope of nvidia_setup_i2c_bus() it looks
like that can't happen after examiniing the call sites.

CID 19036 (#1 of 1): Copy into fixed size buffer (STRING_OVERFLOW)
1. fixed_size_dest: You might overrun the 48-character fixed-size string
  chan->adapter.name by copying name without checking the length.
2. parameter_as_source: Note: This defect has an elevated risk because the
  source argument is a parameter of the current function.
 89        strcpy(chan->adapter.name, name);

Fix this warning by using strscpy() which will silence the warning and
prevent any future buffer overflows should the names used to identify the
channel become much longer.

Cc: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nv_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/nvidia/nv_i2c.c b/drivers/video/fbdev/nvidia/nv_i2c.c
index d7994a173245..0b48965a6420 100644
--- a/drivers/video/fbdev/nvidia/nv_i2c.c
+++ b/drivers/video/fbdev/nvidia/nv_i2c.c
@@ -86,7 +86,7 @@ static int nvidia_setup_i2c_bus(struct nvidia_i2c_chan *chan, const char *name,
 {
 	int rc;
 
-	strcpy(chan->adapter.name, name);
+	strscpy(chan->adapter.name, name, sizeof(chan->adapter.name));
 	chan->adapter.owner = THIS_MODULE;
 	chan->adapter.class = i2c_class;
 	chan->adapter.algo_data = &chan->algo;
-- 
2.34.1

