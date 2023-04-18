Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3045F6E64CC
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjDRMwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjDRMwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803B8AA
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614F963382
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77653C433EF;
        Tue, 18 Apr 2023 12:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822330;
        bh=phccvm6yp0Roa2UoU0zNFZvTK811b8TuF8twIphPFf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHd8WK89oOXFU3wN2qA/5lzeMi6h5yS95J+BY2JG6wtHavNfnyGc6tcXmeE0IjHVk
         EZCF0iPK0Je+eI98qS590nuIw4eDHiirx3byNfiSWssRnF/lAIVWfDa0ZtMDR7owZv
         lJ59HgvevXa5e6OJYiSX6wqE3B2L0TL4EG8Iznds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 110/139] net: phy: nxp-c45-tja11xx: fix unsigned long multiplication overflow
Date:   Tue, 18 Apr 2023 14:22:55 +0200
Message-Id: <20230418120317.901634403@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

commit bdaaecc127d471c422ee9e994978617c8aa79e1e upstream.

Any multiplication between GENMASK(31, 0) and a number bigger than 1
will be truncated because of the overflow, if the size of unsigned long
is 32 bits.

Replaced GENMASK with GENMASK_ULL to make sure that multiplication will
be between 64 bits values.

Cc: <stable@vger.kernel.org> # 5.15+
Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230406095953.75622-1-radu-nicolae.pirea@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -191,7 +191,7 @@
 #define MAX_ID_PS			2260U
 #define DEFAULT_ID_PS			2000U
 
-#define PPM_TO_SUBNS_INC(ppb)	div_u64(GENMASK(31, 0) * (ppb) * \
+#define PPM_TO_SUBNS_INC(ppb)	div_u64(GENMASK_ULL(31, 0) * (ppb) * \
 					PTP_CLK_PERIOD_100BT1, NSEC_PER_SEC)
 
 #define NXP_C45_SKB_CB(skb)	((struct nxp_c45_skb_cb *)(skb)->cb)


