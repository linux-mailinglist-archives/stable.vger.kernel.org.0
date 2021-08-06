Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E30F3E250A
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243911AbhHFIQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243800AbhHFIPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5BA0611C6;
        Fri,  6 Aug 2021 08:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237733;
        bh=As6bvw8NATi8NkV1UwYAGMDuPYyWxXWl8+Dt7lXldyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDqhG518mFbGxbxO/4G0g7rppVKkvBU+NH1jcZnfMWI82iehBKncTpV+a/WP1m0Lx
         btOgO9ZsIhM00mcF82BIuY38KbCZtft4jpE0SFiawsE/0bKZ+LtbwHemn/ho8TMiEC
         Rdzj7kN48JQh/GE6FiIpnz2E/96XgqnKb/CHw7Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/11] regulator: rt5033: Fix n_voltages settings for BUCK and LDO
Date:   Fri,  6 Aug 2021 10:14:45 +0200
Message-Id: <20210806081110.594321647@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081110.511221879@linuxfoundation.org>
References: <20210806081110.511221879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit 6549c46af8551b346bcc0b9043f93848319acd5c ]

For linear regulators, the n_voltages should be (max - min) / step + 1.

Buck voltage from 1v to 3V, per step 100mV, and vout mask is 0x1f.
If value is from 20 to 31, the voltage will all be fixed to 3V.
And LDO also, just vout range is different from 1.2v to 3v, step is the
same. If value is from 18 to 31, the voltage will also be fixed to 3v.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/20210627080418.1718127-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/rt5033-private.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/rt5033-private.h b/include/linux/mfd/rt5033-private.h
index 1b63fc2f42d1..52d53d134f72 100644
--- a/include/linux/mfd/rt5033-private.h
+++ b/include/linux/mfd/rt5033-private.h
@@ -203,13 +203,13 @@ enum rt5033_reg {
 #define RT5033_REGULATOR_BUCK_VOLTAGE_MIN		1000000U
 #define RT5033_REGULATOR_BUCK_VOLTAGE_MAX		3000000U
 #define RT5033_REGULATOR_BUCK_VOLTAGE_STEP		100000U
-#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		32
+#define RT5033_REGULATOR_BUCK_VOLTAGE_STEP_NUM		21
 
 /* RT5033 regulator LDO output voltage uV */
 #define RT5033_REGULATOR_LDO_VOLTAGE_MIN		1200000U
 #define RT5033_REGULATOR_LDO_VOLTAGE_MAX		3000000U
 #define RT5033_REGULATOR_LDO_VOLTAGE_STEP		100000U
-#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		32
+#define RT5033_REGULATOR_LDO_VOLTAGE_STEP_NUM		19
 
 /* RT5033 regulator SAFE LDO output voltage uV */
 #define RT5033_REGULATOR_SAFE_LDO_VOLTAGE		4900000U
-- 
2.30.2



