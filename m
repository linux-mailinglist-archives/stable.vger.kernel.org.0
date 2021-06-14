Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859D93A6243
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhFNK6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233934AbhFNK4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A074261206;
        Mon, 14 Jun 2021 10:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667259;
        bh=xE4zS2vv7KNhhWgDhMlfTpZX94wdbK0NNqMY56tsSJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYX+p6asvCpHA8DPYJ1m8FhBbspB7h9+eFPyhnJRKQcRHCCyD+Zl5JhNmt0H9AYx1
         OUvOYMVYLrFx4KYpr46NqiUHoL/Q7Lw8kOxLyx1XvX6JkEi+ZQSo5F3dHpvVgRwK07
         l7IHx5lqiYGNhQaax/MuC6NzPFU8uRLpiGgVK4j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 62/84] regulator: core: resolve supply for boot-on/always-on regulators
Date:   Mon, 14 Jun 2021 12:27:40 +0200
Message-Id: <20210614102648.490314334@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
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
@@ -1381,6 +1381,12 @@ static int set_machine_constraints(struc
 	 * and we have control then make sure it is enabled.
 	 */
 	if (rdev->constraints->always_on || rdev->constraints->boot_on) {
+		/* If we want to enable this regulator, make sure that we know
+		 * the supplying regulator.
+		 */
+		if (rdev->supply_name && !rdev->supply)
+			return -EPROBE_DEFER;
+
 		if (rdev->supply) {
 			ret = regulator_enable(rdev->supply);
 			if (ret < 0) {


