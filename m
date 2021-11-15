Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D3D4510DE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243278AbhKOSzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243237AbhKOSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7FDC6347C;
        Mon, 15 Nov 2021 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999850;
        bh=/Ahj1tKPRMFXqLpcC/UoHU3H1Nf7bUb9cHxIfLYN9aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGt2rRwOA9vJ6rYHE4cmgIBqojvuMVsPW1nWpaslSTos1/GPtIsrEf5ABMWky3MH/
         agBUSoW1597m/dXtEtam2IHvzcUle5Tm31nqjc0uhgN63Cw4V6HQH+uZdMmlZ1BA05
         fXgJI3UWqmWfZB5wVERnuaSIbJjyFmSNecXUeo2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 446/849] ACPI: PM: Turn off unused wakeup power resources
Date:   Mon, 15 Nov 2021 17:58:49 +0100
Message-Id: <20211115165435.370379193@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 7a63296d6f579a02b2675b4b0fe5b1cd3235e8d3 ]

If an ACPI power resource is found to be "on" during the
initialization of the list of wakeup power resources of a device,
it is reference counted and its wakeup_enabled flag is set, which is
problematic if the deivce in question is the only user of the given
power resource, it is never runtime-suspended and it is not allowed
to wake up the system from sleep, because in that case the given
power resource will stay "on" until the system reboots and energy
will be wasted.

It is better to simply turn off wakeup power resources that are "on"
during the initialization unless their reference counters are not
zero, because that may be the only opportunity to prevent them from
staying in the "on" state all the time.

Fixes: b5d667eb392e ("ACPI / PM: Take unusual configurations of power resources into account")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index eba7785047cad..dfe760bd7157f 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -606,20 +606,19 @@ int acpi_power_wakeup_list_init(struct list_head *list, int *system_level_p)
 
 	list_for_each_entry(entry, list, node) {
 		struct acpi_power_resource *resource = entry->resource;
-		int result;
 		u8 state;
 
 		mutex_lock(&resource->resource_lock);
 
-		result = acpi_power_get_state(resource, &state);
-		if (result) {
-			mutex_unlock(&resource->resource_lock);
-			return result;
-		}
-		if (state == ACPI_POWER_RESOURCE_STATE_ON) {
-			resource->ref_count++;
-			resource->wakeup_enabled = true;
-		}
+		/*
+		 * Make sure that the power resource state and its reference
+		 * counter value are consistent with each other.
+		 */
+		if (!resource->ref_count &&
+		    !acpi_power_get_state(resource, &state) &&
+		    state == ACPI_POWER_RESOURCE_STATE_ON)
+			__acpi_power_off(resource);
+
 		if (system_level > resource->system_level)
 			system_level = resource->system_level;
 
-- 
2.33.0



