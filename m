Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFCE4F26C5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiDEIEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbiDEIAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:00:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7850F49243;
        Tue,  5 Apr 2022 00:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34634B81B16;
        Tue,  5 Apr 2022 07:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13B9C340EE;
        Tue,  5 Apr 2022 07:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145529;
        bh=hE0+M1yHyMNF+b58TMcf0wEYVHccPRvtpndBkcpj1nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cg5wWAfcUUXd8L9OpKNK2ccxc7S9haPIiUwXqjjqcZwJr6KzqqoP1TIZhjrkBPfam
         bgTLRJb86QdPfhu9dCB3rJDgu3dGLlDLp9Dvc3Yx7f2RKJtnI8RxSQtLYZKW7+oaxr
         z0/6c8DJE7Kwu8nveUjinFimSacGboz/UwACTXEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+2c56b725ec547fa9cb29@syzkaller.appspotmail.com
Subject: [PATCH 5.17 0439/1126] udmabuf: validate ubuf->pagecount
Date:   Tue,  5 Apr 2022 09:19:46 +0200
Message-Id: <20220405070420.510003967@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



