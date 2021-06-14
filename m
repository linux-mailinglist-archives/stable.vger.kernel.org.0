Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0951C3A6091
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhFNKfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhFNKeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95FBA611C0;
        Mon, 14 Jun 2021 10:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666707;
        bh=uH7X4E4uXYwz4moQg9ZSqhZ98whTmhNzkyKbhStAGOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUFmhdmiXwRRKjRDoUwgEb41zURV8fKSOAzq1hbKiXOgf12sKMp5ZyYJEiUaGjoSe
         obG9w4BxzUQ4wKwKAKH8wuklMIoGjbPSiSUWQJVR9LpavvDNLzT0IqZaMjHJtESddZ
         pl2IjHa//hsiqVffAiyW19ePAP63X2g7xNNdCQ2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 33/42] regulator: core: resolve supply for boot-on/always-on regulators
Date:   Mon, 14 Jun 2021 12:27:24 +0200
Message-Id: <20210614102643.758079144@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 98e48cd9283dbac0e1445ee780889f10b3d1db6a upstream.

For the boot-on/always-on regulators the set_machine_constrainst() is
called before resolving rdev->supply. Thus the code would try to enable
rdev before enabling supplying regulator. Enforce resolving supply
regulator before enabling rdev.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210519221224.2868496-1-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1080,6 +1080,12 @@ static int set_machine_constraints(struc
 	 * and we have control then make sure it is enabled.
 	 */
 	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
+		/* If we want to enable this regulator, make sure that we know
+		 * the supplying regulator.
+		 */
+		if (rdev->supply_name && !rdev->supply)
+			return -EPROBE_DEFER;
+
 		ret = _regulator_do_enable(rdev);
 		if (ret < 0 && ret != -EINVAL) {
 			rdev_err(rdev, "failed to enable\n");


