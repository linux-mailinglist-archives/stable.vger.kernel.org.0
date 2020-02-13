Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6F815C21E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387820AbgBMP3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387816AbgBMP3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:19 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E8120661;
        Thu, 13 Feb 2020 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607758;
        bh=MRdGMjutinYGYiS4uueb/cSnR9n8EX3kqsC1u8p/7kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5xr+bVVujLykqWcovDl+DxtQL8fhnDf6RpuTQxdWd59fmBeMBP6odGFiNTRAeiuN
         4083shu71IKafkpm//flKDLuw+9aOURM0o7bk5JnyoxmsnEc+WW+SQYMxZYG8okGba
         C80X0mR49EMoXlrKc6zMqWQJTwwgsflvuDUumlAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Whitten <ben.whitten@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 113/120] regmap: fix writes to non incrementing registers
Date:   Thu, 13 Feb 2020 07:21:49 -0800
Message-Id: <20200213151938.323355614@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Whitten <ben.whitten@gmail.com>

commit 2e31aab08bad0d4ee3d3d890a7b74cb6293e0a41 upstream.

When checking if a register block is writable we must ensure that the
block does not start with or contain a non incrementing register.

Fixes: 8b9f9d4dc511 ("regmap: verify if register is writeable before writing operations")
Signed-off-by: Ben Whitten <ben.whitten@gmail.com>
Link: https://lore.kernel.org/r/20200118205625.14532-1-ben.whitten@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1488,11 +1488,18 @@ static int _regmap_raw_write_impl(struct
 
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


