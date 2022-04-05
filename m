Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653B94F3717
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347432AbiDELJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348812AbiDEJsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9AC95A36;
        Tue,  5 Apr 2022 02:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48419615E5;
        Tue,  5 Apr 2022 09:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F77DC385A0;
        Tue,  5 Apr 2022 09:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151357;
        bh=hE0+M1yHyMNF+b58TMcf0wEYVHccPRvtpndBkcpj1nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hi0uxZeq+nukjseWr2Ug73wXu/b72jncipxVpywC2ormglUG9kWBsYpP50Aizz5RT
         6NBVusC0vn0giAyFXDQaoMzTdLi/RXER4TjsJwfYv5Y+CRVTYjG/oLH0yFKnn/GalT
         DNgnddgpIAIGKoRkRbvu5do64gmwwDclS7/Eclos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+2c56b725ec547fa9cb29@syzkaller.appspotmail.com
Subject: [PATCH 5.15 387/913] udmabuf: validate ubuf->pagecount
Date:   Tue,  5 Apr 2022 09:24:09 +0200
Message-Id: <20220405070351.447460224@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 2b6dd600dd72573c23ea180b5b0b2f1813405882 ]

Syzbot has reported GPF in sg_alloc_append_table_from_pages(). The
problem was in ubuf->pages == ZERO_PTR.

ubuf->pagecount is calculated from arguments passed from user-space. If
user creates udmabuf with list.size == 0 then ubuf->pagecount will be
also equal to zero; it causes kmalloc_array() to return ZERO_PTR.

Fix it by validating ubuf->pagecount before passing it to
kmalloc_array().

Fixes: fbb0de795078 ("Add udmabuf misc device")
Reported-and-tested-by: syzbot+2c56b725ec547fa9cb29@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20211230142649.23022-1-paskripkin@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index c57a609db75b..e7330684d3b8 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -190,6 +190,10 @@ static long udmabuf_create(struct miscdevice *device,
 		if (ubuf->pagecount > pglimit)
 			goto err;
 	}
+
+	if (!ubuf->pagecount)
+		goto err;
+
 	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(*ubuf->pages),
 				    GFP_KERNEL);
 	if (!ubuf->pages) {
-- 
2.34.1



