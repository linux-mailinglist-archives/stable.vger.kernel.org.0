Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F1860B2B2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbiJXQup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiJXQtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:49:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A9E31375;
        Mon, 24 Oct 2022 08:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F4FBB819FA;
        Mon, 24 Oct 2022 12:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFD9C433C1;
        Mon, 24 Oct 2022 12:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616064;
        bh=0kXO5B/LPn7NgpyXDfDUUEpfUw3v67CHR3ou4Xlqh1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxdChtMUcRV7ID89TASDvLm830RrB4eZDJTkafBkoS154cSICtgWKiSJKOPa+sBsB
         dEBq/wvqugLZBAiqWhux28yG8Vy6cEb6cXdtizX7VoFu3Z4rgrkixX8sa5wG2KIE6C
         2x+UnP9EYoIzBdKDojKAsR4DK3x0YB74+VWZq65s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philipp Hortmann <philipp.g.hortmann@gmail.com>,
        Nam Cao <namcaov@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/530] staging: vt6655: fix potential memory leak
Date:   Mon, 24 Oct 2022 13:33:51 +0200
Message-Id: <20221024113107.098703320@linuxfoundation.org>
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

From: Nam Cao <namcaov@gmail.com>

[ Upstream commit c8ff91535880d41b49699b3829fb6151942de29e ]

In function device_init_td0_ring, memory is allocated for member
td_info of priv->apTD0Rings[i], with i increasing from 0. In case of
allocation failure, the memory is freed in reversed order, with i
decreasing to 0. However, the case i=0 is left out and thus memory is
leaked.

Modify the memory freeing loop to include the case i=0.

Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
Signed-off-by: Nam Cao <namcaov@gmail.com>
Link: https://lore.kernel.org/r/20220909141338.19343-1-namcaov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 43e32360b6d9..775537b243aa 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -676,7 +676,7 @@ static int device_init_td0_ring(struct vnt_private *priv)
 	return 0;
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->apTD0Rings[i];
 		kfree(desc->td_info);
 	}
-- 
2.35.1



