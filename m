Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB0B3CA7D2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241647AbhGOS4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241240AbhGOSze (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE6B5613CF;
        Thu, 15 Jul 2021 18:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375160;
        bh=Zyse1W4/NOhaulWxxXeZ1NpcQ0SdVWN3GZYNdIpzm1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qGIiVENCGbfuCNUqzOrKZtBrnHDtz1nu8sPDKao2RAAg0UPgzyUv9lDHkRhyEloH
         lszs7F+7XHvN33WFTJyOjUFyBVRoaxIkZvjij/fI6Lf6YMa9mpOy8js3WGHeiwxJZy
         zZClPGVF5baDxHdl+yqd+r3HBMz0ouTjIJtbOxmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 184/215] nvmem: core: add a missing of_node_put
Date:   Thu, 15 Jul 2021 20:39:16 +0200
Message-Id: <20210715182631.808344889@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 63879e2964bceee2aa5bbe8b99ea58bba28bb64f upstream.

'for_each_child_of_node' performs an of_node_get on each iteration, so a
return from the middle of the loop requires an of_node_put.

Fixes: e888d445ac33 ("nvmem: resolve cells from DT at registration time")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210611102321.11509-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -549,15 +549,17 @@ static int nvmem_add_cells_from_of(struc
 			continue;
 		if (len < 2 * sizeof(u32)) {
 			dev_err(dev, "nvmem: invalid reg on %pOF\n", child);
+			of_node_put(child);
 			return -EINVAL;
 		}
 
 		cell = kzalloc(sizeof(*cell), GFP_KERNEL);
-		if (!cell)
+		if (!cell) {
+			of_node_put(child);
 			return -ENOMEM;
+		}
 
 		cell->nvmem = nvmem;
-		cell->np = of_node_get(child);
 		cell->offset = be32_to_cpup(addr++);
 		cell->bytes = be32_to_cpup(addr);
 		cell->name = kasprintf(GFP_KERNEL, "%pOFn", child);
@@ -578,11 +580,12 @@ static int nvmem_add_cells_from_of(struc
 				cell->name, nvmem->stride);
 			/* Cells already added will be freed later. */
 			kfree_const(cell->name);
-			of_node_put(cell->np);
 			kfree(cell);
+			of_node_put(child);
 			return -EINVAL;
 		}
 
+		cell->np = of_node_get(child);
 		nvmem_cell_add(cell);
 	}
 


