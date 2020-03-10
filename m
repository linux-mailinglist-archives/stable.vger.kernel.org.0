Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04DD17FA3A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgCJNDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbgCJNDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:03:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C49724691;
        Tue, 10 Mar 2020 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845420;
        bh=0JvlWOVoCjZDr+FZhRdW+FuWzGIT2n/P932ze8nXmGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzNCIo0NoO0X0bGKR1xTNZH2chTRRvnf2R8/+Ye73NuJVClOlWMg4hIB8k6gzABGq
         Pfs7KUFGo+27EiZ+Rhck8Ao/MeZTq5sNd9tBd/rxtipZnfBN+Lzo6kwycekmMLCciT
         qADE/1HNXMUIm2iVLfjLtr6bzpmFuGn6qWRJfMWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.5 176/189] ARM: dts: imx7-colibri: Fix frequency for sd/mmc
Date:   Tue, 10 Mar 2020 13:40:13 +0100
Message-Id: <20200310123657.513987659@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

commit 2773fe1d31c42ffae2a9cb9a6055d99dd86e2fee upstream.

SD/MMC on Colibri iMX7S/D modules successfully support
200Mhz frequency in HS200 mode.

Removing the unnecessary max-frequency limit significantly
increases the performance:

== before fix ====
root@colibri-imx7-emmc:~# hdparm -t /dev/mmcblk0
/dev/mmcblk0:
 Timing buffered disk reads: 252 MB in  3.02 seconds =  83.54 MB/sec
==================

=== after fix ====
root@colibri-imx7-emmc:~# hdparm -t /dev/mmcblk0
/dev/mmcblk0:
 Timing buffered disk reads: 408 MB in  3.00 seconds = 135.94 MB/sec
==================

Fixes: f928a4a377e4 ("ARM: dts: imx7: add Toradex Colibri iMX7D 1GB (eMMC) support")
Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx7-colibri.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/imx7-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri.dtsi
@@ -336,7 +336,6 @@
 	assigned-clock-rates = <400000000>;
 	bus-width = <8>;
 	fsl,tuning-step = <2>;
-	max-frequency = <100000000>;
 	vmmc-supply = <&reg_module_3v3>;
 	vqmmc-supply = <&reg_DCDC3>;
 	non-removable;


