Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256E269774
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbfGONzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732043AbfGONyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:54:53 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D09B42081C;
        Mon, 15 Jul 2019 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198891;
        bh=5/M9/vcs/yaJ+rSk97Wt73wlP2NREFP4DiFcpbDHYkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ag2Fg7HYC5mDqPgCWPiUHlLv5CKbSA+7p/D3q4B+mMs0AMW7JocAtUpZkfAUYJOuP
         Kh1fxe0zUQk4CwjCBVoIQahY8/xMfZRZAqqlfHk4gZ4x5nkdRtDiLCA2IzgrdahmFn
         cT2U9LBJptwCeQYqmOulTOzc3+hhLPfqur19WBOI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Furquan Shaikh <furquan@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.2 130/249] ACPICA: Clear status of GPEs on first direct enable
Date:   Mon, 15 Jul 2019 09:44:55 -0400
Message-Id: <20190715134655.4076-130-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 44758bafa53602f2581a6857bb20b55d4d8ad5b2 ]

ACPI GPEs (other than the EC one) can be enabled in two situations.
First, the GPEs with existing _Lxx and _Exx methods are enabled
implicitly by ACPICA during system initialization.  Second, the
GPEs without these methods (like GPEs listed by _PRW objects for
wakeup devices) need to be enabled directly by the code that is
going to use them (e.g. ACPI power management or device drivers).

In the former case, if the status of a given GPE is set to start
with, its handler method (either _Lxx or _Exx) needs to be invoked
to take care of the events (possibly) signaled before the GPE was
enabled.  In the latter case, however, the first caller of
acpi_enable_gpe() for a given GPE should not be expected to care
about any events that might be signaled through it earlier.  In
that case, it is better to clear the status of the GPE before
enabling it, to prevent stale events from triggering unwanted
actions (like spurious system resume, for example).

For this reason, modify acpi_ev_add_gpe_reference() to take an
additional boolean argument indicating whether or not the GPE
status needs to be cleared when its reference counter changes from
zero to one and make acpi_enable_gpe() pass TRUE to it through
that new argument.

Fixes: 18996f2db918 ("ACPICA: Events: Stop unconditionally clearing ACPI IRQs during suspend/resume")
Reported-by: Furquan Shaikh <furquan@google.com>
Tested-by: Furquan Shaikh <furquan@google.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/acevents.h | 3 ++-
 drivers/acpi/acpica/evgpe.c    | 8 +++++++-
 drivers/acpi/acpica/evgpeblk.c | 2 +-
 drivers/acpi/acpica/evxface.c  | 2 +-
 drivers/acpi/acpica/evxfgpe.c  | 2 +-
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
index 831660179662..c8652f91054e 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -69,7 +69,8 @@ acpi_status
 acpi_ev_mask_gpe(struct acpi_gpe_event_info *gpe_event_info, u8 is_masked);
 
 acpi_status
-acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info);
+acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info,
+			  u8 clear_on_enable);
 
 acpi_status
 acpi_ev_remove_gpe_reference(struct acpi_gpe_event_info *gpe_event_info);
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 62d3aa74277b..344feba29063 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -146,6 +146,7 @@ acpi_ev_mask_gpe(struct acpi_gpe_event_info *gpe_event_info, u8 is_masked)
  * FUNCTION:    acpi_ev_add_gpe_reference
  *
  * PARAMETERS:  gpe_event_info          - Add a reference to this GPE
+ *              clear_on_enable         - Clear GPE status before enabling it
  *
  * RETURN:      Status
  *
@@ -155,7 +156,8 @@ acpi_ev_mask_gpe(struct acpi_gpe_event_info *gpe_event_info, u8 is_masked)
  ******************************************************************************/
 
 acpi_status
-acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info)
+acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info,
+			  u8 clear_on_enable)
 {
 	acpi_status status = AE_OK;
 
@@ -170,6 +172,10 @@ acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info)
 
 		/* Enable on first reference */
 
+		if (clear_on_enable) {
+			(void)acpi_hw_clear_gpe(gpe_event_info);
+		}
+
 		status = acpi_ev_update_gpe_enable_mask(gpe_event_info);
 		if (ACPI_SUCCESS(status)) {
 			status = acpi_ev_enable_gpe(gpe_event_info);
diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.c
index 328d1d6123ad..fb15e9e2373b 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -453,7 +453,7 @@ acpi_ev_initialize_gpe_block(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 				continue;
 			}
 
-			status = acpi_ev_add_gpe_reference(gpe_event_info);
+			status = acpi_ev_add_gpe_reference(gpe_event_info, FALSE);
 			if (ACPI_FAILURE(status)) {
 				ACPI_EXCEPTION((AE_INFO, status,
 					"Could not enable GPE 0x%02X",
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index 3df00eb6621b..279ef0557aa3 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -971,7 +971,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 	      ACPI_GPE_DISPATCH_METHOD) ||
 	     (ACPI_GPE_DISPATCH_TYPE(handler->original_flags) ==
 	      ACPI_GPE_DISPATCH_NOTIFY)) && handler->originally_enabled) {
-		(void)acpi_ev_add_gpe_reference(gpe_event_info);
+		(void)acpi_ev_add_gpe_reference(gpe_event_info, FALSE);
 		if (ACPI_GPE_IS_POLLING_NEEDED(gpe_event_info)) {
 
 			/* Poll edge triggered GPEs to handle existing events */
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index 30a083902f52..710488ec59e9 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -108,7 +108,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
 	if (gpe_event_info) {
 		if (ACPI_GPE_DISPATCH_TYPE(gpe_event_info->flags) !=
 		    ACPI_GPE_DISPATCH_NONE) {
-			status = acpi_ev_add_gpe_reference(gpe_event_info);
+			status = acpi_ev_add_gpe_reference(gpe_event_info, TRUE);
 			if (ACPI_SUCCESS(status) &&
 			    ACPI_GPE_IS_POLLING_NEEDED(gpe_event_info)) {
 
-- 
2.20.1

