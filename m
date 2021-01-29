Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABA9308530
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 06:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhA2F2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 00:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhA2F2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 00:28:30 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495A3C061573
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 21:27:50 -0800 (PST)
Received: from ip4d149f6e.dynamic.kabel-deutschland.de ([77.20.159.110] helo=truhe.fritz.box); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1l5MG0-0002CY-2c; Fri, 29 Jan 2021 06:23:44 +0100
From:   Thorsten Leemhuis <linux@leemhuis.info>
To:     thl@ct.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] nvme-pci: add quirk to make Kingston A2000 SSD avoid deepest sleep state
Date:   Fri, 29 Jan 2021 06:23:43 +0100
Message-Id: <20210129052343.310728-1-linux@leemhuis.info>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1611898070;ec4c9cae;
X-HE-SMSGID: 1l5MG0-0002CY-2c
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some Kingston A2000 NVMe SSDs sooner or later get confused and stop
working when they use the deepest APST sleep while running Linux. The
system then crashes and one has to cold boot it to get the SSD working
again.

Kingston seems to known about this since at least mid-September 2020:
https://bbs.archlinux.org/viewtopic.php?pid=1926994#p1926994

Someone working for a German company representing Kingston to the German
press confirmed to me Kingston engineering is aware of the issue and
investigating; the person stated that to their current knowledge only
the deepest APST sleep state causes trouble. Therefore, make Linux avoid
it for now by applying the NVME_QUIRK_NO_DEEPEST_PS to this SSD.

I have two such SSDs, but it seems the problem doesn't occur with them.
I hence couldn't verify if this patch really fixes the problem, but all
the data in front of me suggests it should.

This patch can easily be reverted or improved upon if a better solution
surfaces.

FWIW, there are many reports about the issue scattered around the web;
most of the users disabled APST completely to make things work, some
just made Linux avoid the deepest sleep state:

https://bugzilla.kernel.org/show_bug.cgi?id=195039#c65
https://bugzilla.kernel.org/show_bug.cgi?id=195039#c73
https://bugzilla.kernel.org/show_bug.cgi?id=195039#c74
https://bugzilla.kernel.org/show_bug.cgi?id=195039#c78
https://bugzilla.kernel.org/show_bug.cgi?id=195039#c79
https://bugzilla.kernel.org/show_bug.cgi?id=195039#c80
https://askubuntu.com/questions/1222049/nvmekingston-a2000-sometimes-stops-giving-response-in-ubuntu-18-04dell-inspir
https://community.acer.com/en/discussion/604326/m-2-nvme-ssd-aspire-517-51g-issue-compatibility-kingston-a2000-linux-ubuntu

For the record, some data from 'nvme id-ctrl /dev/nvme0'

NVME Identify Controller:
vid       : 0x2646
ssvid     : 0x2646
mn        : KINGSTON SA2000M81000G
fr        : S5Z42105
[...]
ps    0 : mp:9.00W operational enlat:0 exlat:0 rrt:0 rrl:0
          rwt:0 rwl:0 idle_power:- active_power:-
ps    1 : mp:4.60W operational enlat:0 exlat:0 rrt:1 rrl:1
          rwt:1 rwl:1 idle_power:- active_power:-
ps    2 : mp:3.80W operational enlat:0 exlat:0 rrt:2 rrl:2
          rwt:2 rwl:2 idle_power:- active_power:-
ps    3 : mp:0.0450W non-operational enlat:2000 exlat:2000 rrt:3 rrl:3
          rwt:3 rwl:3 idle_power:- active_power:-
ps    4 : mp:0.0040W non-operational enlat:15000 exlat:15000 rrt:4 rrl:4
          rwt:4 rwl:4 idle_power:- active_power:-

Cc: stable@vger.kernel.org # 4.14+
Signed-off-by: Thorsten Leemhuis <linux@leemhuis.info>
---

Once this is out I will post a link to it in
https://bugzilla.kernel.org/show_bug.cgi?id=195039, maybe someone there
might be able to confirm that this fixes the issue.

---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 856aa31931c1..421735e16870 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3257,6 +3257,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },
-- 
2.29.2

