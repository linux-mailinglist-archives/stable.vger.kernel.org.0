Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35EAE13FF9B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgAPXYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729652AbgAPXYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F8B20748;
        Thu, 16 Jan 2020 23:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217052;
        bh=FVn4zUt7llDl0T0xy9sh+uhMK+Vwnl6z/3Aqm9O7aA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkvKvBZECF2JUdE5MZiXSDcdHSKuJXGCn/oaV98vaYQyiwwgkmXO2Ezzoo+ksYTPY
         /8XgZ8pbFmUpxOhKO6c3AICKWHG/21JbpZwcIDH926B1SoqKtxI9JDm+iotO+Iw/lH
         Ch19twdafR7m6TTBZsloBBI2PMr4lIzdD0CPV6xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keiya Nobuta <nobuta.keiya@fujitsu.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.4 120/203] pinctrl: sh-pfc: Fix PINMUX_IPSR_PHYS() to set GPSR
Date:   Fri, 17 Jan 2020 00:17:17 +0100
Message-Id: <20200116231755.814753241@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keiya Nobuta <nobuta.keiya@fujitsu.com>

commit d30710b8cce3a581c170d69002e311cc18ed47d3 upstream.

This patch allows PINMUX_IPSR_PHYS() to set bits in GPSR.
When assigning function to pin, GPSR should be set to peripheral
function.
For example when using SCL3, GPSR2 bit7 (PWM1_A pin) should be set to
peripheral function.

Signed-off-by: Keiya Nobuta <nobuta.keiya@fujitsu.com>
Link: https://lore.kernel.org/r/20191008060112.29819-1-nobuta.keiya@fujitsu.com
Fixes: 50d1ba1764b3e00a ("pinctrl: sh-pfc: Add physical pin multiplexing helper macros")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/sh-pfc/sh_pfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/sh-pfc/sh_pfc.h
+++ b/drivers/pinctrl/sh-pfc/sh_pfc.h
@@ -422,12 +422,12 @@ extern const struct sh_pfc_soc_info shx3
 /*
  * Describe a pinmux configuration in which a pin is physically multiplexed
  * with other pins.
- *   - ipsr: IPSR field (unused, for documentation purposes only)
+ *   - ipsr: IPSR field
  *   - fn: Function name
  *   - psel: Physical multiplexing selector
  */
 #define PINMUX_IPSR_PHYS(ipsr, fn, psel) \
-	PINMUX_DATA(fn##_MARK, FN_##psel)
+	PINMUX_DATA(fn##_MARK, FN_##psel, FN_##ipsr)
 
 /*
  * Describe a pinmux configuration for a single-function pin with GPIO


