Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF4548647
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348288AbiFMMz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357063AbiFMMyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:54:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52ED6472F;
        Mon, 13 Jun 2022 04:13:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F30B2B80EA7;
        Mon, 13 Jun 2022 11:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3016CC34114;
        Mon, 13 Jun 2022 11:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118768;
        bh=yx04ig1XPY/rz+Ru6T8UV2Giw2eWst4eOpfLRficU/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NglanGnZu9BRGWbUQeFjTBCaXqoZRPsAPSyeQB/wKD5RW7tLkP1FBA1rtG51WjTxL
         tbk1xc8M1H3pXZeVWVMWYhlIHMeF4xQHgrV4e+Pgs+KDd9Q63sQu3bhjPd1tjtlpLN
         oNZ1s5/6496JbbpkCmnD3zgs0To+j8b8RtyM8Qhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Wang Weiyang <wangweiyang2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/247] tty: goldfish: Use tty_port_destroy() to destroy port
Date:   Mon, 13 Jun 2022 12:08:28 +0200
Message-Id: <20220613094923.104441867@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Wang Weiyang <wangweiyang2@huawei.com>

[ Upstream commit 507b05063d1b7a1fcb9f7d7c47586fc4f3508f98 ]

In goldfish_tty_probe(), the port initialized through tty_port_init()
should be destroyed in error paths.In goldfish_tty_remove(), qtty->port
also should be destroyed or else might leak resources.

Fix the above by calling tty_port_destroy().

Fixes: 666b7793d4bf ("goldfish: tty driver")
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
Link: https://lore.kernel.org/r/20220328115844.86032-1-wangweiyang2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/goldfish.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 876ff5445c52..0dc9a6a36ce0 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -407,6 +407,7 @@ static int goldfish_tty_probe(struct platform_device *pdev)
 err_tty_register_device_failed:
 	free_irq(irq, qtty);
 err_dec_line_count:
+	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
 		goldfish_tty_delete_driver();
@@ -428,6 +429,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
 	iounmap(qtty->base);
 	qtty->base = NULL;
 	free_irq(qtty->irq, pdev);
+	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
 		goldfish_tty_delete_driver();
-- 
2.35.1



