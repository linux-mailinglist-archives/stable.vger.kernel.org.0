Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAA340E1DD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbhIPQcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243182AbhIPQaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5785661381;
        Thu, 16 Sep 2021 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809140;
        bh=mYdBCRdVHdijlfqercYxcBGop3pGY/1ztuhYi1yJIDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCTdgO2OktbzRtF1iEGcUeuy1ZOWg31nU61y1WzmyxxWkZPwtkdKTDP5ZXhUVDT32
         T81r21ClqLzepRSZiyC8aDiXcljcfg//ydvKHO8yLGffqhs8WbwgNt8zU4XGrZJNTa
         a49BpXnFi69DyXRlcRwKNX256J0CAVvgWVLB0gzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.13 046/380] nvmem: core: fix error handling while validating keepout regions
Date:   Thu, 16 Sep 2021 17:56:43 +0200
Message-Id: <20210916155805.547040114@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit de0534df93474f268486c486ea7e01b44a478026 upstream.

Current error path on failure of validating keepout regions is calling
put_device, eventhough the device is not even registered at that point.

Fix this by adding proper error handling of freeing ida and nvmem.

Fixes: fd3bb8f54a88 ("nvmem: core: Add support for keepout regions")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210806085947.22682-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -818,8 +818,11 @@ struct nvmem_device *nvmem_register(cons
 
 	if (nvmem->nkeepout) {
 		rval = nvmem_validate_keepouts(nvmem);
-		if (rval)
-			goto err_put_device;
+		if (rval) {
+			ida_free(&nvmem_ida, nvmem->id);
+			kfree(nvmem);
+			return ERR_PTR(rval);
+		}
 	}
 
 	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);


