Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7F49A4BA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369596AbiAYACN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574952AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB0CC0A54D8;
        Mon, 24 Jan 2022 13:32:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFC34614B4;
        Mon, 24 Jan 2022 21:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39C5C340E4;
        Mon, 24 Jan 2022 21:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059968;
        bh=VbmKCL72Oen/J1WzvyZ7/8kn5y0mhpkYsLrA1c3G/+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVuXuEasMtNxKDtdlRqxosHouSm+fwkiO3xa+d9Cbc0cx15F+aGZj11IUP4A9SXWC
         Ol8sLlArhao7vbUmJ4dZeJ0xyMqee5C8PhBPA4pMyoO++Xl6hnSNQgnW5Ew4KqXfMJ
         48v/r0aw6e51WXrAL7eFk13nPjURuj25mtNMCjnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Brezillon <bbrezillon@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jamie Iles <quic_jiles@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0794/1039] i3c: fix incorrect address slot lookup on 64-bit
Date:   Mon, 24 Jan 2022 19:43:03 +0100
Message-Id: <20220124184151.985072196@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit f18f98110f2b179792cb70d85cba697320a3790f ]

The address slot bitmap is an array of unsigned long's which are the
same size as an int on 32-bit platforms but not 64-bit.  Loading the
bitmap into an int could result in the incorrect status being returned
for a slot and slots being reported as the wrong status.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210922165600.179394-1-quic_jiles@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index c3b4c677b4429..dfe18dcd008d4 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -343,7 +343,8 @@ struct bus_type i3c_bus_type = {
 static enum i3c_addr_slot_status
 i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 {
-	int status, bitpos = addr * 2;
+	unsigned long status;
+	int bitpos = addr * 2;
 
 	if (addr > I2C_MAX_ADDR)
 		return I3C_ADDR_SLOT_RSVD;
-- 
2.34.1



