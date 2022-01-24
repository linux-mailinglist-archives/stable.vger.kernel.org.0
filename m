Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ECF49A570
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370839AbiAYAGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2359649AbiAXXeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:34:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D9FC075D1E;
        Mon, 24 Jan 2022 13:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E06DCB81243;
        Mon, 24 Jan 2022 21:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C01FC340E4;
        Mon, 24 Jan 2022 21:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060187;
        bh=Vub3gPcbHXrEudD6mir+BV04nfHnrQJy1HXlwH2MdRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBWuF3WFlG7PEZVMOdpNGjyZ2Ov2+t3yRo8Pviz4v3bbuMS1ZY5kmP+j0aLqZNPO0
         X/4DilOsjh7sUKIvvQCJnQcnOp2NEqVkGag9J2YDZT7CfzZ5ddMoPeSbV2gQ/3agXl
         07SS1ssBmLY+Q9lTi0h9ZPelka9tu36VbzqxT39w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.16 0836/1039] crypto: omap-aes - Fix broken pm_runtime_and_get() usage
Date:   Mon, 24 Jan 2022 19:43:45 +0100
Message-Id: <20220124184153.391678924@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

commit c2aec59be093bd44627bc4f6bc67e4614a93a7b6 upstream.

This fix is basically the same as 3d6b661330a7 ("crypto: stm32 -
Revert broken pm_runtime_resume_and_get changes"), just for the omap
driver. If the return value isn't used, then pm_runtime_get_sync()
has to be used for ensuring that the usage count is balanced.

Fixes: 1f34cc4a8da3 ("crypto: omap-aes - Fix PM reference leak on omap-aes.c")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/omap-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1302,7 +1302,7 @@ static int omap_aes_suspend(struct devic
 
 static int omap_aes_resume(struct device *dev)
 {
-	pm_runtime_resume_and_get(dev);
+	pm_runtime_get_sync(dev);
 	return 0;
 }
 #endif


