Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5394922F0C2
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbgG0OZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732521AbgG0OZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:25:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D5EC207FC;
        Mon, 27 Jul 2020 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859951;
        bh=9eh4zjibUGsJrkBsVkA2O+Xz5FTZwE39Qzz12cZceuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbLX5FigjilCAp1vcII8PENv6fknCe5Y22n7rh8JlWNS3HIHkA2W1qtlAjZauQfEW
         +kP1IuT1MLyBIoU77Uxs6cwYcZ6Tx35+qB8sb0FI4C2vQ6IUYw0KfKxjnZrrtR0V5a
         ZkmUGE2w3Y6sfn1g/1R7GUEV7jO0vEJ7emGmoJEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Qiu Wenbo <qiuwenbo@phytium.com.cn>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 168/179] drm/amd/powerplay: fix a crash when overclocking Vega M
Date:   Mon, 27 Jul 2020 16:05:43 +0200
Message-Id: <20200727134940.845226365@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiu Wenbo <qiuwenbo@phytium.com.cn>

commit 88bb16ad998a0395fe4b346b7d3f621aaa0a2324 upstream.

Avoid kernel crash when vddci_control is SMU7_VOLTAGE_CONTROL_NONE and
vddci_voltage_table is empty. It has been tested on Intel Hades Canyon
(i7-8809G).

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=208489
Fixes: ac7822b0026f ("drm/amd/powerplay: add smumgr support for VEGAM (v2)")
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Qiu Wenbo <qiuwenbo@phytium.com.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c
@@ -642,9 +642,6 @@ static int vegam_get_dependency_volt_by_
 
 	/* sclk is bigger than max sclk in the dependence table */
 	*voltage |= (dep_table->entries[i - 1].vddc * VOLTAGE_SCALE) << VDDC_SHIFT;
-	vddci = phm_find_closest_vddci(&(data->vddci_voltage_table),
-			(dep_table->entries[i - 1].vddc -
-					(uint16_t)VDDC_VDDCI_DELTA));
 
 	if (SMU7_VOLTAGE_CONTROL_NONE == data->vddci_control)
 		*voltage |= (data->vbios_boot_state.vddci_bootup_value *
@@ -652,8 +649,13 @@ static int vegam_get_dependency_volt_by_
 	else if (dep_table->entries[i - 1].vddci)
 		*voltage |= (dep_table->entries[i - 1].vddci *
 				VOLTAGE_SCALE) << VDDC_SHIFT;
-	else
+	else {
+		vddci = phm_find_closest_vddci(&(data->vddci_voltage_table),
+				(dep_table->entries[i - 1].vddc -
+						(uint16_t)VDDC_VDDCI_DELTA));
+
 		*voltage |= (vddci * VOLTAGE_SCALE) << VDDCI_SHIFT;
+	}
 
 	if (SMU7_VOLTAGE_CONTROL_NONE == data->mvdd_control)
 		*mvdd = data->vbios_boot_state.mvdd_bootup_value * VOLTAGE_SCALE;


