Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE114290B0
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241351AbhJKOL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242604AbhJKOI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 955D6610CB;
        Mon, 11 Oct 2021 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960905;
        bh=glTIL5mdE2H2koV2VGyi3tdL656rc4nF1RcwPR5SD94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kw8BEf/jFWpRijba6ziE4whYgtcNA/b8agCNff6Eya+jH4+194Z+62trsbUSqcbf5
         wZrSFfKZhZ0MJJIfJEm/0wmbIAm4PC100jxsaz09MDgG+gFcMRj8Bno3VEyN3BwevS
         9BIQbGKGABGu7l5+M5E83K6DgNR10o5mIQAFQzhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 076/151] ARM: dts: imx: change the spi-nor tx
Date:   Mon, 11 Oct 2021 15:45:48 +0200
Message-Id: <20211011134520.305205609@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit b2a4f4a302b83976ad0d2930abe0f38e6119a144 ]

Before commit 0e30f47232ab5 ("mtd: spi-nor: add support for DTR protocol"),
for all PP command, it only support 1-1-1 mode, no matter the tx setting
in dts. But after the upper commit, the logic change. It will choose
the best mode(fastest mode) which flash device and spi-nor host controller
both support.

Though the spi-nor device on imx6sx-sdb/imx6ul(l/z)-14x14-evk board
do not support PP-1-4-4/PP-1-1-4, but if tx is 4 in dts file, it will also
impact the read mode selection. For the spi-nor device on the upper mentioned
boards, they support read 1-4-4 mode and read 1-1-4 mode according to the
device internal sfdp register. But qspi host controller do not support
read 1-4-4 mode. so need to set the tx to 1, let the common code finally
select read 1-1-4 mode, PP-1-1-1 mode.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx-sdb.dts        | 4 ++--
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6sx-sdb.dts b/arch/arm/boot/dts/imx6sx-sdb.dts
index 5a63ca615722..99f4cf777a38 100644
--- a/arch/arm/boot/dts/imx6sx-sdb.dts
+++ b/arch/arm/boot/dts/imx6sx-sdb.dts
@@ -114,7 +114,7 @@
 		compatible = "micron,n25q256a", "jedec,spi-nor";
 		spi-max-frequency = <29000000>;
 		spi-rx-bus-width = <4>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		reg = <0>;
 	};
 
@@ -124,7 +124,7 @@
 		compatible = "micron,n25q256a", "jedec,spi-nor";
 		spi-max-frequency = <29000000>;
 		spi-rx-bus-width = <4>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		reg = <2>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
index 779cc536566d..a3fde3316c73 100644
--- a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
+++ b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
@@ -292,7 +292,7 @@
 		compatible = "micron,n25q256a", "jedec,spi-nor";
 		spi-max-frequency = <29000000>;
 		spi-rx-bus-width = <4>;
-		spi-tx-bus-width = <4>;
+		spi-tx-bus-width = <1>;
 		reg = <0>;
 	};
 };
-- 
2.33.0



