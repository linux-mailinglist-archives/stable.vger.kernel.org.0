Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB1C499FA1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841875AbiAXXAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835208AbiAXWfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:35:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73661C0E9B96;
        Mon, 24 Jan 2022 12:58:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D85E6135D;
        Mon, 24 Jan 2022 20:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E676DC340E5;
        Mon, 24 Jan 2022 20:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057932;
        bh=HMP4DKejjmzzmBiC3x+uMGlYrLYTaLCXGsNBASp+WKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fk8e2mbefWPvOTqTKSMjtWURZEY5SLOxm1Y7MStYI2PHd+2EcP9x/tGQvpvUHaUoI
         U3e1ODyt64KkCvAMEIU55i5AioMLh8/boqnC8EBs+LHsK3ZjYr5qtPNhVnalfNkIce
         nD+36M6vkRAdaGD7h5IRNR5SmGEpu75Az3orQbYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0083/1039] Bluetooth: hci_vhci: Fix to set the force_wakeup value
Date:   Mon, 24 Jan 2022 19:31:12 +0100
Message-Id: <20220124184127.945773742@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

[ Upstream commit 8b89637dbac2d73d9f3dadf91b4a7dcdb1fc23af ]

This patch sets the wakeup state of the vhci driver when the
force_wakeup is updated.

Fixes: 60edfad4fd0b6 ("Bluetooth: hci_vhci: Add force_prevent_wake entry")
Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_vhci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index b45db0db347c6..5fd91106e853d 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -176,6 +176,8 @@ static ssize_t force_wakeup_write(struct file *file,
 	if (data->wakeup == enable)
 		return -EALREADY;
 
+	data->wakeup = enable;
+
 	return count;
 }
 
-- 
2.34.1



