Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DC8378850
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbhEJLVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236945AbhEJLLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0DF461480;
        Mon, 10 May 2021 11:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644764;
        bh=bQ7AmMdRn7mYiE/saM800U+456oaDM2QE8GEDbyb8UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fTIfk+dV231dnFFVNvkZSroNEKuv5XFsRVjPUQpns4indXfJqTEVgugAMMNeufX/
         43P7tSph8amZweAaI0z/CUhKl/4Z8OO71rmqoma/Y1zo8RytS2lzxpjJpio3s5TjHq
         yV6SJnMcXG+jVnx53Oab83+wxAotFReVoij4qMHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 214/384] power: supply: cpcap-charger: fix small mistake in current to register conversion
Date:   Mon, 10 May 2021 12:20:03 +0200
Message-Id: <20210510102021.944007993@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Philipp Klemm <philipp@uvos.xyz>

[ Upstream commit 8a5a0cc13aa927eac7a9eb3ca82dfc1f82cfc28d ]

Signed-off-by: Carl Philipp Klemm <philipp@uvos.xyz>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/cpcap-charger.c b/drivers/power/supply/cpcap-charger.c
index 641dcad1133f..3f06eb826ac2 100644
--- a/drivers/power/supply/cpcap-charger.c
+++ b/drivers/power/supply/cpcap-charger.c
@@ -318,7 +318,7 @@ static int cpcap_charger_current_to_regval(int microamp)
 		return CPCAP_REG_CRM_ICHRG(0x0);
 	if (miliamp < 177)
 		return CPCAP_REG_CRM_ICHRG(0x1);
-	if (miliamp > 1596)
+	if (miliamp >= 1596)
 		return CPCAP_REG_CRM_ICHRG(0xe);
 
 	res = microamp / 88666;
-- 
2.30.2



