Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9D64B45CF
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbiBNJ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:29:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243078AbiBNJ2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187A160AA5;
        Mon, 14 Feb 2022 01:28:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB788B80DC6;
        Mon, 14 Feb 2022 09:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3AAC340E9;
        Mon, 14 Feb 2022 09:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830917;
        bh=BVp2NYOxol68HKJUG8M/TDvYST2EW00jW0boGJsVm1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qV3hzuAR1Bu6xDjg6MVm0iACKieRblnXJqJ+41yAB1S36R8Yp9TOX2DVL4veH4UDn
         AztcM13CdydgKS7JKgFeafAdqPbTLBMW/QEpuJPVOYczX3kRRYQ/tJ+agVWiXb+I/C
         hERer+3P2ZVikqZ2QcJzQgJ2Jil2/sd+eJ3eQ1AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH 4.9 06/34] serial: sh-sci: Fix misplaced backport of "Fix late enablement of AUTORTS"
Date:   Mon, 14 Feb 2022 10:25:32 +0100
Message-Id: <20220214092446.158164949@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Bertholon <guillaume.bertholon@ens.fr>

The upstream commit 5f76895e4c71 ("serial: sh-sci: Fix late enablement of
AUTORTS") inserted a new call to .set_mctrl().
However the backported version in stable (commit ad3faea03fdf ("serial:
sh-sci: Fix late enablement of AUTORTS")) does not insert it at the same
position.

This patch moves the added instructions back to where they should be
according to the upsteam patch.

Fixes: ad3faea03fdf ("serial: sh-sci: Fix late enablement of AUTORTS")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2377,6 +2377,10 @@ done:
 
 		serial_port_out(port, SCFCR, ctrl);
 	}
+	if (port->flags & UPF_HARD_FLOW) {
+		/* Refresh (Auto) RTS */
+		sci_set_mctrl(port, port->mctrl);
+	}
 
 	scr_val |= s->cfg->scscr & ~(SCSCR_CKE1 | SCSCR_CKE0);
 	dev_dbg(port->dev, "SCSCR 0x%x\n", scr_val);
@@ -2391,10 +2395,6 @@ done:
 		 */
 		udelay(DIV_ROUND_UP(10 * 1000000, baud));
 	}
-	if (port->flags & UPF_HARD_FLOW) {
-		/* Refresh (Auto) RTS */
-		sci_set_mctrl(port, port->mctrl);
-	}
 
 #ifdef CONFIG_SERIAL_SH_SCI_DMA
 	/*


