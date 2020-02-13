Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D602315C451
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgBMPqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgBMP1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:21 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 241042468D;
        Thu, 13 Feb 2020 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607641;
        bh=AzyPehGb52ECJ+zdCScD6NmW/QG6jNq0X+C2XumulvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UD9RkW9ZPiByenwQGM5HJNouJp1Kw4K5aUAfD9URzEiDlqb40CM6aEUaoYLqujZ7e
         sXI9klPcv34wAX3PmUxyBuwTUfSHP05LEObI9hLT0W2+IE8Pa9ruxvFjq1YLvDc97M
         uwGwz8/+NQEldGUcK8KcFvQXPt6tG5/RgZVJnZd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.4 47/96] ARM: dts: meson8: use the actual frequency for the GPUs 182.1MHz OPP
Date:   Thu, 13 Feb 2020 07:20:54 -0800
Message-Id: <20200213151857.588130768@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit fe634a7a9a57fb736e39fb71aa9adc6448a90f94 upstream.

The clock setup on Meson8 cannot achieve a Mali frequency of exactly
182.15MHz. The vendor driver uses "FCLK_DIV7 / 2" for this frequency,
which translates to 2550MHz / 7 / 2 = 182142857Hz.
Update the GPU operating point to that specific frequency to not confuse
myself when comparing the frequency from the .dts with the actual clock
rate on the system.

Fixes: 7d3f6b536e72c9 ("ARM: dts: meson8: add the Mali-450 MP6 GPU")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/meson8.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -129,8 +129,8 @@
 	gpu_opp_table: gpu-opp-table {
 		compatible = "operating-points-v2";
 
-		opp-182150000 {
-			opp-hz = /bits/ 64 <182150000>;
+		opp-182142857 {
+			opp-hz = /bits/ 64 <182142857>;
 			opp-microvolt = <1150000>;
 		};
 		opp-318750000 {


