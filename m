Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAE151AA17
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239598AbiEDRVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357861AbiEDRPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9192B554B4;
        Wed,  4 May 2022 09:59:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA2ED61770;
        Wed,  4 May 2022 16:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43CFC385A4;
        Wed,  4 May 2022 16:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683543;
        bh=QsbfSUtuE/rLYIXT6Iqtf1hrjl1h8nMpkg8dsxIdisc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXTJjvhQHoq2iKohn/+yZze9HQDW9pBRZOhV+W1pKIe6vcTAi+Czxb4bFcFViVAld
         14W/YGe7gQoYFkyOs/ObPFP4hQ9Hbq7mCfLzlWr1kuyDDyQnfEA2nHog9MgDiGmool
         B3xaaCVkNHE42chyF4jOIwFBXJiM9H5Ok/ovziJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 214/225] tty: n_gsm: fix wrong signal octets encoding in MSC
Date:   Wed,  4 May 2022 18:47:32 +0200
Message-Id: <20220504153129.063028650@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

commit 317f86af7f5d19f286ed2d181cbaef4a188c7f19 upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. The value of the modem status command (MSC) frame
contains an address field, control signal and optional break signal octet.
The address field is encoded as described in chapter 5.2.1.2 with only one
octet (may be extended to more in future versions of the standard). Whereas
the control signal and break signal octet are always one byte each. This is
strange at first glance as it makes the EA bit redundant. However, the same
two octets are also encoded as header in convergence layer type 2 as
described in chapter 5.5.2. No header length field is given and the only
way to test if there is an optional break signal octet is via the EA flag
which extends the control signal octet with a break signal octet. Now it
becomes obvious how the EA bit for those two octets shall be encoded in the
MSC frame. The current implementation treats the signal octet different for
MSC frame and convergence layer type 2 header even though the standard
describes it for both in the same way.
Use the EA bit to encode the signal octets not only in the convergence
layer type 2 header but also in the MSC frame in the same way with either
1 or 2 bytes in case of an optional break signal. Adjust the receiving path
accordingly in gsm_control_modem().

Fixes: 3ac06b905655 ("tty: n_gsm: Fix for modems with brk in modem status control")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-13-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1094,7 +1094,6 @@ static void gsm_control_modem(struct gsm
 {
 	unsigned int addr = 0;
 	unsigned int modem = 0;
-	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
 	int slen;
@@ -1124,17 +1123,8 @@ static void gsm_control_modem(struct gsm
 			return;
 	}
 	len--;
-	if (len > 0) {
-		while (gsm_read_ea(&brk, *dp++) == 0) {
-			len--;
-			if (len == 0)
-				return;
-		}
-		modem <<= 7;
-		modem |= (brk & 0x7f);
-	}
 	tty = tty_port_tty_get(&dlci->port);
-	gsm_process_modem(tty, dlci, modem, slen);
+	gsm_process_modem(tty, dlci, modem, slen - len);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
@@ -2963,8 +2953,10 @@ static int gsmtty_modem_update(struct gs
 	int len = 2;
 
 	modembits[0] = (dlci->addr << 2) | 2 | EA;  /* DLCI, Valid, EA */
-	modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
-	if (brk) {
+	if (!brk) {
+		modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
+	} else {
+		modembits[1] = gsm_encode_modem(dlci) << 1;
 		modembits[2] = (brk << 4) | 2 | EA; /* Length, Break, EA */
 		len++;
 	}


