Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA30D549361
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385592AbiFMOrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386431AbiFMOqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B376DBF10C;
        Mon, 13 Jun 2022 04:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23F06614F8;
        Mon, 13 Jun 2022 11:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0E9C3411B;
        Mon, 13 Jun 2022 11:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121151;
        bh=AxhBKUCtCxlJS5f8zHw6zkgvS9rbDdVZWXrRtpuA1Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgqzzKxq1bU4FG9sGcv9wtGpm48NLwWlvY2QzQ5eQizbb61TKEipdw/HDy6spF0tF
         JqthX2GgZZ94JTnIS4OiX+uf/APR1NjvW7kJuAX/2Drp6NHQZaOwcLia+nClWaThNo
         vO7WHRgk5p29BCMLU1BozMnJWkpZnkeDj+k/8HKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.17 290/298] drm/ast: Create threshold values for AST2600
Date:   Mon, 13 Jun 2022 12:13:04 +0200
Message-Id: <20220613094933.875504290@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>

commit bcc77411e8a65929655cef7b63a36000724cdc4b upstream.

The threshold value is used for AST2600 only.

Signed-off-by: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220117083643.41493-1-kuohsiang_chou@aspeedtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_mode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -471,7 +471,10 @@ static void ast_set_color_reg(struct ast
 static void ast_set_crtthd_reg(struct ast_private *ast)
 {
 	/* Set Threshold */
-	if (ast->chip == AST2300 || ast->chip == AST2400 ||
+	if (ast->chip == AST2600) {
+		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa7, 0xe0);
+		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa6, 0xa0);
+	} else if (ast->chip == AST2300 || ast->chip == AST2400 ||
 	    ast->chip == AST2500) {
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa7, 0x78);
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa6, 0x60);


