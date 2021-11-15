Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3E4451DDA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348407AbhKPAeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343903AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42E35633A0;
        Mon, 15 Nov 2021 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002078;
        bh=zhliUqB7AwUx2eOT56VImLysHnF9S+tfmfsRkohC4q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN2uHJtZ0KxsqwPrSQysyR5yhDR5TFHjjKq1yyRj/MwO7u9cCmZMuca6MG6lJNxhL
         82oPE3M9NFv0D3wXDSVTaiIRhVBAlMw7/VtAf41IIy9TaXSszuo32GBHk3kYmOuPzC
         rQBBS3r+H6TxiiTV6VZ92c46nqm6HXL8FmMczBwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-um@lists.infradead.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/917] net: tulip: winbond-840: fix build for UML
Date:   Mon, 15 Nov 2021 17:58:46 +0100
Message-Id: <20211115165443.402790629@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a3d708925fcca1a2f7219bc9ce93e6341f85c1e0 ]

On i386, when builtin (not a loadable module), the winbond-840 driver
inspects boot_cpu_data to see what CPU family it is running on, and
then acts on that data. The "family" struct member (x86) does not exist
when running on UML, so prevent that test and do the default action.

Prevents this build error on UML + i386:

../drivers/net/ethernet/dec/tulip/winbond-840.c: In function ‘init_registers’:
../drivers/net/ethernet/dec/tulip/winbond-840.c:882:19: error: ‘struct cpuinfo_um’ has no member named ‘x86’
  if (boot_cpu_data.x86 <= 4) {

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-um@lists.infradead.org
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://lore.kernel.org/r/20211014050606.7288-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/winbond-840.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 85b99099c6b94..5babcf05bc2f1 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -877,7 +877,7 @@ static void init_registers(struct net_device *dev)
 		8000	16 longwords		0200 2 longwords	2000 32 longwords
 		C000	32  longwords		0400 4 longwords */
 
-#if defined (__i386__) && !defined(MODULE)
+#if defined (__i386__) && !defined(MODULE) && !defined(CONFIG_UML)
 	/* When not a module we can work around broken '486 PCI boards. */
 	if (boot_cpu_data.x86 <= 4) {
 		i |= 0x4800;
-- 
2.33.0



