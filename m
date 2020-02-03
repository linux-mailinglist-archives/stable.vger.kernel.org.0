Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6798150D8A
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgBCQa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbgBCQa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:57 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3189A2080C;
        Mon,  3 Feb 2020 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747456;
        bh=B9JCGm51siuIgX7EcU2ySapCcDCJW8dAc+m2KJEWRyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgJJSv2Fmq6Zcr/+XRhvVxnDvbu9eyAgGYr7M+fnwU5ID2LSphK6zj5wXo/V/fUyo
         8QgA3loiNcGbZaUEKgQhex6FCP7YwlLp5+hCise+iKdT5R9luw19yBHofapel5vqNx
         fHYUBd5Rd4QUP6ElOmT7ARKZjoFf71dZGbeyIwBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 71/89] ARM: dts: am335x-boneblack-common: fix memory size
Date:   Mon,  3 Feb 2020 16:19:56 +0000
Message-Id: <20200203161925.711697365@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matwey V. Kornilov <matwey@sai.msu.ru>

[ Upstream commit 5abd45ea0fc3060f7805e131753fdcbafd6c6618 ]

BeagleBone Black series is equipped with 512MB RAM
whereas only 256MB is included from am335x-bone-common.dtsi

This leads to an issue with unusual setups when devicetree
is loaded by GRUB2 directly.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-boneblack-common.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-boneblack-common.dtsi b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
index 325daae40278a..485c27f039f59 100644
--- a/arch/arm/boot/dts/am335x-boneblack-common.dtsi
+++ b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
@@ -131,6 +131,11 @@
 };
 
 / {
+	memory@80000000 {
+		device_type = "memory";
+		reg = <0x80000000 0x20000000>; /* 512 MB */
+	};
+
 	clk_mcasp0_fixed: clk_mcasp0_fixed {
 		#clock-cells = <0>;
 		compatible = "fixed-clock";
-- 
2.20.1



