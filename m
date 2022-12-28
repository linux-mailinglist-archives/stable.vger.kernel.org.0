Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97580657DA4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiL1PpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiL1PpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B664F175B4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A746154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC08C433D2;
        Wed, 28 Dec 2022 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242317;
        bh=grmuduIJoEobr0zOVIsI/nBmbnUiYZvuoaYcymVNqnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqzVEMVfrBomAfPpT9WYnPy9IEpgERdmsShdUsNF5XEVvSOk9S16BcvJlqW6yUkQU
         M7OknvwsX0nmB1uzmfZVtr9F0VVeIjE+yh7MCliYwzudRBOLTbAJtYsZ57VqL3lCpv
         hDTI1WJfJRGSqcHrHH2R0utdoYbmdWLK5hLcWaUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0323/1146] module: Fix NULL vs IS_ERR checking for module_get_next_page
Date:   Wed, 28 Dec 2022 15:31:02 +0100
Message-Id: <20221228144338.926514043@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 45af1d7aae7d5520d2858f8517a1342646f015db ]

The module_get_next_page() function return error pointers on error
instead of NULL.
Use IS_ERR() to check the return value to fix this.

Fixes: b1ae6dc41eaa ("module: add in-kernel support for decompressing")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/decompress.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
index c033572d83f0..720e719253cd 100644
--- a/kernel/module/decompress.c
+++ b/kernel/module/decompress.c
@@ -114,8 +114,8 @@ static ssize_t module_gzip_decompress(struct load_info *info,
 	do {
 		struct page *page = module_get_next_page(info);
 
-		if (!page) {
-			retval = -ENOMEM;
+		if (IS_ERR(page)) {
+			retval = PTR_ERR(page);
 			goto out_inflate_end;
 		}
 
@@ -173,8 +173,8 @@ static ssize_t module_xz_decompress(struct load_info *info,
 	do {
 		struct page *page = module_get_next_page(info);
 
-		if (!page) {
-			retval = -ENOMEM;
+		if (IS_ERR(page)) {
+			retval = PTR_ERR(page);
 			goto out;
 		}
 
-- 
2.35.1



