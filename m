Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDD268D8FB
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjBGNOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbjBGNO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:14:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A064A279B1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:14:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65D6A6138B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDD0C433D2;
        Tue,  7 Feb 2023 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775619;
        bh=gBHX6vh5ernQohjPGghByzge3HefeFvbQgvyyrzYYEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcPJtq4U17wxLYNeIl/0vvsxdd0WBfeezR9yP1tnJJg3f0ZtjQlDWI1AiNvkGXOhi
         eimVrM4myn4tsKYX3/F2JLZd28Ylb1yXzZdzSYW3KvWaIO3G6vJiDxlia9pCTzzpBv
         JmZsIfgUsr8VXAsvwa0E+kN6OUrDjd58/SIODLlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Walle <michael@walle.cc>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 101/120] nvmem: core: fix cell removal on error
Date:   Tue,  7 Feb 2023 13:57:52 +0100
Message-Id: <20230207125623.067700604@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

From: Michael Walle <michael@walle.cc>

commit db3546d58b5a0fa581d9c9f2bdc2856fa6c5e43e upstream.

nvmem_add_cells() could return an error after some cells are already
added to the provider. In this case, the added cells are not removed.
Remove any registered cells if nvmem_add_cells() fails.

Fixes: fa72d847d68d7 ("nvmem: check the return value of nvmem_add_cells()")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-9-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -844,7 +844,7 @@ struct nvmem_device *nvmem_register(cons
 	if (config->cells) {
 		rval = nvmem_add_cells(nvmem, config->cells, config->ncells);
 		if (rval)
-			goto err_teardown_compat;
+			goto err_remove_cells;
 	}
 
 	rval = nvmem_add_cells_from_table(nvmem);
@@ -861,7 +861,6 @@ struct nvmem_device *nvmem_register(cons
 
 err_remove_cells:
 	nvmem_device_remove_all_cells(nvmem);
-err_teardown_compat:
 	if (config->compat)
 		nvmem_sysfs_remove_compat(nvmem, config);
 err_device_del:


