Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ED23A6438
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhFNLVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235943AbhFNLTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2A6A61469;
        Mon, 14 Jun 2021 10:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667891;
        bh=Pfz7gHmAyftGm2ZvBohtaZWXRcMzA32LMywpLREbVHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO53z21oTmHa9/PUtct5dRiubsvO7XV416QouMXQZBNApZF/sk8NAbEm6In+gITlW
         ex3pqGb/Z0/MkWuFKuDJrEhP/2DqSjdZWNZI79bMVZcrT5nYo9BTMIxTyI557QQIa3
         Jk34LVYmpopA80HWWzXkKTxIMZEeoIh+AXA3mdbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 115/173] regulator: bd718x7: Fix the BUCK7 voltage setting on BD71837
Date:   Mon, 14 Jun 2021 12:27:27 +0200
Message-Id: <20210614102701.995347306@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

commit bc537e65b09a05923f98a31920d1ab170e648dba upstream.

Changing the BD71837 voltages for other regulators except the first 4 BUCKs
should be forbidden when the regulator is enabled. There may be out-of-spec
voltage spikes if the voltage of these "non DVS" bucks is changed when
enabled. This restriction was accidentally removed when the LDO voltage
change was allowed for BD71847. (It was not noticed that the BD71837
BUCK7 used same voltage setting function as LDOs).

Additionally this bug causes incorrect voltage monitoring register access.
The voltage change function accidentally used for bd71837 BUCK7 is
intended to only handle LDO voltage changes. A BD71847 LDO specific
voltage monitoring disabling code gets executed on BD71837 and register
offsets are wrongly calculated as regulator is assumed to be an LDO.

Prevent the BD71837 BUCK7 voltage change when BUCK7 is enabled by using
the correct voltage setting operation.

Fixes: 9bcbabafa19b ("regulator: bd718x7: remove voltage change restriction from BD71847 LDOs")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/bd8c00931421fafa57e3fdf46557a83075b7cc17.1622610103.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/bd718x7-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/bd718x7-regulator.c
+++ b/drivers/regulator/bd718x7-regulator.c
@@ -364,7 +364,7 @@ BD718XX_OPS(bd71837_buck_regulator_ops,
 	    NULL);
 
 BD718XX_OPS(bd71837_buck_regulator_nolinear_ops, regulator_list_voltage_table,
-	    regulator_map_voltage_ascend, bd718xx_set_voltage_sel_restricted,
+	    regulator_map_voltage_ascend, bd71837_set_voltage_sel_restricted,
 	    regulator_get_voltage_sel_regmap, regulator_set_voltage_time_sel,
 	    NULL);
 /*


