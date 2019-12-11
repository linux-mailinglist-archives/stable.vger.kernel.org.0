Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DD311B529
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbfLKPVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731908AbfLKPVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3E6B2467A;
        Wed, 11 Dec 2019 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077665;
        bh=bwooIVWu/MxWs9geWXbUNqyJjTdWQEswFAjdk6BoAVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExnpTOWlfAel3OsoEx8DiSuYVLZfIhwgWOqkKBuD9LaCFBHyEHaIk/EWdULwzZE+t
         e0yY9lbASh/feTv+aOfr6RPkPNPFNUokIY6T0R4fIAD0YUPx5X8V2IDnFFGr1REmFB
         +F2x10T6SXJhXZ/iOCdjMGF5UXbHOtQZNLoQ7huQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/243] ARM: dts: r8a779[01]: Disable unconnected LVDS encoders
Date:   Wed, 11 Dec 2019 16:04:47 +0100
Message-Id: <20191211150347.566420078@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 89862542fab10fed8a3c2f9c167622ef4287351d ]

The LVDS0 encoder on Koelsh and Porter, and the LVDS1 encoder on Lager,
are enabled in DT but have no device connected to their output. This
result in spurious messages being printed to the kernel log such as

rcar-du feb00000.display: no connector for encoder /soc/lvds@feb90000, skipping

Fix it by disabling the encoders.

Fixes: 15a1ff30d8f9 ("ARM: dts: r8a7790: Convert to new LVDS DT bindings")
Fixes: e5c3f4707f39 ("ARM: dts: r8a7791: Convert to new LVDS DT bindings")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/r8a7790-lager.dts   | 2 --
 arch/arm/boot/dts/r8a7791-koelsch.dts | 2 --
 arch/arm/boot/dts/r8a7791-porter.dts  | 2 --
 3 files changed, 6 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 50312e752e2fa..7b9508e83d46c 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -489,8 +489,6 @@
 };
 
 &lvds1 {
-	status = "okay";
-
 	ports {
 		port@1 {
 			lvds_connector: endpoint {
diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index ce22db01fbbaa..e6580aa0cea35 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -479,8 +479,6 @@
 };
 
 &lvds0 {
-	status = "okay";
-
 	ports {
 		port@1 {
 			lvds_connector: endpoint {
diff --git a/arch/arm/boot/dts/r8a7791-porter.dts b/arch/arm/boot/dts/r8a7791-porter.dts
index f02036e5de015..fefdf8238bbe9 100644
--- a/arch/arm/boot/dts/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/r8a7791-porter.dts
@@ -482,8 +482,6 @@
 };
 
 &lvds0 {
-	status = "okay";
-
 	ports {
 		port@1 {
 			lvds_connector: endpoint {
-- 
2.20.1



