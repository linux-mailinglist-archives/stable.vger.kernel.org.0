Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F612DEF9D
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgLSNGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbgLSND7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:03:59 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 08/34] enetc: Fix reporting of h/w packet counters
Date:   Sat, 19 Dec 2020 14:03:05 +0100
Message-Id: <20201219125341.787176910@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit eb96b686fc2c601e78903cc61b6cf4588ddde013 ]

Noticed some inconsistencies in packet statistics reporting.
This patch adds the missing Tx packet counter registers to
ethtool reporting and fixes the information strings for a
few of them.

Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20201204171505.21389-1-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c |   10 +++++++---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h      |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -141,8 +141,8 @@ static const struct {
 	{ ENETC_PM0_R255,   "MAC rx 128-255 byte packets" },
 	{ ENETC_PM0_R511,   "MAC rx 256-511 byte packets" },
 	{ ENETC_PM0_R1023,  "MAC rx 512-1023 byte packets" },
-	{ ENETC_PM0_R1518,  "MAC rx 1024-1518 byte packets" },
-	{ ENETC_PM0_R1519X, "MAC rx 1519 to max-octet packets" },
+	{ ENETC_PM0_R1522,  "MAC rx 1024-1522 byte packets" },
+	{ ENETC_PM0_R1523X, "MAC rx 1523 to max-octet packets" },
 	{ ENETC_PM0_ROVR,   "MAC rx oversized packets" },
 	{ ENETC_PM0_RJBR,   "MAC rx jabber packets" },
 	{ ENETC_PM0_RFRG,   "MAC rx fragment packets" },
@@ -161,9 +161,13 @@ static const struct {
 	{ ENETC_PM0_TBCA,   "MAC tx broadcast frames" },
 	{ ENETC_PM0_TPKT,   "MAC tx packets" },
 	{ ENETC_PM0_TUND,   "MAC tx undersized packets" },
+	{ ENETC_PM0_T64,    "MAC tx 64 byte packets" },
 	{ ENETC_PM0_T127,   "MAC tx 65-127 byte packets" },
+	{ ENETC_PM0_T255,   "MAC tx 128-255 byte packets" },
+	{ ENETC_PM0_T511,   "MAC tx 256-511 byte packets" },
 	{ ENETC_PM0_T1023,  "MAC tx 512-1023 byte packets" },
-	{ ENETC_PM0_T1518,  "MAC tx 1024-1518 byte packets" },
+	{ ENETC_PM0_T1522,  "MAC tx 1024-1522 byte packets" },
+	{ ENETC_PM0_T1523X, "MAC tx 1523 to max-octet packets" },
 	{ ENETC_PM0_TCNP,   "MAC tx control packets" },
 	{ ENETC_PM0_TDFR,   "MAC tx deferred packets" },
 	{ ENETC_PM0_TMCOL,  "MAC tx multiple collisions" },
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -239,8 +239,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_R255		0x8180
 #define ENETC_PM0_R511		0x8188
 #define ENETC_PM0_R1023		0x8190
-#define ENETC_PM0_R1518		0x8198
-#define ENETC_PM0_R1519X	0x81A0
+#define ENETC_PM0_R1522		0x8198
+#define ENETC_PM0_R1523X	0x81A0
 #define ENETC_PM0_ROVR		0x81A8
 #define ENETC_PM0_RJBR		0x81B0
 #define ENETC_PM0_RFRG		0x81B8
@@ -259,9 +259,13 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_TBCA		0x8250
 #define ENETC_PM0_TPKT		0x8260
 #define ENETC_PM0_TUND		0x8268
+#define ENETC_PM0_T64		0x8270
 #define ENETC_PM0_T127		0x8278
+#define ENETC_PM0_T255		0x8280
+#define ENETC_PM0_T511		0x8288
 #define ENETC_PM0_T1023		0x8290
-#define ENETC_PM0_T1518		0x8298
+#define ENETC_PM0_T1522		0x8298
+#define ENETC_PM0_T1523X	0x82A0
 #define ENETC_PM0_TCNP		0x82C0
 #define ENETC_PM0_TDFR		0x82D0
 #define ENETC_PM0_TMCOL		0x82D8


