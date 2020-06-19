Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24CB201712
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389457AbgFSQdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389450AbgFSOv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:51:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78BD821548;
        Fri, 19 Jun 2020 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578288;
        bh=R7Y1nPiimr3NbUR5MMbzwZMcQYIiSChTdBeIPuksz1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Azx+AyGsQLzKJLYcaYrJVM4olEhi4MGool/fpQ/Eb9s4n4C+JhhKRFTWNfkmByn/j
         wfw8k+cIphpcKGpc7ZLU8tE0WR4SjFlAZU/9i2rgwf1fHLbAko1hOaFnMBuqZFTBN4
         O732XgzsR2/qO+ps2rm+n6U0lY1UjbcRcU3AkClk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Wu <peter@lekensteyn.nl>, Lukas Wunner <lukas@wunner.de>,
        Sasha Levin <sashal@kernel.org>,
        Kai Heng Feng <kai.heng.feng@canonical.com>,
        Mike Lothian <mike@fireburn.co.uk>,
        Denis Lisov <dennis.lissov@gmail.com>
Subject: [PATCH 4.14 154/190] vga_switcheroo: Deduplicate power state tracking
Date:   Fri, 19 Jun 2020 16:33:19 +0200
Message-Id: <20200619141641.422349638@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 8948ca1a12c9a039361bbc3e4627064153971d57 ]

If DRM drivers use runtime PM, they currently notify vga_switcheroo
whenever they ->runtime_suspend or ->runtime_resume to update
vga_switcheroo's internal power state tracking.

That's essentially a duplication of a functionality performed by the
PM core as it already tracks the GPU's power state and vga_switcheroo
can always query it.

Introduce a new internal helper vga_switcheroo_pwr_state() which does
just that if runtime PM is used, or falls back to vga_switcheroo's
internal power state tracking if manual power control is used.
Drop a redundant power state check in set_audio_state() while at it.

This removes one of the two purposes of the notification mechanism
implemented by vga_switcheroo_set_dynamic_switch().  The other one is
power management of the audio device and we'll remove that next.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Peter Wu <peter@lekensteyn.nl>
Tested-by: Kai Heng Feng <kai.heng.feng@canonical.com> # AMD PowerXpress
Tested-by: Mike Lothian <mike@fireburn.co.uk>          # AMD PowerXpress
Tested-by: Denis Lisov <dennis.lissov@gmail.com>       # Nvidia Optimus
Tested-by: Peter Wu <peter@lekensteyn.nl>              # Nvidia Optimus
Tested-by: Lukas Wunner <lukas@wunner.de>              # MacBook Pro
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://patchwork.freedesktop.org/patch/msgid/0aa49d735b988aa04524a8dc339582ace33f0f94.1520068884.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/vga/vga_switcheroo.c | 35 +++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 3cd153c6d271..5da45325621c 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -92,7 +92,8 @@
  * struct vga_switcheroo_client - registered client
  * @pdev: client pci device
  * @fb_info: framebuffer to which console is remapped on switching
- * @pwr_state: current power state
+ * @pwr_state: current power state if manual power control is used.
+ *	For driver power control, call vga_switcheroo_pwr_state().
  * @ops: client callbacks
  * @id: client identifier. Determining the id requires the handler,
  *	so gpus are initially assigned VGA_SWITCHEROO_UNKNOWN_ID
