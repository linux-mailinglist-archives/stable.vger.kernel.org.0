Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FA232890F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbhCARtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:49:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238388AbhCARm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:42:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BD82650CB;
        Mon,  1 Mar 2021 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617839;
        bh=lwYos8p2K07C8z+UoCf8J8tCyygrMMfm7sO160A6EiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lg9JJjpm/goHDbazfxvj4b835TzXdWd53Vi8dWJEg6jYg7TkmbuZHGbNY8mr1GejX
         FZbdUwfkx/lsUtOZjUOXiR0fQYPmI4JuAUmRfzhcP5huJ4v2kaV/ObRsChHutyAhFN
         sAbmkRFPxBOeCnBnej7Oh+LdtbpIWvlirMfKLYUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/340] nvmem: core: skip child nodes not matching binding
Date:   Mon,  1 Mar 2021 17:12:38 +0100
Message-Id: <20210301161058.833895425@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 0445efacec75b85c2a3c176957ee050ba9be53f0 ]

The nvmem cell binding applies to all eeprom child nodes matching
"^.*@[0-9a-f]+$" without taking a compatible into account.

Linux drivers, like at24, are even more extensive and assume
_all_ at24 eeprom child nodes to be nvmem cells since e888d445ac33
("nvmem: resolve cells from DT at registration time").

Since df5f3b6f5357 ("dt-bindings: nvmem: stm32: new property for
data access"), the additionalProperties: True means it's Ok to have
other properties as long as they don't match "^.*@[0-9a-f]+$".

The barebox bootloader extends the MTD partitions binding to
EEPROM and can fix up following device tree node:

  &eeprom {
    partitions {
      compatible = "fixed-partitions";
    };
  };

This is allowed binding-wise, but drivers using nvmem_register()
like at24 will fail to parse because the function expects all child
nodes to have a reg property present. This results in the whole
EEPROM driver probe failing despite the device tree being correct.

Fix this by skipping nodes lacking a reg property instead of
returning an error. This effectively makes the drivers adhere
to the binding because all nodes with a unit address must have
a reg property and vice versa.

Fixes: e888d445ac33 ("nvmem: resolve cells from DT at registration time").
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210129171430.11328-6-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index acd82ff41951f..3ba68baeed1db 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -314,7 +314,9 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 
 	for_each_child_of_node(parent, child) {
 		addr = of_get_property(child, "reg", &len);
-		if (!addr || (len < 2 * sizeof(u32))) {
+		if (!addr)
+			continue;
+		if (len < 2 * sizeof(u32)) {
 			dev_err(dev, "nvmem: invalid reg on %pOF\n", child);
 			return -EINVAL;
 		}
-- 
2.27.0



