Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132699618D
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfHTNkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbfHTNkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:31 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD3AF22DA7;
        Tue, 20 Aug 2019 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308430;
        bh=hgkOPfKjMvWQBQoEjBhfr9goeLyBIMk+msv7dPAv4Dg=;
        h=From:To:Cc:Subject:Date:From;
        b=W3iW70mOKtRJxXKHyLFfdRea75CNSLHBxwdh+5SOAFE2iuIWUM9FbT39tRC1q28zb
         4Z2TAIUYChlpnFiYWQao4/NlLnFv47gRyEpO91mOkv7lgyJktyK/x4qO5NiyG0IVEs
         8Rb6OBBTsxYNzFoJWXbZUWb8vCpSzVJ/8kwntl1I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.2 01/44] dmaengine: ste_dma40: fix unneeded variable warning
Date:   Tue, 20 Aug 2019 09:39:45 -0400
Message-Id: <20190820134028.10829-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5d6fb560729a5d5554e23db8d00eb57cd0021083 ]

clang-9 points out that there are two variables that depending on the
configuration may only be used in an ARRAY_SIZE() expression but not
referenced:

drivers/dma/ste_dma40.c:145:12: error: variable 'd40_backup_regs' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
static u32 d40_backup_regs[] = {
           ^
drivers/dma/ste_dma40.c:214:12: error: variable 'd40_backup_regs_chan' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
static u32 d40_backup_regs_chan[] = {

Mark these __maybe_unused to shut up the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20190712091357.744515-1-arnd@arndb.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 89d710899010d..de8bfd9a76e9e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -142,7 +142,7 @@ enum d40_events {
  * when the DMA hw is powered off.
  * TODO: Add save/restore of D40_DREG_GCC on dma40 v3 or later, if that works.
  */
-static u32 d40_backup_regs[] = {
+static __maybe_unused u32 d40_backup_regs[] = {
 	D40_DREG_LCPA,
 	D40_DREG_LCLA,
 	D40_DREG_PRMSE,
@@ -211,7 +211,7 @@ static u32 d40_backup_regs_v4b[] = {
 
 #define BACKUP_REGS_SZ_V4B ARRAY_SIZE(d40_backup_regs_v4b)
 
-static u32 d40_backup_regs_chan[] = {
+static __maybe_unused u32 d40_backup_regs_chan[] = {
 	D40_CHAN_REG_SSCFG,
 	D40_CHAN_REG_SSELT,
 	D40_CHAN_REG_SSPTR,
-- 
2.20.1

