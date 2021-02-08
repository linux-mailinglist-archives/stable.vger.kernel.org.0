Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EBF31368A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhBHPML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:12:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231825AbhBHPIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:08:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF73C64EB1;
        Mon,  8 Feb 2021 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796789;
        bh=MPlU6DmuN5KYRgcqMgqMvXNtpGyOjxpEWpuSZdATfbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRSp/hXpOUnvVReBORahSEzzgZBMwtz2fu7tDvGcQ2yCMKovw/tRTNydu4pJepQHh
         zRCtDqaGX6neMTYQ0oQh81liRjoEoY50IXTt2s/EOlM911T3CyNd+aXjDLso3Sta9j
         hGATs/w1/bUaz1zgTufgbvWFJt8CbbyEvae9PRug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thorsten Leemhuis <linux@leemhuis.info>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.14 20/30] nvme-pci: avoid the deepest sleep state on Kingston A2000 SSDs
Date:   Mon,  8 Feb 2021 16:01:06 +0100
Message-Id: <20210208145806.068622064@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thorsten Leemhuis <linux@leemhuis.info>

commit 538e4a8c571efdf131834431e0c14808bcfb1004 upstream.

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
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2588,6 +2588,8 @@ static const struct pci_device_id nvme_i
 	{ PCI_DEVICE(0x1d1d, 0x2601),	/* CNEX Granby */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
+	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },
 	{ 0, }


