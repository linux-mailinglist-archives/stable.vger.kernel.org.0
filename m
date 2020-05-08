Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4E71CB020
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgEHNXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgEHMhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1979207DD;
        Fri,  8 May 2020 12:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941462;
        bh=l7jXQ0Nv4LX/b1f7hXnhfQP4Wj09qrFnhZeaypEDbR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHC3vOVeLrs3i0mgjW+lvViiFq7Ngc2rTmDvHERnP+Nym6+dKxVRpyots1DQZV8MZ
         Pqo6L0HDp7jnkC3JDNWNW49RJfUMSkXRpUnBSTImuGhStxckd2hvPA2VRwY9o8qvjv
         r7nOf6iT+t8iPMQd5oAe0l/bqix94XaqrWK+tYcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Shimizu <rogershimizu@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 4.4 041/312] ARM: dts: orion5x: fix the missing mtd flash on linkstation lswtgl
Date:   Fri,  8 May 2020 14:30:32 +0200
Message-Id: <20200508123127.443188044@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Shimizu <rogershimizu@gmail.com>

commit 44361a2cc13493fc41216d33bb9a562ec3a9cc4e upstream.

MTD flash stores u-boot and u-boot environment on linkstation lswtgl.
The latter one can be easily read/write by u-boot-tools package in Debian.

Fixes: dc57844a736f ("ARM: dts: orion5x: add buffalo linkstation ls-wtgl")
Signed-off-by: Roger Shimizu <rogershimizu@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/orion5x-linkstation-lswtgl.dts |   31 +++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/arch/arm/boot/dts/orion5x-linkstation-lswtgl.dts
+++ b/arch/arm/boot/dts/orion5x-linkstation-lswtgl.dts
@@ -228,6 +228,37 @@
 	};
 };
 
+&devbus_bootcs {
+	status = "okay";
+	devbus,keep-config;
+
+	flash@0 {
+		compatible = "jedec-flash";
+		reg = <0 0x40000>;
+		bank-width = <1>;
+
+		partitions {
+			compatible = "fixed-partitions";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			header@0 {
+				reg = <0 0x30000>;
+				read-only;
+			};
+
+			uboot@30000 {
+				reg = <0x30000 0xF000>;
+				read-only;
+			};
+
+			uboot_env@3F000 {
+				reg = <0x3F000 0x1000>;
+			};
+		};
+	};
+};
+
 &mdio {
 	status = "okay";
 


