Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE3550F5C2
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345103AbiDZIro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347039AbiDZIpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98473FBFB;
        Tue, 26 Apr 2022 01:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F0D2CE1BC3;
        Tue, 26 Apr 2022 08:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2FAC385A0;
        Tue, 26 Apr 2022 08:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962230;
        bh=Er9JeDduHx3NE8tk+2GPgX+U68ot1zkwu8WUINdW/4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfKt8Z1mRwnLvV7uUtD5yXdOo3pXFtn7Hr5CXt7q66Ge8lcKRymY/mWuDgbuLYbRY
         o+fpNdTqfwIV6JfZ0XAs5RuNgF/qdLSJhXyZvrUkJKBVCB80s2PTWMf5PNKx4kWJNH
         tbxIGao339YPM+29cKrZXUR99cseeLdOAOxxZx60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/124] spi: cadence-quadspi: fix incorrect supports_op() return value
Date:   Tue, 26 Apr 2022 10:20:29 +0200
Message-Id: <20220426081748.104548213@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit f1d388f216aeb41a5df518815ae559d14a6d438e ]

Since the conversion to spi-mem, the driver advertised support for
various operations that cqspi_set_protocol() was never expected to handle
correctly - in particuar all non-DTR operations with command or address
buswidth > 1. For DTR, all operations except for 8-8-8 would fail, as
cqspi_set_protocol() returns -EINVAL.

In non-DTR mode, this resulted in data corruption for SPI-NOR flashes that
support such operations. As a minimal fix that can be backported to stable
kernels, simply disallow the unsupported operations again to avoid this
issue.

Fixes: a314f6367787 ("mtd: spi-nor: Convert cadence-quadspi to use spi-mem framework")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220406132832.199777-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 1a6294a06e72..75680eecd2f7 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1226,9 +1226,24 @@ static bool cqspi_supports_mem_op(struct spi_mem *mem,
 	all_false = !op->cmd.dtr && !op->addr.dtr && !op->dummy.dtr &&
 		    !op->data.dtr;
 
-	/* Mixed DTR modes not supported. */
-	if (!(all_true || all_false))
+	if (all_true) {
+		/* Right now we only support 8-8-8 DTR mode. */
+		if (op->cmd.nbytes && op->cmd.buswidth != 8)
+			return false;
+		if (op->addr.nbytes && op->addr.buswidth != 8)
+			return false;
+		if (op->data.nbytes && op->data.buswidth != 8)
+			return false;
+	} else if (all_false) {
+		/* Only 1-1-X ops are supported without DTR */
+		if (op->cmd.nbytes && op->cmd.buswidth > 1)
+			return false;
+		if (op->addr.nbytes && op->addr.buswidth > 1)
+			return false;
+	} else {
+		/* Mixed DTR modes are not supported. */
 		return false;
+	}
 
 	if (all_true)
 		return spi_mem_dtr_supports_op(mem, op);
-- 
2.35.1