@@ -406,6 +407,19 @@ bool vga_switcheroo_client_probe_defer(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(vga_switcheroo_client_probe_defer);
 
+static enum vga_switcheroo_state
+vga_switcheroo_pwr_state(struct vga_switcheroo_client *client)
+{
+	if (client->driver_power_control)
+		if (pm_runtime_enabled(&client->pdev->dev) &&
+		    pm_runtime_active(&client->pdev->dev))
+			return VGA_SWITCHEROO_ON;
+		else
+			return VGA_SWITCHEROO_OFF;
+	else
+		return client->pwr_state;
+}
+
 /**
  * vga_switcheroo_get_client_state() - obtain power state of a given client
  * @pdev: client pci device
@@ -425,7 +439,7 @@ enum vga_switcheroo_state vga_switcheroo_get_client_state(struct pci_dev *pdev)
 	if (!client)
 		ret = VGA_SWITCHEROO_NOT_FOUND;
 	else
-		ret = client->pwr_state;
+		ret = vga_switcheroo_pwr_state(client);
 	mutex_unlock(&vgasr_mutex);
 	return ret;
 }
@@ -598,7 +612,7 @@ static int vga_switcheroo_show(struct seq_file *m, void *v)
 			   client_is_vga(client) ? "" : "-Audio",
 			   client->active ? '+' : ' ',
 			   client->driver_power_control ? "Dyn" : "",
-			   client->pwr_state ? "Pwr" : "Off",
+			   vga_switcheroo_pwr_state(client) ? "Pwr" : "Off",
 			   pci_name(client->pdev));
 		i++;
 	}
@@ -641,7 +655,7 @@ static void set_audio_state(enum vga_switcheroo_client_id id,
 	struct vga_switcheroo_client *client;
 
 	client = find_client_from_id(&vgasr_priv.clients, id | ID_BIT_AUDIO);
-	if (client && client->pwr_state != state) {
+	if (client) {
 		client->ops->set_gpu_state(client->pdev, state);
 		client->pwr_state = state;
 	}
@@ -656,7 +670,7 @@ static int vga_switchto_stage1(struct vga_switcheroo_client *new_client)
 	if (!active)
 		return 0;
 
-	if (new_client->pwr_state == VGA_SWITCHEROO_OFF)
+	if (vga_switcheroo_pwr_state(new_client) == VGA_SWITCHEROO_OFF)
 		vga_switchon(new_client);
 
 	vga_set_default_device(new_client->pdev);
@@ -695,7 +709,7 @@ static int vga_switchto_stage2(struct vga_switcheroo_client *new_client)
 	if (new_client->ops->reprobe)
 		new_client->ops->reprobe(new_client->pdev);
 
-	if (active->pwr_state == VGA_SWITCHEROO_ON)
+	if (vga_switcheroo_pwr_state(active) == VGA_SWITCHEROO_ON)
 		vga_switchoff(active);
 
 	set_audio_state(new_client->id, VGA_SWITCHEROO_ON);
@@ -940,8 +954,7 @@ EXPORT_SYMBOL(vga_switcheroo_process_delayed_switch);
  * command line disables it.
  *
  * When the driver decides to power up or down, it notifies vga_switcheroo
- * thereof so that it can (a) power the audio device on the GPU up or down,
- * and (b) update its internal power state representation for the device.
+ * thereof so that it can power the audio device on the GPU up or down.
  * This is achieved by vga_switcheroo_set_dynamic_switch().
  *
  * After the GPU has been suspended, the handler needs to be called to cut
@@ -985,9 +998,8 @@ static void vga_switcheroo_power_switch(struct pci_dev *pdev,
  *
  * Helper for GPUs whose power state is controlled by the driver's runtime pm.
  * When the driver decides to power up or down, it notifies vga_switcheroo
- * thereof using this helper so that it can (a) power the audio device on
- * the GPU up or down, and (b) update its internal power state representation
- * for the device.
+ * thereof using this helper so that it can power the audio device on the GPU
+ * up or down.
  */
 void vga_switcheroo_set_dynamic_switch(struct pci_dev *pdev,
 				       enum vga_switcheroo_state dynamic)
@@ -1001,7 +1013,6 @@ void vga_switcheroo_set_dynamic_switch(struct pci_dev *pdev,
 		return;
 	}
 
-	client->pwr_state = dynamic;
 	set_audio_state(client->id, dynamic);
 	mutex_unlock(&vgasr_mutex);
 }
-- 
2.25.1



