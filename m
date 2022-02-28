Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F76B4C740B
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237009AbiB1Rkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiB1RkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:40:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D820593185;
        Mon, 28 Feb 2022 09:34:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A042614BB;
        Mon, 28 Feb 2022 17:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7ACC340E7;
        Mon, 28 Feb 2022 17:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069657;
        bh=0RtYBQzJmD78NjmUnjR65nAJ5Z8h/s9oL/ps01pFpog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNOfOn8LkfaD4+rkfYx9ueGqYYtmyOkkAGlbW0kPE5xcSk0xWgnhUd9hzejsc57I3
         1s4e+bIEmRrLM/CR3WUp7Qx/zU5HeFK74qd80ad4ugMn8KE26594OyyRSrBRe0IK45
         G7ZRNQF4Q9b7q1CiiVVg+j88Xga8Hvz/gOWpkxrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/80] spi: spi-zynq-qspi: Fix a NULL pointer dereference in zynq_qspi_exec_mem_op()
Date:   Mon, 28 Feb 2022 18:24:26 +0100
Message-Id: <20220228172317.075616514@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit ab3824427b848da10e9fe2727f035bbeecae6ff4 ]

In zynq_qspi_exec_mem_op(), kzalloc() is directly used in memset(),
which could lead to a NULL pointer dereference on failure of
kzalloc().

Fix this bug by adding a check of tmpbuf.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_SPI_ZYNQ_QSPI=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 67dca5e580f1 ("spi: spi-mem: Add support for Zynq QSPI controller")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Link: https://lore.kernel.org/r/20211130172253.203700-1-zhou1615@umn.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index b635835729d66..13c0b15fe1764 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -570,6 +570,9 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 
 	if (op->dummy.nbytes) {
 		tmpbuf = kzalloc(op->dummy.nbytes, GFP_KERNEL);
+		if (!tmpbuf)
+			return -ENOMEM;
+
 		memset(tmpbuf, 0xff, op->dummy.nbytes);
 		reinit_completion(&xqspi->data_completion);
 		xqspi->txbuf = tmpbuf;
-- 
2.34.1



