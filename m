Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5530C272EDF
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgIUQst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729823AbgIUQsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A7F323888;
        Mon, 21 Sep 2020 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706897;
        bh=DbHivANAIp1h2Y6cZ9ykE3t92dQXY+JqKNAi/wdVfAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRmi47Vo+J1Vno0A3QfuaFaIOk7oVYSTTlDFU+YiZd/usDzL76S6RUoVq/ifTzONe
         latd6v0MKHL0l4QEq9bsfhXQlTlhe7YYw5V8p998DuGyGSKyJD05yO3Aqy31zckFvZ
         5dH6Qm6i6dmYFGJbnTRZUHqt3WglbZA4Pode9gJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 03/72] e1000e: Add support for Comet Lake
Date:   Mon, 21 Sep 2020 18:30:42 +0200
Message-Id: <20200921163122.042906313@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

commit 914ee9c436cbe90c8ca8a46ec8433cb614a2ada5 upstream.

Add devices ID's for the next LOM generations that will be
available on the next Intel Client platform (Comet Lake)
This patch provides the initial support for these devices

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Anthony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/hw.h     |    6 ++++++
 drivers/net/ethernet/intel/e1000e/netdev.c |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -86,6 +86,12 @@ struct e1000_hw;
 #define E1000_DEV_ID_PCH_ICP_I219_V8		0x15E0
 #define E1000_DEV_ID_PCH_ICP_I219_LM9		0x15E1
 #define E1000_DEV_ID_PCH_ICP_I219_V9		0x15E2
+#define E1000_DEV_ID_PCH_CMP_I219_LM10		0x0D4E
+#define E1000_DEV_ID_PCH_CMP_I219_V10		0x0D4F
+#define E1000_DEV_ID_PCH_CMP_I219_LM11		0x0D4C
+#define E1000_DEV_ID_PCH_CMP_I219_V11		0x0D4D
+#define E1000_DEV_ID_PCH_CMP_I219_LM12		0x0D53
+#define E1000_DEV_ID_PCH_CMP_I219_V12		0x0D55
 
 #define E1000_REVISION_4	4
 
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7568,6 +7568,12 @@ static const struct pci_device_id e1000_
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_V8), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_LM9), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_V9), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM10), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V10), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM11), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V11), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM12), board_pch_spt },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V12), board_pch_spt },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };


