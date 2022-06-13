Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF2B548B69
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381260AbiFMOIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382598AbiFMOGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:06:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666F695DED;
        Mon, 13 Jun 2022 04:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8060AB80D31;
        Mon, 13 Jun 2022 11:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6759C34114;
        Mon, 13 Jun 2022 11:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120458;
        bh=28hVbwrBlTsfQv2+VKD9WOmazeddOyy/E8ouUEiCXM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdrUK/DfVPSvIoc+43Sxwpo/btJT0LsxbGDGafhP8yVWeu5lemA6K13iIzSKpQwN1
         LCC/7mG2plleM1ASQSgYBnjyOWU4XM2SzCScXx7+u1aJnq5K9Yi6dkQvvXNfDopgn6
         +VpNamEKVUlaXzvARfM2uItaecH5rqP0753oZdB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 017/298] staging: fieldbus: Fix the error handling path in anybuss_host_common_probe()
Date:   Mon, 13 Jun 2022 12:08:31 +0200
Message-Id: <20220613094925.451631622@linuxfoundation.org>
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
index a344410e48fe..cd86b9c9e345 100644
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



