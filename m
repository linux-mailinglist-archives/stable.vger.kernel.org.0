Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D24A145627
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgAVNVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729727AbgAVNVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:21:22 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 147DC205F4;
        Wed, 22 Jan 2020 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699281;
        bh=d8J1rWYqCKOvPSRzitqd/4NBLdFjcxJDpnPfWLXGoZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ao65z1uO9U3LXki1KIzAI1dPDoLiOSDKuM1pEMJD9jwquAZBMsZwcVU0rpLj9qpFF
         0N6J5kcvzCvT3dMxjMNBf0L67J38MjNxTa/FgaA6i4N32W++XA0O80OaKS0pKiETkT
         IbMiLZOTbnrsF7S56TwJ1h+5Zi4vM7kBYcrnE36I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 096/222] ARM: dts: imx6sll-evk: Remove incorrect power supply assignment
Date:   Wed, 22 Jan 2020 10:28:02 +0100
Message-Id: <20200122092840.615035986@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

commit 3479b2843c78ffb60247f522226ba68f93aee355 upstream.

The vdd3p0 LDO's input should be from external USB VBUS directly, NOT
PMIC's power supply, the vdd3p0 LDO's target output voltage can be
controlled by SW, and it requires input voltage to be high enough, with
incorrect power supply assigned, if the power supply's voltage is lower
than the LDO target output voltage, it will return fail and skip the LDO
voltage adjustment, so remove the power supply assignment for vdd3p0 to
avoid such scenario.

Fixes: 96a9169cf621 ("ARM: dts: imx6sll-evk: Assign corresponding power supply for vdd3p0")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6sll-evk.dts |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/arm/boot/dts/imx6sll-evk.dts
+++ b/arch/arm/boot/dts/imx6sll-evk.dts
@@ -265,10 +265,6 @@
 	status = "okay";
 };
 
-&reg_3p0 {
-	vin-supply = <&sw2_reg>;
-};
-
 &snvs_poweroff {
 	status = "okay";
 };


