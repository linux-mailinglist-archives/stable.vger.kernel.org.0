Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C9D37CCC2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhELQrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243531AbhELQl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DEC061CDB;
        Wed, 12 May 2021 16:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835472;
        bh=+fdpF4ceR9o7Lg5jDJOEU23yKQ0PnMiZJJ1nz2EbVf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnpwyzxEz5pxl7KlY1Glv1DzeLOmwaMZaJ+KoUDl0mndWUDubfrD/tS7vQJD4eSZB
         bZBVQkFjbTfS0Abvj8ujbiEg5eEd4fOeZ9sN5WtSp0XdKQfqUJ+oBAHT2M32uaER9s
         5b4LxEUTg6dacPUZqCbSNxPt0AoevDAJ4Xo+EOok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 358/677] power: supply: bq27xxx: fix sign of current_now for newer ICs
Date:   Wed, 12 May 2021 16:46:44 +0200
Message-Id: <20210512144849.219586070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit b67fdcb7099e9c640bad625c4dd6399debb3376a ]

Commit cd060b4d0868 ("power: supply: bq27xxx: fix polarity of current_now")
changed the sign of current_now for all bq27xxx variants, but on BQ28Z610
I'm now seeing negated values *with* that patch.

The GTA04/Openmoko device that was used for testing uses a BQ27000 or
BQ27010 IC, so I assume only the BQ27XXX_O_ZERO code path was incorrect.
Revert the behaviour for newer ICs.

Fixes: cd060b4d0868 "power: supply: bq27xxx: fix polarity of current_now"
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 0262109ac285..20e1dc8a87cf 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1804,7 +1804,7 @@ static int bq27xxx_battery_current(struct bq27xxx_device_info *di,
 		val->intval = curr * BQ27XXX_CURRENT_CONSTANT / BQ27XXX_RS;
 	} else {
 		/* Other gauges return signed value */
-		val->intval = -(int)((s16)curr) * 1000;
+		val->intval = (int)((s16)curr) * 1000;
 	}
 
 	return 0;
-- 
2.30.2



