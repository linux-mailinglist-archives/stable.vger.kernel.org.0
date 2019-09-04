Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D79A8EDC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388392AbfIDSA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388069AbfIDSA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:00:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 652B322CEA;
        Wed,  4 Sep 2019 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620025;
        bh=r2xUOvblUymXMgpxpFPYP2zYelsxZS8P9XezoZwu+yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htSEAeF51YU7ikQ0NnGF3M4F1iX+ENZSiKkpoSi+huKlcVYpub993pX2pxD5K6H14
         kQD2n5zstf3wDT69JOcJFhs9xmErjGezKwpPj9dkEd0qOh3/VZH9oxdbQ0GnUPMaSQ
         UnlxCYbrDmZFN9RBaiGLs9huorNtdFRQkLhnkCmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 46/83] dmaengine: ste_dma40: fix unneeded variable warning
Date:   Wed,  4 Sep 2019 19:53:38 +0200
Message-Id: <20190904175307.831982354@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 8684d11b29bba..68b41daab3a8f 100644
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



