Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B0631367E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhBHPLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233186AbhBHPHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:07:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6110C64EA1;
        Mon,  8 Feb 2021 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796752;
        bh=sHXS6TOO/5/IN7vA2YFWR23HH9O/b+yJy8srQQqTtqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=az/gQFecLBbSQI02yL6+ojXZAfx9oUEwFjLn9EUCI2lEj44NpdHJ1o8kYjbVy4Ej/
         Wb/HQSh0c8ayubcDjgxm84cgJsUMCEPme3hznlnmN44twqNMLFKQPEh/TkTVPpBi9i
         utOCu6R/Dsv1h8x76XRhXA7TnR6csZAS7385thJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 22/43] Input: i8042 - unbreak Pegatron C15B
Date:   Mon,  8 Feb 2021 16:00:48 +0100
Message-Id: <20210208145807.213658507@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
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
index fa07be0b4500e..2317f8d3fef6f 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -223,6 +223,8 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
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



