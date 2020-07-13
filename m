Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1948321D852
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgGMOXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgGMOXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 10:23:43 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFB2C061755
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 07:23:43 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c30so12281661qka.10
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 07:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qq85m4gXnQc1Ga+qbIQPv/IwGROznWBDR0xGC3cs+/s=;
        b=T0oBM/umLio1RT7JhAWEDBRpIc/6cOLaU5AuoGVcC6M2sVliNXz6JNjIjQrP/U6Xze
         UV1/VOmqBGrOyZoTx4rBVyjuUeWLgFr7gLa2oMWc1l7oal266ypvCf8RaOx4pqMWoj+H
         JoGpzx8kyZtAbjWce30Gqmriug99IBNz8xbHRSjFaO2Hsxx2aqI+WhU/5FXCHOb+/7Ku
         bhZ7mepQc6UuiyHOmuSqasJ+VGS75qAQOEWO2WnQ2wvDDdNljNbLzZ9Dr0e4m/jDpqdP
         tvAbEqx8fPqPR0S8zqWF48vhFJcsPm/Qb3Nu42aAbXCUsXC49upKScCF9lTwFCA2mUR/
         Rdbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qq85m4gXnQc1Ga+qbIQPv/IwGROznWBDR0xGC3cs+/s=;
        b=qxA0qRfg8EqNI6E1EhmLF1DUTneNAkBkf2JVTNLyhajLtGn2v968DO0CWJtEk1F7cN
         Hy/7R8LwxPPcSQXeV86jbj3ZBAS78tsnXRNCfdyCA0bciFAq8uX+u+/4UIenluw0ZceA
         ttLumOtblABGe1s6YGrrz6YbqsxZliDs4PbDuUQJchivwy9FrupeK29ud/K4HR0xTxZt
         urK4U4ddAZrRHYymeGX4dIZwk2LXwnK+6wpRTF9R064j0H7qhiDwB02yVqaPRjhikVBn
         ubu8tD0ehwUfacQL21DmnIbYvWygW2l1eUNYG6KcGYIYjjzaqkauoUrR7/j7hmcqPc2g
         sMUw==
X-Gm-Message-State: AOAM530cqOLjxGR3v0afPNGo8cYbMorToO8Q9vmIko6U1zfG9mIrsNUh
        0O4Re4u7+gKg0KVACgNU0MA=
X-Google-Smtp-Source: ABdhPJySRopc6D8cjWbN5dOODXhr+yFxY135naGBcaSEtMciSbhDcHNZIujJ7+2InVzSHdYHDYPZxA==
X-Received: by 2002:a37:b4d:: with SMTP id 74mr82504788qkl.477.1594650222717;
        Mon, 13 Jul 2020 07:23:42 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:482:92b:9d6d:2996:7c26:fb1d])
        by smtp.gmail.com with ESMTPSA id t48sm19896841qtb.50.2020.07.13.07.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:23:41 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     shawnguo@kernel.org
Cc:     linux-imx@nxp.com, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: imx6sx-sdb: Fix the phy-mode on fec2
Date:   Mon, 13 Jul 2020 11:23:24 -0300
Message-Id: <20200713142325.24601-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode") fixed the
phy-mode for fec1, but missed to fix it for the fec2 node.

Fix fec2 to also use "rgmii-id" as the phy-mode.

Cc: <stable@vger.kernel.org> 
Fixes: 0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/boot/dts/imx6sx-sdb.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6sx-sdb.dtsi b/arch/arm/boot/dts/imx6sx-sdb.dtsi
index 3e5fb72f21fc..c99aa273c296 100644
--- a/arch/arm/boot/dts/imx6sx-sdb.dtsi
+++ b/arch/arm/boot/dts/imx6sx-sdb.dtsi
@@ -213,7 +213,7 @@
 &fec2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet2>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&ethphy2>;
 	status = "okay";
 };
-- 
2.17.1

