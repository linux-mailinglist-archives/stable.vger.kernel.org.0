Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEB4353E7E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbhDEJG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237887AbhDEJF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:05:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15A0161394;
        Mon,  5 Apr 2021 09:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613551;
        bh=35/dROHV2ANHJel4dRyq7Yb8FcwXvHaen4nqbCzvkjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIa1iXbcC7ylqArAFak56/RqhIvA+IKadVgEioBV3fU8Fz5DVTVg8rrKmazcrS8ew
         9Rd89g2GlokBLvZX5HTM9zBy9ON7blx055arvcmzy9sHy+CzIKJZwSuunWIIfzIZOy
         YwAjGddTHlyK7jEMNsLphmdO3CIqJdbDki9ZNigU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 54/74] drm/tegra: sor: Grab runtime PM reference across reset
Date:   Mon,  5 Apr 2021 10:54:18 +0200
Message-Id: <20210405085026.492199861@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit ac097aecfef0bb289ca53d2fe0b73fc7e1612a05 upstream.

The SOR resets are exclusively shared with the SOR power domain. This
means that exclusive access can only be granted temporarily and in order
for that to work, a rigorous sequence must be observed. To ensure that a
single consumer gets exclusive access to a reset, each consumer must
implement a rigorous protocol using the reset_control_acquire() and
reset_control_release() functions.

However, these functions alone don't provide any guarantees at the
system level. Drivers need to ensure that the only a single consumer has
access to the reset at the same time. In order for the SOR to be able to
exclusively access its reset, it must therefore ensure that the SOR
power domain is not powered off by holding on to a runtime PM reference
to that power domain across the reset assert/deassert operation.

This used to work fine by accident, but was revealed when recently more
devices started to rely on the SOR power domain.

Fixes: 11c632e1cfd3 ("drm/tegra: sor: Implement acquire/release for reset")
Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/sor.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -2871,6 +2871,12 @@ static int tegra_sor_init(struct host1x_
 	 * kernel is possible.
 	 */
 	if (sor->rst) {
+		err = pm_runtime_resume_and_get(sor->dev);
+		if (err < 0) {
+			dev_err(sor->dev, "failed to get runtime PM: %d\n", err);
+			return err;
+		}
+
 		err = reset_control_acquire(sor->rst);
 		if (err < 0) {
 			dev_err(sor->dev, "failed to acquire SOR reset: %d\n",
@@ -2904,6 +2910,7 @@ static int tegra_sor_init(struct host1x_
 		}
 
 		reset_control_release(sor->rst);
+		pm_runtime_put(sor->dev);
 	}
 
 	err = clk_prepare_enable(sor->clk_safe);


