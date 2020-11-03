Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EAE2A5707
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbgKCVdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731286AbgKCU47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20982053B;
        Tue,  3 Nov 2020 20:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437018;
        bh=FYnfaWj9hIFTq7lxbQiNo5DLprayYMNENJGzvwrpY2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNQ1fUudDkH9JQSp57JY3K7k0jT/NU1EV/FbsETE4d0FnPU+mHUgq11V0gWvH7kFy
         BiTAkDssYBL6GSkA8PHLe0QwTdPk74G+O+jhRsnTjIjHlYe5EamJftbO1gHrBYxyoK
         7Ue+9hU8eIWqlVxjkh7LO5TTxzK2OgPUYfJTE3Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 110/214] ACPI: button: fix handling lid state changes when input device closed
Date:   Tue,  3 Nov 2020 21:35:58 +0100
Message-Id: <20201103203301.231200104@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dmitry.torokhov@gmail.com <dmitry.torokhov@gmail.com>

commit 21988a8e51479ceffe7b0568b170effabb708dfe upstream.

The original intent of 84d3f6b76447 was to delay evaluating lid state until
all drivers have been loaded, with input device being opened from userspace
serving as a signal for this condition. Let's ensure that state updates
happen even if userspace closed (or in the future inhibited) input device.

Note that if we go through suspend/resume cycle we assume the system has
been fully initialized even if LID input device has not been opened yet.

This has a side-effect of fixing access to input->users outside of
input->mutex protections by the way of eliminating said accesses and using
driver private flag.

Fixes: 84d3f6b76447 ("ACPI / button: Delay acpi_lid_initialize_state() until first user space open")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: 4.15+ <stable@vger.kernel.org> # 4.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/button.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -136,6 +136,7 @@ struct acpi_button {
 	int last_state;
 	ktime_t last_time;
 	bool suspended;
+	bool lid_state_initialized;
 };
 
 static BLOCKING_NOTIFIER_HEAD(acpi_lid_notifier);
@@ -391,6 +392,8 @@ static int acpi_lid_update_state(struct
 
 static void acpi_lid_initialize_state(struct acpi_device *device)
 {
+	struct acpi_button *button = acpi_driver_data(device);
+
 	switch (lid_init_state) {
 	case ACPI_BUTTON_LID_INIT_OPEN:
 		(void)acpi_lid_notify_state(device, 1);
@@ -402,13 +405,14 @@ static void acpi_lid_initialize_state(st
 	default:
 		break;
 	}
+
+	button->lid_state_initialized = true;
 }
 
 static void acpi_button_notify(struct acpi_device *device, u32 event)
 {
 	struct acpi_button *button = acpi_driver_data(device);
 	struct input_dev *input;
-	int users;
 
 	switch (event) {
 	case ACPI_FIXED_HARDWARE_EVENT:
@@ -417,10 +421,7 @@ static void acpi_button_notify(struct ac
 	case ACPI_BUTTON_NOTIFY_STATUS:
 		input = button->input;
 		if (button->type == ACPI_BUTTON_TYPE_LID) {
-			mutex_lock(&button->input->mutex);
-			users = button->input->users;
-			mutex_unlock(&button->input->mutex);
-			if (users)
+			if (button->lid_state_initialized)
 				acpi_lid_update_state(device, true);
 		} else {
 			int keycode;
@@ -465,7 +466,7 @@ static int acpi_button_resume(struct dev
 	struct acpi_button *button = acpi_driver_data(device);
 
 	button->suspended = false;
-	if (button->type == ACPI_BUTTON_TYPE_LID && button->input->users) {
+	if (button->type == ACPI_BUTTON_TYPE_LID) {
 		button->last_state = !!acpi_lid_evaluate_state(device);
 		button->last_time = ktime_get();
 		acpi_lid_initialize_state(device);


