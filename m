Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B029E6DEDFA
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjDLIjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDLIit (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB2A7AA2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DAE462FF9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E47C433EF;
        Wed, 12 Apr 2023 08:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288571;
        bh=mnYuGNDtQknYf4hfaFJbhIyvWF1fkeDL06ujUkk6/x4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azevvGzewwFIRxYU3P0YNmvDcd5Y9Ul+4+4oCRhqH3yicJY2NmXeOCClOc1gKU494
         u5Mb2PTWkOtrNcW1oYw8ZMU1fm5tfqSfZxIC1VC/aT3wPmseaaObznrmKnkP8oUoqe
         Dy4r56mu78IiQAagfc2E0fJIFInOHRbaYX6REbzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca@z3ntu.xyz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/93] net: qrtr: combine nameservice into main module
Date:   Wed, 12 Apr 2023 10:33:30 +0200
Message-Id: <20230412082824.315901983@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit a365023a76f231cc2fc6e33797e66f3bcaa9f9a9 ]

Previously with CONFIG_QRTR=m a separate ns.ko would be built which
wasn't done on purpose and should be included in qrtr.ko.

Rename qrtr.c to af_qrtr.c so we can build a qrtr.ko with both af_qrtr.c
and ns.c.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-By: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20210928171156.6353-1-luca@z3ntu.xyz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 44d807320000 ("net: qrtr: Fix a refcount bug in qrtr_recvmsg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/Makefile              | 3 ++-
 net/qrtr/{qrtr.c => af_qrtr.c} | 0
 2 files changed, 2 insertions(+), 1 deletion(-)
 rename net/qrtr/{qrtr.c => af_qrtr.c} (100%)

diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
index 1b1411d158a73..8e0605f88a73d 100644
--- a/net/qrtr/Makefile
+++ b/net/qrtr/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_QRTR) := qrtr.o ns.o
+obj-$(CONFIG_QRTR) += qrtr.o
+qrtr-y	:= af_qrtr.o ns.o
 
 obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
 qrtr-smd-y	:= smd.o
diff --git a/net/qrtr/qrtr.c b/net/qrtr/af_qrtr.c
similarity index 100%
rename from net/qrtr/qrtr.c
rename to net/qrtr/af_qrtr.c
-- 
2.39.2



