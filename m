Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5976CC4E7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjC1PKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjC1PKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:10:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7FEEB44
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E376A61857
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A36C433EF;
        Tue, 28 Mar 2023 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016128;
        bh=5ZXMaaQ90HEtlHUftl76N2iHrT8pmrL6A2AYmPnGpkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ud399ZFIwfVAQ6f/08PRr1pZYIUS0Ef94YpAqkOpSuJI9AGBpxbB94VKPIy6fEQLj
         a/VfYhErfz41a8FoODyxjO/foe6ZZ0CQy1hN63fzffvG/6Sy+A7p39AskdbCaVL1pu
         rxtJzAAA2r+lG+EhWZLQiB5Z/7NU/5EmMhHK5Ec0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 076/146] thunderbolt: Use scale field when allocating USB3 bandwidth
Date:   Tue, 28 Mar 2023 16:42:45 +0200
Message-Id: <20230328142605.883098601@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit c82510b1d87bdebfe916048857d2ef46f1778aa5 upstream.

When tunneling aggregated USB3 (20 Gb/s) the bandwidth values that are
programmed to the ADP_USB3_CS_2 go higher than 4096 and that does not
fit anymore to the 12-bit field. Fix this by scaling the value using
the scale field accordingly.

Fixes: 3b1d8d577ca8 ("thunderbolt: Implement USB3 bandwidth negotiation routines")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/usb4.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1930,18 +1930,30 @@ static int usb4_usb3_port_write_allocate
 						    int downstream_bw)
 {
 	u32 val, ubw, dbw, scale;
-	int ret;
+	int ret, max_bw;
 
-	/* Read the used scale, hardware default is 0 */
-	ret = tb_port_read(port, &scale, TB_CFG_PORT,
-			   port->cap_adap + ADP_USB3_CS_3, 1);
+	/* Figure out suitable scale */
+	scale = 0;
+	max_bw = max(upstream_bw, downstream_bw);
+	while (scale < 64) {
+		if (mbps_to_usb3_bw(max_bw, scale) < 4096)
+			break;
+		scale++;
+	}
+
+	if (WARN_ON(scale >= 64))
+		return -EINVAL;
+
+	ret = tb_port_write(port, &scale, TB_CFG_PORT,
+			    port->cap_adap + ADP_USB3_CS_3, 1);
 	if (ret)
 		return ret;
 
-	scale &= ADP_USB3_CS_3_SCALE_MASK;
 	ubw = mbps_to_usb3_bw(upstream_bw, scale);
 	dbw = mbps_to_usb3_bw(downstream_bw, scale);
 
+	tb_port_dbg(port, "scaled bandwidth %u/%u, scale %u\n", ubw, dbw, scale);
+
 	ret = tb_port_read(port, &val, TB_CFG_PORT,
 			   port->cap_adap + ADP_USB3_CS_2, 1);
 	if (ret)


