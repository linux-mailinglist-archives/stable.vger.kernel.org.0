Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D757F381
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406247AbfHBJ5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406961AbfHBJ5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4538421773;
        Fri,  2 Aug 2019 09:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739862;
        bh=CLg68tfzKMVwWEvkzvAmfZIb7/a7kh58NQrcf00uExY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbRUiN9t78C3udHm+Fc6n+AeE/eVW53Q0R1P3rdm0EYww8e2zKw4x4/zGM5ugqxfY
         2xj7/Tmuwut+qjwkBVt+6zMXt9KZWUf//NaUFeGvabHRkDWCKU6llyR/Xy5JPtlr/n
         jaSQ7KUPXNyD/JuhDaPF93dwUVekyGuH6azpSZyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 5.2 19/20] Fix allyesconfig output.
Date:   Fri,  2 Aug 2019 11:40:13 +0200
Message-Id: <20190802092103.845130875@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshinori Sato <ysato@users.sourceforge.jp>

commit 1b496469d0c020e09124e03e66a81421c21272a7 upstream.

Conflict JCore-SoC and SolutionEngine 7619.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/boards/Kconfig |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/arch/sh/boards/Kconfig
+++ b/arch/sh/boards/Kconfig
@@ -8,27 +8,19 @@ config SH_ALPHA_BOARD
 	bool
 
 config SH_DEVICE_TREE
-	bool "Board Described by Device Tree"
+	bool
 	select OF
 	select OF_EARLY_FLATTREE
 	select TIMER_OF
 	select COMMON_CLK
 	select GENERIC_CALIBRATE_DELAY
-	help
-	  Select Board Described by Device Tree to build a kernel that
-	  does not hard-code any board-specific knowledge but instead uses
-	  a device tree blob provided by the boot-loader. You must enable
-	  drivers for any hardware you want to use separately. At this
-	  time, only boards based on the open-hardware J-Core processors
-	  have sufficient driver coverage to use this option; do not
-	  select it if you are using original SuperH hardware.
 
 config SH_JCORE_SOC
 	bool "J-Core SoC"
-	depends on SH_DEVICE_TREE && (CPU_SH2 || CPU_J2)
+	select SH_DEVICE_TREE
 	select CLKSRC_JCORE_PIT
 	select JCORE_AIC
-	default y if CPU_J2
+	depends on CPU_J2
 	help
 	  Select this option to include drivers core components of the
 	  J-Core SoC, including interrupt controllers and timers.


