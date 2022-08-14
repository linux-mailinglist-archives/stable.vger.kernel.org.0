Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748DC5924CE
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242407AbiHNQg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242663AbiHNQe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:34:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF71193DB;
        Sun, 14 Aug 2022 09:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 116CCB80B7E;
        Sun, 14 Aug 2022 16:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17748C433D7;
        Sun, 14 Aug 2022 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494464;
        bh=oM5whZQr7EaKEurMMTtZ3SRlY7dX/wbzjkApNsQPbeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJ55Ll82dtWIjGcU+MAOWRxZFSAxG5DOYvIFaqs4kHIE+tma2HgPWj+m6/NfOMnIF
         cwYHQBjybiDzZ6KVf+hVn8wsnKhH+bMSF1PFEzJhwoR5V9MojWcZ4LFaP1jQ4F86w4
         2x5NOkhN6+KUm7hpK3xMVZimpbJeX6ExEcao0FDp765XHxk4UR8EXJQtwvmNiXmie8
         H5LT8DsXcT1pCt6ADHPPpMVxJPuxWu/c97a+g0VLmNqBH7BofCwj+Zo1D61csl12K+
         JpbWkfEDwKNgbwQktubC1t/uq68n5oNKsRscrr2DDRdDMLsPCG/cSQghzBAjx6/Ybn
         ev6uf0BSsGxEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Schspa Shi <schspa@gmail.com>, Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/19] vfio: Clear the caps->buf to NULL after free
Date:   Sun, 14 Aug 2022 12:27:22 -0400
Message-Id: <20220814162739.2398217-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162739.2398217-1-sashal@kernel.org>
References: <20220814162739.2398217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit 6641085e8d7b3f061911517f79a2a15a0a21b97b ]

On buffer resize failure, vfio_info_cap_add() will free the buffer,
report zero for the size, and return -ENOMEM.  As additional
hardening, also clear the buffer pointer to prevent any chance of a
double free.

Signed-off-by: Schspa Shi <schspa@gmail.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20220629022948.55608-1-schspa@gmail.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2151bc7f87ab..7f60aedc3769 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1823,6 +1823,7 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
 	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
 	if (!buf) {
 		kfree(caps->buf);
+		caps->buf = NULL;
 		caps->size = 0;
 		return ERR_PTR(-ENOMEM);
 	}
-- 
2.35.1

