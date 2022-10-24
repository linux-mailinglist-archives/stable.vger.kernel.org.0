Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEAB60B911
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJXUCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiJXUBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:01:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A58F1187AB;
        Mon, 24 Oct 2022 11:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B77B815BA;
        Mon, 24 Oct 2022 12:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D091C433D7;
        Mon, 24 Oct 2022 12:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614901;
        bh=veLomsfAFL54LcEqYU53ULi2HJ+QMvvQ3Z6rw0DYcFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e46cXWPwMYuFE6u/T33EoRS26kobO2MpEUOJioR228PgIVOx1+kjVaj2MQ4Pgznjm
         sZQTCBWSDHqfxXRzguhIpcBgsmyTvuAF8VOcgeX7ziY+Pu5CbTXVUEWJNf34NxzsU+
         ldp13yLkZpeMJg5Q+autetEg73a5jVV3jP5A1Bd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 047/530] nvmem: core: Fix memleak in nvmem_register()
Date:   Mon, 24 Oct 2022 13:26:31 +0200
Message-Id: <20221024113047.142601737@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit bd1244561fa2a4531ded40dbf09c9599084f8b29 upstream.

dev_set_name will alloc memory for nvmem->dev.kobj.name in
nvmem_register, when nvmem_validate_keepouts failed, nvmem's
memory will be freed and return, but nobody will free memory
for nvmem->dev.kobj.name, there will be memleak, so moving
nvmem_validate_keepouts() after device_register() and let
the device core deal with cleaning name in error cases.

Fixes: de0534df9347 ("nvmem: core: fix error handling while validating keepout regions")
Cc: stable@vger.kernel.org
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220916120402.38753-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -824,21 +824,18 @@ struct nvmem_device *nvmem_register(cons
 	nvmem->dev.groups = nvmem_dev_groups;
 #endif
 
-	if (nvmem->nkeepout) {
-		rval = nvmem_validate_keepouts(nvmem);
-		if (rval) {
-			ida_free(&nvmem_ida, nvmem->id);
-			kfree(nvmem);
-			return ERR_PTR(rval);
-		}
-	}
-
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
 
 	rval = device_register(&nvmem->dev);
 	if (rval)
 		goto err_put_device;
 
+	if (nvmem->nkeepout) {
+		rval = nvmem_validate_keepouts(nvmem);
+		if (rval)
+			goto err_device_del;
+	}
+
 	if (config->compat) {
 		rval = nvmem_sysfs_setup_compat(nvmem, config);
 		if (rval)


