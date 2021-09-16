Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D690840E380
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243470AbhIPQsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344669AbhIPQqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09C156112E;
        Thu, 16 Sep 2021 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809596;
        bh=hXTmkclbLkPq43POKeL3I734PIXlNy0QX0S35lmmUX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3DzDkplFog+Vimu6LUZbZ+CvbkhA1iPbhk6CyVOe6ODrVFl2HQ/AoYENFghpu/1S
         xgv9ReRDMS3peD9P9wGXIVP1yQq1fIr5s2dQJSMNAaKxUQWRHUglwhTPT9SDQoSl6z
         vPhnXVV8h4TAYiWh8JJbs5oyYJtw1WAOVppHqvao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 180/380] misc/pvpanic-pci: Allow automatic loading
Date:   Thu, 16 Sep 2021 17:58:57 +0200
Message-Id: <20210916155810.194741203@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

[ Upstream commit 28b6a003bcdfa1fc4603b9185b247ecca7af9bef ]

The virtual machine monitor (QEMU) exposes the pvpanic-pci
device to the guest. On guest side the module exists but
currently isn't loaded automatically. So the driver fails
to be probed and does not its job of handling guest panic
events.

Instead of requiring manual modprobe, let's include a device
database using the MODULE_DEVICE_TABLE macro and let the
module auto-load when the guest gets exposed with such a
pvpanic-pci device.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20210629072214.901004-1-eric.auger@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/pvpanic/pvpanic-pci.c b/drivers/misc/pvpanic/pvpanic-pci.c
index 046ce4ecc195..4a3250564442 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -119,4 +119,6 @@ static struct pci_driver pvpanic_pci_driver = {
 	},
 };
 
+MODULE_DEVICE_TABLE(pci, pvpanic_pci_id_tbl);
+
 module_pci_driver(pvpanic_pci_driver);
-- 
2.30.2



