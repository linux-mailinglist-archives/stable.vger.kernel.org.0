Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DF459A271
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352672AbiHSQgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353308AbiHSQfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:35:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFFA120ABE;
        Fri, 19 Aug 2022 09:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B28F0B8280D;
        Fri, 19 Aug 2022 16:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F926C43140;
        Fri, 19 Aug 2022 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925221;
        bh=MR03i1JZYyk9OQZgcuhuGy5D24XzcVoa/kQ4jJNgMY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9QWHmg2VSOxRp8s3qlK7VpODSrmvaiDBejL/ttnste58+f8AXFLXeS0k0nrwNC/5
         aJtCirN5AaC0ehptHTHK6vLoFXzdU6tpWoKTGU/oHfM6lRsu1O4GktvDwI0B2zYgRs
         UHYj3XQqun5o3E3fb8gELxUdlewfmILfkE/KSCsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/545] powerpc/cell/axon_msi: Fix refcount leak in setup_msi_msg_address
Date:   Fri, 19 Aug 2022 17:43:13 +0200
Message-Id: <20220819153848.341961889@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit df5d4b616ee76abc97e5bd348e22659c2b095b1c ]

of_get_next_parent() returns a node pointer with refcount incremented,
we should use of_node_put() on it when not need anymore.
Add missing of_node_put() in the error path to avoid refcount leak.

Fixes: ce21b3c9648a ("[CELL] add support for MSI on Axon-based Cell systems")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220605065129.63906-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/axon_msi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index ca2555b8a0c2..ffbc7d2e9464 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -226,6 +226,7 @@ static int setup_msi_msg_address(struct pci_dev *dev, struct msi_msg *msg)
 	if (!prop) {
 		dev_dbg(&dev->dev,
 			"axon_msi: no msi-address-(32|64) properties found\n");
+		of_node_put(dn);
 		return -ENOENT;
 	}
 
-- 
2.35.1



