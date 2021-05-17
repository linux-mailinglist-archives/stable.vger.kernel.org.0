Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CF938335B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241031AbhEQO5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242317AbhEQOzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:55:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F20876145F;
        Mon, 17 May 2021 14:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261499;
        bh=nbSESC9D+inr7RHnDQE1/ttXkXgT5iwF/hsyJ5KHyTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfssACk1jQ9KdLzMbKv76v0tjeS/S9G/pxxm7lkQloIHrswXJyzPvYpOcL1GRI+5Y
         okwATWF08DCL/CD1ab5ioBGqsQ9G+TNseMP7ytBSXM9+uVMuWRkVYNlB9WI4FLgXyi
         5nNEhED+zwpu+YgUDB10cgbYGVWTZ1KkL0RG9QIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 5.12 356/363] arm64: dts: renesas: falcon: Move console config to CPU board DTS
Date:   Mon, 17 May 2021 16:03:42 +0200
Message-Id: <20210517140314.630312260@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit e86ff34cc44a49aeae2af74444560b17a0a96c78 upstream.

The serial console is located on the Falcon CPU board.  Hence move
serial console configuration from the main Falcon DTS file to the DTS
file that describes the CPU board.

Fixes: 63070d7c2270e8de ("arm64: dts: renesas: Add Renesas Falcon boards support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20210316154705.2433528-2-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/renesas/r8a779a0-falcon-cpu.dtsi |    8 ++++++++
 arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts      |    5 -----
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/arch/arm64/boot/dts/renesas/r8a779a0-falcon-cpu.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0-falcon-cpu.dtsi
@@ -12,6 +12,14 @@
 	model = "Renesas Falcon CPU board";
 	compatible = "renesas,falcon-cpu", "renesas,r8a779a0";
 
+	aliases {
+		serial0 = &scif0;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
 	memory@48000000 {
 		device_type = "memory";
 		/* first 128MB is reserved for secure area. */
--- a/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts
@@ -14,11 +14,6 @@
 
 	aliases {
 		ethernet0 = &avb0;
-		serial0 = &scif0;
-	};
-
-	chosen {
-		stdout-path = "serial0:115200n8";
 	};
 };
 


