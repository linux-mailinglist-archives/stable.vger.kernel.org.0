Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549AF3A6032
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhFNKcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232861AbhFNKb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:31:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61DA9611C1;
        Mon, 14 Jun 2021 10:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666593;
        bh=Wxtvq9eHMKPN54ne+ZQrK/BlFetohqLhABaJbiMUsWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQV9KrUtoYhDU1KJFFDFBhDPYo5foXAh/r7GLh5xEnZgacyVDqYP9bgEyYNlAPqzd
         jQOOjkOLoVFgkePJg8CrSvNcsyUGzDvvNH7QUYx7dx7yyf5khqvdPVS1G8SWa5skyZ
         LJ0HQquNqK3HbRHazKigAnUuH/5QThBVxTaEXc9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/34] powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
Date:   Mon, 14 Jun 2021 12:27:06 +0200
Message-Id: <20210614102642.078248318@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 7adc7b225cddcfd0f346d10144fd7a3d3d9f9ea7 ]

The i2c controllers on the P2040/P2041 have an erratum where the
documented scheme for i2c bus recovery will not work (A-004447). A
different mechanism is needed which is documented in the P2040 Chip
Errata Rev Q (latest available at the time of writing).

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi b/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
index 51e975d7631a..8921f17fca42 100644
--- a/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
@@ -389,7 +389,23 @@
 	};
 
 /include/ "qoriq-i2c-0.dtsi"
+	i2c@118000 {
+		fsl,i2c-erratum-a004447;
+	};
+
+	i2c@118100 {
+		fsl,i2c-erratum-a004447;
+	};
+
 /include/ "qoriq-i2c-1.dtsi"
+	i2c@119000 {
+		fsl,i2c-erratum-a004447;
+	};
+
+	i2c@119100 {
+		fsl,i2c-erratum-a004447;
+	};
+
 /include/ "qoriq-duart-0.dtsi"
 /include/ "qoriq-duart-1.dtsi"
 /include/ "qoriq-gpio-0.dtsi"
-- 
2.30.2



