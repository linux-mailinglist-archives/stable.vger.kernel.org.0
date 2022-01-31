Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BB84A4360
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359027AbiAaLVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51470 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377679AbiAaLSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:18:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0AF86121A;
        Mon, 31 Jan 2022 11:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B59C340E8;
        Mon, 31 Jan 2022 11:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627924;
        bh=kqq6y03ChwTt5zM63F+P8tH1hS8+mglPoTrngiC/CCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+ebJ4HoI5TmiA5hn9I+G/rUO7L2BDRS7eIUVGbQODqkA1iwIwN1s47DC5Q495uRw
         SubFC+tT347yey9YP6Mes+CeErFM9vQhERdJ/OvK56KYlWVN8cX/DnA+F2elRGRUOE
         fS5vYoN4TRnZFdWDzc0r6ElUSI01vjyFo1baJHHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.16 069/200] tty: n_gsm: fix SW flow control encoding/handling
Date:   Mon, 31 Jan 2022 11:55:32 +0100
Message-Id: <20220131105235.904418884@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: daniel.starke@siemens.com <daniel.starke@siemens.com>

commit 8838b2af23caf1ff0610caef2795d6668a013b2d upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.2.7.3 states that DC1 (XON) and DC3 (XOFF)
are the control characters defined in ISO/IEC 646. These shall be quoted if
seen in the data stream to avoid interpretation as flow control characters.

ISO/IEC 646 refers to the set of ISO standards described as the ISO
7-bit coded character set for information interchange. Its final version
is also known as ITU T.50.
See https://www.itu.int/rec/T-REC-T.50-199209-I/en

To abide the standard it is needed to quote DC1 and DC3 correctly if these
are seen as data bytes and not as control characters. The current
implementation already tries to enforce this but fails to catch all
defined cases. 3GPP 27.010 chapter 5.2.7.3 clearly states that the most
significant bit shall be ignored for DC1 and DC3 handling. The current
implementation handles only the case with the most significant bit set 0.
Cases in which DC1 and DC3 have the most significant bit set 1 are left
unhandled.

This patch fixes this by masking the data bytes with ISO_IEC_646_MASK (only
the 7 least significant bits set 1) before comparing them with XON
(a.k.a. DC1) and XOFF (a.k.a. DC3) when testing which byte values need
quotation via byte stuffing.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220120101857.2509-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -322,6 +322,7 @@ static int addr_cnt;
 #define GSM1_ESCAPE_BITS	0x20
 #define XON			0x11
 #define XOFF			0x13
+#define ISO_IEC_646_MASK	0x7F
 
 static const struct tty_port_operations gsm_port_ops;
 
@@ -531,7 +532,8 @@ static int gsm_stuff_frame(const u8 *inp
 	int olen = 0;
 	while (len--) {
 		if (*input == GSM1_SOF || *input == GSM1_ESCAPE
-		    || *input == XON || *input == XOFF) {
+		    || (*input & ISO_IEC_646_MASK) == XON
+		    || (*input & ISO_IEC_646_MASK) == XOFF) {
 			*output++ = GSM1_ESCAPE;
 			*output++ = *input++ ^ GSM1_ESCAPE_BITS;
 			olen++;


