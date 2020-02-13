Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927A315B88F
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 05:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgBMEZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 23:25:33 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45535 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729358AbgBMEZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 23:25:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 82FB9C8D;
        Wed, 12 Feb 2020 23:25:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 12 Feb 2020 23:25:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LYMHEL
        fJ/Mflvvvv9fv9o/T7sHtIDm1c87hLMCLOjxk=; b=LXtDonJKpDMs+etKmbjomd
        VAbQ8tVAUFOMsnvhbRMtjnhaVQhR1dX3E6HlbRCvoZ84HhfTTO0gZYdKzYRDeLzr
        RTkJbJHeWuy7r0Vb9UJxRk6/Bh0AQbJ027u4Fd4BoKKIwIUH10hoFyR/lwJA4yLf
        QNr02jWYTzPwkqY8HTWR94Kpk1PX7FLoO9s+joOxcao1SCDVkllFLTQsAJquQttq
        9dypeiUrNtRw8UI2+gf5U5rf78hMUAKxNUH2LaRBxvzShRljKRRzG/+cFgkQhMTj
        E3S0w68S8om8kEP5dtWDmPdM8XKeH+4FvbAYVBZmMhTqOOc8MZMIlSdB7oy0HZTA
        ==
X-ME-Sender: <xms:vM9EXh593xMbrr2-bCfGJcFAM2CFga8inrn4SzlF3cu0xgFtg7qoAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieejgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvtdelrdefjedrleejrd
    duleegnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vM9EXmq9A4XhaXb4l_n7qDPxBBiTE48IIJBoi1ptTlinLl58ZDZxWg>
    <xmx:vM9EXrhd3vJIl2XyIrYKmLR63RCtwj3xVxGKsF56lXhs2xho7KfA_A>
    <xmx:vM9EXoK4EjGw379Ux8uyoeOe2HiDhNhvtc3A_wWZJXQN6_Dzfj28Cg>
    <xmx:vM9EXozTqoZC_qNVDFMRNJfTi7SBvUf8t9o35m6EetDCIYu4B2Stag>
Received: from localhost (unknown [209.37.97.194])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2D0F3060B16;
        Wed, 12 Feb 2020 23:25:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] regmap: fix writes to non incrementing registers" failed to apply to 4.19-stable tree
To:     ben.whitten@gmail.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 20:25:31 -0800
Message-ID: <1581567931200128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e31aab08bad0d4ee3d3d890a7b74cb6293e0a41 Mon Sep 17 00:00:00 2001
From: Ben Whitten <ben.whitten@gmail.com>
Date: Sat, 18 Jan 2020 20:56:24 +0000
Subject: [PATCH] regmap: fix writes to non incrementing registers

When checking if a register block is writable we must ensure that the
block does not start with or contain a non incrementing register.

Fixes: 8b9f9d4dc511 ("regmap: verify if register is writeable before writing operations")
Signed-off-by: Ben Whitten <ben.whitten@gmail.com>
Link: https://lore.kernel.org/r/20200118205625.14532-1-ben.whitten@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 19f57ccfbe1d..59f911e57719 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1488,11 +1488,18 @@ static int _regmap_raw_write_impl(struct regmap *map, unsigned int reg,
 
 	WARN_ON(!map->bus);
 
-	/* Check for unwritable registers before we start */
-	for (i = 0; i < val_len / map->format.val_bytes; i++)
-		if (!regmap_writeable(map,
-				     reg + regmap_get_offset(map, i)))
-			return -EINVAL;
+	/* Check for unwritable or noinc registers in range
+	 * before we start
+	 */
+	if (!regmap_writeable_noinc(map, reg)) {
+		for (i = 0; i < val_len / map->format.val_bytes; i++) {
+			unsigned int element =
+				reg + regmap_get_offset(map, i);
+			if (!regmap_writeable(map, element) ||
+				regmap_writeable_noinc(map, element))
+				return -EINVAL;
+		}
+	}
 
 	if (!map->cache_bypass && map->format.parse_val) {
 		unsigned int ival;

