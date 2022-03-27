Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189394E8636
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 08:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiC0GNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbiC0GNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:13:39 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAAFB0F;
        Sat, 26 Mar 2022 23:12:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c2so9772104pga.10;
        Sat, 26 Mar 2022 23:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BE+aA36i8c3R5wojjNo4XL/AkAZANQ6GWopioCR7lsc=;
        b=Nw2r6AW4z/IkzWG3sJ1kq9jiOS0NTZtYmMnksU9Kj20S7JH68xRaP93m21TynLpjml
         KkXjALXA6lTXTyMtfeOYFAkHwD3zl7ElW4zV+5FurtFTdxqvR/Cr2i8ZjThSpkmYBtCn
         TkbMS/VpLspECre+tm/1SkjcGqn4naNiNvmC0am9gRpqV/XXgLri9gcP4dwhUGtNz3/l
         /B3qmFGlug2UMdKZG8BtakV3miPozC4OH/zWhI+m22oOXb3+OkdtmaVfSXbw7TCpI7z2
         4VDe967Jw5PIvKAxMpNBbPk+fcx96Uwlf40SS6bh1I4M+gypREFTpVEIcFsJ6cGtXBJ0
         +Vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BE+aA36i8c3R5wojjNo4XL/AkAZANQ6GWopioCR7lsc=;
        b=4DyXsM//p/msW4vBYDrQ9zudTXsWBNl9VEFs4chEBL6Nc5A3pt+3nNAuCO/9Skj8oA
         qZyKMOcEZX0hF5OAKdFAimXHHMz0CApmzxAsAe2ysGtewGub037SkA8oyfbDaY7X7Ken
         7RqyaISb0irZUOjorf+FtMRrJoSeI1Bw64oOhIpSpcL3S5tKg8NCrWhYMOlevcDLkNCY
         PcGmyakA/A3F24eoBBb6SFXXoWVhy68NqXAK3zNgLLlVigohO7K87fftkFWg3WYBl8h8
         qgOK6bJsaDT4gsN/hI6zl6cx+NaI0pYUgHhJXCtEuHCLF3n/d42peqeOa4tIOFEZsRJG
         JKYQ==
X-Gm-Message-State: AOAM530nwe5c7nDe3Ls/tsK9LGwfHn+b3tC9ll3OYS997QHPVp+oNGoD
        j5C3ksyP+mHsJeGQYmVtM4ThEbFDygw=
X-Google-Smtp-Source: ABdhPJyIGF8CYoN8BLP/kuL47FMddIbBlo1ZP1EE47uXttVNcUR/kg8Fcm9ClWqDCfbuDe9b4MljEA==
X-Received: by 2002:a05:6a00:130e:b0:4cc:3c7d:4dec with SMTP id j14-20020a056a00130e00b004cc3c7d4decmr17646042pfu.32.1648361520552;
        Sat, 26 Mar 2022 23:12:00 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm11903794pfu.202.2022.03.26.23.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 23:12:00 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     ludovic.desroches@microchip.com
Cc:     tudor.ambarus@microchip.com, vkoul@kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] dma: at_xdmac: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 14:11:54 +0800
Message-Id: <20220327061154.4867-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	__func__, desc, &desc->tx_dma_desc.phys, ret, cookie, residue);

The list iterator 'desc' will point to a bogus position containing
HEAD if the list is empty or no element is found. To avoid dev_dbg()
prints a invalid address, use a new variable 'iter' as the list
iterator, while use the origin variable 'desc' as a dedicated
pointer to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 82e2424635f4c ("dmaengine: xdmac: fix print warning on dma_addr_t variable")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/dma/at_xdmac.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 1476156af74b..def564d1e8fa 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1453,7 +1453,7 @@ at_xdmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 {
 	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
 	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
-	struct at_xdmac_desc	*desc, *_desc;
+	struct at_xdmac_desc	*desc, *_desc, *iter;
 	struct list_head	*descs_list;
 	enum dma_status		ret;
 	int			residue, retry;
@@ -1568,11 +1568,13 @@ at_xdmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	 * microblock.
 	 */
 	descs_list = &desc->descs_list;
-	list_for_each_entry_safe(desc, _desc, descs_list, desc_node) {
-		dwidth = at_xdmac_get_dwidth(desc->lld.mbr_cfg);
-		residue -= (desc->lld.mbr_ubc & 0xffffff) << dwidth;
-		if ((desc->lld.mbr_nda & 0xfffffffc) == cur_nda)
+	list_for_each_entry_safe(iter, _desc, descs_list, desc_node) {
+		dwidth = at_xdmac_get_dwidth(iter->lld.mbr_cfg);
+		residue -= (iter->lld.mbr_ubc & 0xffffff) << dwidth;
+		if ((iter->lld.mbr_nda & 0xfffffffc) == cur_nda) {
+			desc = iter;
 			break;
+		}
 	}
 	residue += cur_ubc << dwidth;
 
-- 
2.17.1

