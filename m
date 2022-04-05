Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2451B4F3764
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352886AbiDELNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348994AbiDEJsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83784BE34;
        Tue,  5 Apr 2022 02:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A3F3615E5;
        Tue,  5 Apr 2022 09:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22029C385A2;
        Tue,  5 Apr 2022 09:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151526;
        bh=4GVNTj2YOOxt86du6z4LnhR8s7JceT8i+SaFiQdlXpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3QNB2cvd8TPd4MLu1iY2GvbOOv3rsBykY41gKfsRNdJ8s9S2fnqAZaplMrTQNuGR
         DdMrVRGsQwqUQqKzAnY2HAh+EbEpfUKAJV0gdzayxTkd9Hg20FMIEarhjwUpEfxoQO
         FEA1aGYZNI1v+38qCDmK/+3hn1xIWwO0BrEgUpao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/913] cxl/regs: Fix size of CXL Capability Header Register
Date:   Tue,  5 Apr 2022 09:25:08 +0200
Message-Id: <20220405070353.216070330@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 74b0fe80409733055971bbfaf33c80a33fddeeb3 ]

In CXL 2.0, 8.2.5.1 CXL Capability Header Register: this register
is given as 32 bits.

8.2.3 which covers the CXL 2.0 Component registers, including the
CXL Capability Header Register states that access restrictions
specified in Section 8.2.2 apply.

8.2.2 includes:
* A 32 bit register shall be accessed as a 4 Byte quantity.
...
If these rules are not followed, the behavior is undefined.

Discovered during review of CXL QEMU emulation. Alex Bennée pointed
out there was a comment saying that 4 byte registers must be read
with a 4 byte read, but 8 byte reads were being emulated.

https://lore.kernel.org/qemu-devel/87bkzyd3c7.fsf@linaro.org/

Fixing that, led to this code failing. Whilst a given hardware
implementation 'might' work with an 8 byte read, it should not be relied
upon. The QEMU emulation v5 will return 0 and log the wrong access width.

The code moved, so one fixes tag for where this will directly apply and
also a reference to the earlier introduction of the code for backports.

Fixes: 0f06157e0135 ("cxl/core: Move register mapping infrastructure")
Fixes: 08422378c4ad ("cxl/pci: Add HDM decoder capabilities")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Link: https://lore.kernel.org/r/20220201153437.2873-1-Jonathan.Cameron@huawei.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
index b8aa583a7642..2e7027a3fef3 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -35,7 +35,7 @@ void cxl_probe_component_regs(struct device *dev, void __iomem *base,
 			      struct cxl_component_reg_map *map)
 {
 	int cap, cap_count;
-	u64 cap_array;
+	u32 cap_array;
 
 	*map = (struct cxl_component_reg_map) { 0 };
 
@@ -45,7 +45,7 @@ void cxl_probe_component_regs(struct device *dev, void __iomem *base,
 	 */
 	base += CXL_CM_OFFSET;
 
-	cap_array = readq(base + CXL_CM_CAP_HDR_OFFSET);
+	cap_array = readl(base + CXL_CM_CAP_HDR_OFFSET);
 
 	if (FIELD_GET(CXL_CM_CAP_HDR_ID_MASK, cap_array) != CM_CAP_HDR_CAP_ID) {
 		dev_err(dev,
-- 
2.34.1



