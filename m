Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CA045C460
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353912AbhKXNrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:47:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351346AbhKXNpr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:45:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC8763328;
        Wed, 24 Nov 2021 13:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758855;
        bh=P9O2jdSgjjfZ5fE7hCFmSzrAAHSVwjLIsi3X2AsJFBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHghSUHCDk4xdmDkD2HOb/bQAu4hLbbu5PbKVFYO7QIJ+vqCVfka+7DwprogDFGeP
         SR98O7jTMqrJX/4SuKTpJvw7gO4mdTjPcLwyqVnyjqQu1/AZevxxNXSOlxeCZ7c67o
         FcqHpsHbJHwfdxQVfsb7gpMW5QSu5LEH6oQ6HSc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/279] bus: ti-sysc: Use context lost quirk for otg
Date:   Wed, 24 Nov 2021 12:55:06 +0100
Message-Id: <20211124115719.412828382@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9067839ff45a528bcb015cc2f24f656126b91e3f ]

Let's use SYSC_QUIRK_REINIT_ON_CTX_LOST quirk for am335x otg instead of
SYSC_QUIRK_REINIT_ON_RESUME quirk as we can now handle the context loss
in a more generic way.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 7c645754a82b1..bb377bb13564a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1567,7 +1567,7 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   0xffffffff, SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY),
 	SYSC_QUIRK("usb_otg_hs", 0, 0, 0x10, -ENODEV, 0x4ea2080d, 0xffffffff,
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY |
-		   SYSC_QUIRK_REINIT_ON_RESUME),
+		   SYSC_QUIRK_REINIT_ON_CTX_LOST),
 	SYSC_QUIRK("wdt", 0, 0, 0x10, 0x14, 0x502a0500, 0xfffff0f0,
 		   SYSC_MODULE_QUIRK_WDT),
 	/* PRUSS on am3, am4 and am5 */
-- 
2.33.0



