Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F48B15C3C1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgBMPn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbgBMP1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:47 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27BB92168B;
        Thu, 13 Feb 2020 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607666;
        bh=k18fCyvygydurWZoNMpe3VqRFRDrEMWorv4kxA8wwew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrLHa0EPAZwFSA/AQXrArqFrdX+OS4fb9n1FCSWx4NL8Z25J2JzeFZVFEEabetyo8
         Ulmg1AWKez2dzEmt29lPBcWx5qdJchmlWgZIcOuu0gaaoOgew/wVNOffjphoNZF8u1
         +nI9q1TreEivemR5l9Hy0ea1aKXbATMoqfh0KdAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.4 87/96] pinctrl: sh-pfc: r8a77965: Fix DU_DOTCLKIN3 drive/bias control
Date:   Thu, 13 Feb 2020 07:21:34 -0800
Message-Id: <20200213151911.803802391@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit a34cd9dfd03fa9ec380405969f1d638bc63b8d63 upstream.

R-Car Gen3 Hardware Manual Errata for Rev. 2.00 of October 24, 2019
changed the configuration bits for drive and bias control for the
DU_DOTCLKIN3 pin on R-Car M3-N, to match the same pin on R-Car H3.
Update the driver to reflect this.

After this, the handling of drive and bias control for the various
DU_DOTCLKINx pins is consistent across all of the R-Car H3, M3-W,
M3-W+, and M3-N SoCs.

Fixes: 86c045c2e4201e94 ("pinctrl: sh-pfc: r8a77965: Replace DU_DOTCLKIN2 by DU_DOTCLKIN3")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191113101653.28428-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/sh-pfc/pfc-r8a77965.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/sh-pfc/pfc-r8a77965.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a77965.c
@@ -5984,7 +5984,7 @@ static const struct pinmux_drive_reg pin
 		{ PIN_DU_DOTCLKIN1,    0, 2 },	/* DU_DOTCLKIN1 */
 	} },
 	{ PINMUX_DRIVE_REG("DRVCTRL12", 0xe6060330) {
-		{ PIN_DU_DOTCLKIN3,   28, 2 },	/* DU_DOTCLKIN3 */
+		{ PIN_DU_DOTCLKIN3,   24, 2 },	/* DU_DOTCLKIN3 */
 		{ PIN_FSCLKST,        20, 2 },	/* FSCLKST */
 		{ PIN_TMS,             4, 2 },	/* TMS */
 	} },
@@ -6240,8 +6240,8 @@ static const struct pinmux_bias_reg pinm
 		[31] = PIN_DU_DOTCLKIN1,	/* DU_DOTCLKIN1 */
 	} },
 	{ PINMUX_BIAS_REG("PUEN3", 0xe606040c, "PUD3", 0xe606044c) {
-		[ 0] = PIN_DU_DOTCLKIN3,	/* DU_DOTCLKIN3 */
-		[ 1] = SH_PFC_PIN_NONE,
+		[ 0] = SH_PFC_PIN_NONE,
+		[ 1] = PIN_DU_DOTCLKIN3,	/* DU_DOTCLKIN3 */
 		[ 2] = PIN_FSCLKST,		/* FSCLKST */
 		[ 3] = PIN_EXTALR,		/* EXTALR*/
 		[ 4] = PIN_TRST_N,		/* TRST# */


