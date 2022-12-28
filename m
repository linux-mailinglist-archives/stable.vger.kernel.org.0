Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A4D6578BF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiL1Oxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiL1Oxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:53:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4309DB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:53:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 826D261540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93174C43392;
        Wed, 28 Dec 2022 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239221;
        bh=fJx0AkQabyF5+jsQf/zYDxdUel1nIZr325rimG8VT1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyiCXT+GcuFDVU4DvwU+AzkxqIYXULTF9UEX5/XZJuItI1OIjeQNEr9DQOrB6fXEg
         y0mOJZXZ6VaUTr6G1+R+TC/KBP+YPVlmCv9gXJSiy97gGJlmT7EBqV1ddXRwxpneVH
         hDcy98PgX9er8UI9VsBPEAY1Y6ltA4fh19JkNZok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Ilia.Gavrilov" <Ilia.Gavrilov@infotecs.ru>,
        Colin Ian King <colin.i.king@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, wuchi <wuchi.zero@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/731] relay: fix type mismatch when allocating memory in relay_create_buf()
Date:   Wed, 28 Dec 2022 15:34:04 +0100
Message-Id: <20221228144300.520334245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit 4d8586e04602fe42f0a782d2005956f8b6302678 ]

The 'padding' field of the 'rchan_buf' structure is an array of 'size_t'
elements, but the memory is allocated for an array of 'size_t *' elements.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20221129092002.3538384-1-Ilia.Gavrilov@infotecs.ru
Fixes: b86ff981a825 ("[PATCH] relay: migrate from relayfs to a generic relay API")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: wuchi <wuchi.zero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/relay.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index d1a67fbb819d..6825b8403877 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -151,13 +151,13 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 {
 	struct rchan_buf *buf;
 
-	if (chan->n_subbufs > KMALLOC_MAX_SIZE / sizeof(size_t *))
+	if (chan->n_subbufs > KMALLOC_MAX_SIZE / sizeof(size_t))
 		return NULL;
 
 	buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
-	buf->padding = kmalloc_array(chan->n_subbufs, sizeof(size_t *),
+	buf->padding = kmalloc_array(chan->n_subbufs, sizeof(size_t),
 				     GFP_KERNEL);
 	if (!buf->padding)
 		goto free_buf;
-- 
2.35.1



