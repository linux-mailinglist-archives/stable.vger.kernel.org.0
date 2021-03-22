Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3826B344100
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhCVM36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhCVM3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 834D160C3D;
        Mon, 22 Mar 2021 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416191;
        bh=dTyUyJi/hE5pOkCyN+ddMZTPGhpsYWHg4uJ3pxLVlzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmTWwQCxctK4FPU7JHQgdkPMhoVV0xWIMV2ESiyZ+6cAq5xNpO6SlxDfc54oqOYuF
         +ZlGWRS5LGF2xdERn1BhrzbPEYucYYisJv91nUsFqnitewUViot9kYUvuIDIn87BLE
         7WgjtdQi0xdsmWZXvSGr9rMS0q5J0RbTokw/eycs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.11 014/120] s390/pci: remove superfluous zdev->zbus check
Date:   Mon, 22 Mar 2021 13:26:37 +0100
Message-Id: <20210322121930.139842569@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit e1bff843cde62a45a287b7f9b4cd5e824e8e49e2 upstream.

Checking zdev->zbus for NULL in __zpci_event_availability() is
superfluous as it can never be NULL at this point. While harmless this
check causes smatch warnings because we later access zdev->zbus with
only having checked zdev != NULL which is sufficient.

The reason zdev->zbus can never be NULL is since with zdev != NULL given
we know the zdev came from get_zdev_by_fid() and thus the zpci_list.
Now on first glance at zpci_create_device() one may assume that there is
a window where the zdev is in the list without a zdev, however this
window can't overlap with __zpci_event_availability() as
zpci_create_device() either runs on the same kthread as part of
availability events, or during the initial CLP List PCI at which point
the __zpci_event_availability() is not yet called as zPCI is not yet
initialized.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -80,7 +80,7 @@ static void __zpci_event_availability(st
 	enum zpci_state state;
 	int ret;
 
-	if (zdev && zdev->zbus && zdev->zbus->bus)
+	if (zdev && zdev->zbus->bus)
 		pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
 
 	zpci_err("avail CCDF:\n");


