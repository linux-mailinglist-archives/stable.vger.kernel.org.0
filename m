Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A32953A80F
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354205AbiFAOHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354523AbiFAOEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6098ABF40;
        Wed,  1 Jun 2022 06:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 836E4B81B00;
        Wed,  1 Jun 2022 13:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7E8C34119;
        Wed,  1 Jun 2022 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091928;
        bh=y5FpsC0QGeen2RQowSl2Y0D8H3xk4G0Akqg3acr5AMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfqk/r2MYf3LpTWe7zFJN3VotySzeBu9qJyggoIuwADcN5NbSjETAUOocYOOKl3Ju
         49E6HKrW+jq7nqFrSVUVNQoYJdqBqBjc39ReoHkWkuxKxGKCIs5GIvlklpVeNg6OzH
         IW6JtQtHU2v5cZdmpLUomrEgoprVPiK3ANraxnDH0qsv1exk4BPmBkOaXxhx2EW7p9
         PjUHHKNaX9CicseCYFFtE91/FD0UrJbvIZxZCE7Kr1Uk/mh9+d2kMtHrCupMC/cvSP
         iKMtMi/L8BGeXd+Q/xfG3WCsvafSFFPzRwKI/W14ZFkL3ZJkP/19j9iq6POYTkiyv+
         5t5vaNGfPZ70g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 22/26] powerpc/powernv: fix missing of_node_put in uv_init()
Date:   Wed,  1 Jun 2022 09:57:55 -0400
Message-Id: <20220601135759.2004435-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135759.2004435-1-sashal@kernel.org>
References: <20220601135759.2004435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 3ffa9fd471f57f365bc54fc87824c530422f64a5 ]

of_find_compatible_node() returns node pointer with refcount incremented,
use of_node_put() on it when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220407090043.2491854-1-lv.ruyi@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/ultravisor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powernv/ultravisor.c b/arch/powerpc/platforms/powernv/ultravisor.c
index e4a00ad06f9d..67c8c4b2d8b1 100644
--- a/arch/powerpc/platforms/powernv/ultravisor.c
+++ b/arch/powerpc/platforms/powernv/ultravisor.c
@@ -55,6 +55,7 @@ static int __init uv_init(void)
 		return -ENODEV;
 
 	uv_memcons = memcons_init(node, "memcons");
+	of_node_put(node);
 	if (!uv_memcons)
 		return -ENOENT;
 
-- 
2.35.1

