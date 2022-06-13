Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181DD548FD7
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355084AbiFMMz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354615AbiFMMxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:53:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823711EAEC;
        Mon, 13 Jun 2022 04:12:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3E2CCE1174;
        Mon, 13 Jun 2022 11:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8A9C34114;
        Mon, 13 Jun 2022 11:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118754;
        bh=zha2dROxJNfVeY3ac8jBE+pOULrvQBeoRLrNGrfbVns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0KPcldgfJl8FOx9jSgNgNWH95UXmdxw3qY/8iPHuujaGMdPLVj5PQFSs0LZqJdzE
         a6VPwcjX5B7HDFcDNTCZSGc3uzZ6UxsmZF8qJQMP4D6hbksGIJqATk3/ywmAQ9rL6p
         b4lZjezLabp7SMcnmy0uHvQrrqV9uhzsBdxVFZFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/247] staging: fieldbus: Fix the error handling path in anybuss_host_common_probe()
Date:   Mon, 13 Jun 2022 12:08:38 +0200
Message-Id: <20220613094923.420381405@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7079b3483a17be2cfba64cbd4feb1b7ae07f1ea7 ]

If device_register() fails, device_unregister() should not be called
because it will free some resources that are not allocated.
put_device() should be used instead.

Fixes: 308ee87a2f1e ("staging: fieldbus: anybus-s: support HMS Anybus-S bus")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/5401a519608d6e1a4e7435c20f4f20b0c5c36c23.1650610082.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fieldbus/anybuss/host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fieldbus/anybuss/host.c b/drivers/staging/fieldbus/anybuss/host.c
index 8a75f6642c78..0c41d1e0204f 100644
--- a/drivers/staging/fieldbus/anybuss/host.c
+++ b/drivers/staging/fieldbus/anybuss/host.c
@@ -1384,7 +1384,7 @@ anybuss_host_common_probe(struct device *dev,
 		goto err_device;
 	return cd;
 err_device:
-	device_unregister(&cd->client->dev);
+	put_device(&cd->client->dev);
 err_kthread:
 	kthread_stop(cd->qthread);
 err_reset:
-- 
2.35.1



