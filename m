Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8BE408EB5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242009AbhIMNgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242136AbhIMNcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:32:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1B2C6137B;
        Mon, 13 Sep 2021 13:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539565;
        bh=1VXBVvNetuXlJk82OA7vs8pw7noTjRKAtVboEjdwNn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzGz31KKXavtVfmYG7yWlg2v4z+uaBMSOTPfAXh86lms/5H4aEIXOJCFD7Fqb0C78
         wJcb949uBlp+ds1pLV8QHCWIkerkXKrs40PLOqJUQ1ssmrh3SN4zpx+PDS+tNf5E90
         tuX0kbRB965D0ydr1/ogCsja8nH6WeQJzkPWLkwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/236] soc: rockchip: ROCKCHIP_GRF should not default to y, unconditionally
Date:   Mon, 13 Sep 2021 15:12:59 +0200
Message-Id: <20210913131102.878076888@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2a1c55d4762dd34a8b0f2e36fb01b7b16b60735b ]

Merely enabling CONFIG_COMPILE_TEST should not enable additional code.
To fix this, restrict the automatic enabling of ROCKCHIP_GRF to
ARCH_ROCKCHIP, and ask the user in case of compile-testing.

Fixes: 4c58063d4258f6be ("soc: rockchip: add driver handling grf setup")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210208143855.418374-1-geert+renesas@glider.be
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/rockchip/Kconfig b/drivers/soc/rockchip/Kconfig
index 2c13bf4dd5db..25eb2c1e31bb 100644
--- a/drivers/soc/rockchip/Kconfig
+++ b/drivers/soc/rockchip/Kconfig
@@ -6,8 +6,8 @@ if ARCH_ROCKCHIP || COMPILE_TEST
 #
 
 config ROCKCHIP_GRF
-	bool
-	default y
+	bool "Rockchip General Register Files support" if COMPILE_TEST
+	default y if ARCH_ROCKCHIP
 	help
 	  The General Register Files are a central component providing
 	  special additional settings registers for a lot of soc-components.
-- 
2.30.2



