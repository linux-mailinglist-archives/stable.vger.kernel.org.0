Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC60131378B
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhBHP1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:27:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233650AbhBHPTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB21E64EE7;
        Mon,  8 Feb 2021 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797167;
        bh=3ANMq33b8vacAFg3zCGY2KT+cVJ1oVZO85hq+d2eiBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuGMnyQjNEUiDnD0l313UFiqfGBRfAoICPVNO1PzeMYPzKOheIzkBpShM6GS2K7Qh
         zb1ddjBcR6w+cjbQXMZnNykgNyXjF/eIoq/POHLE2aQ3bImJjMuEdmE4wpsWZ2jLEm
         vNClYf7Vip2bJHllR8nl92Mf2oax/YsdH5vHZe14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/120] Input: i8042 - unbreak Pegatron C15B
Date:   Mon,  8 Feb 2021 16:00:03 +0100
Message-Id: <20210208145819.040638869@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit a3a9060ecad030e2c7903b2b258383d2c716b56c ]

g++ reports

	drivers/input/serio/i8042-x86ia64io.h:225:3: error: ‘.matches’ designator used multiple times in the same initializer list

C99 semantics is that last duplicated initialiser wins,
so DMI entry gets overwritten.

Fixes: a48491c65b51 ("Input: i8042 - add ByteSpeed touchpad to noloop table")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Link: https://lore.kernel.org/r/20201228072335.GA27766@localhost.localdomain
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 3a2dcf0805f12..c74b020796a94 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -219,6 +219,8 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "PEGATRON CORPORATION"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "C15B"),
 		},
+	},
+	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ByteSpeed LLC"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "ByteSpeed Laptop C15B"),
-- 
2.27.0



