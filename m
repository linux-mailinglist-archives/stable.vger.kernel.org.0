Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED27C3137DB
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhBHPc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233847AbhBHP2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:28:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D97C064F25;
        Mon,  8 Feb 2021 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797374;
        bh=fQNaoJS3pBKg4d57ZiIRf6PY50RXRyzX13+TXIIwBuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0slUfsM5N5szAzLneDCSdrnQVHSGuoPfLAVLzjUuhMfe8mXmgggka7bXTYLqoAJRk
         Y11Jsdrx+SDgRTgzUKfmCTTK4N1IljIDFy/MjS/SyOJeRxHYwfUjf/Ho1N//64L5Cq
         zATm/eOc4m9mubx2RssyOJBpbSN+XQE7SniTMiw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thorsten Leemhuis <linux@leemhuis.info>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 087/120] nvme-pci: avoid the deepest sleep state on Kingston A2000 SSDs
Date:   Mon,  8 Feb 2021 16:01:14 +0100
Message-Id: <20210208145821.866534035@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
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
@@ -3262,6 +3262,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },


