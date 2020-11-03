Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EC42A5211
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgKCUq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731182AbgKCUqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AA8E20719;
        Tue,  3 Nov 2020 20:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436385;
        bh=+TgpZn8slUKhUywr9pCiLOk9QO206ruDjeYarbyQdKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4Rc1UIGvcSAVmmpDlyJknJYjg5HYxuQQW2SC8RyBnF2wypoVN95oD+0CNBPXpUtH
         WjqMV7SODAyTdhQVoZVll+L6199fgNgwYYewSNNz3qvfOAy2mdyxk19TG3cfXgZTmS
         pdYXOmEYhU7mmkqTzHxNQPprsPsQv+D/aFuM4FmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 220/391] PM: runtime: Remove link state checks in rpm_get/put_supplier()
Date:   Tue,  3 Nov 2020 21:34:31 +0100
Message-Id: <20201103203401.790987879@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

commit d12544fb2aa9944b180c35914031a8384ab082c1 upstream.

To support runtime PM for hisi SAS driver (the driver is in directory
drivers/scsi/hisi_sas), we add device link between scsi_device->sdev_gendev
(consumer device) and hisi_hba->dev(supplier device) with flags
DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE.

After runtime suspended consumers and supplier, unload the dirver which
causes a hung.

We found that it called function device_release_driver_internal() to
release the supplier device (hisi_hba->dev), as the device link was
busy, it set the device link state to DL_STATE_SUPPLIER_UNBIND, and
then it called device_release_driver_internal() to release the consumer
device (scsi_device->sdev_gendev).

Then it would try to call pm_runtime_get_sync() to resume the consumer
device, but because consumer-supplier relation existed, it would try
to resume the supplier first, but as the link state was already
DL_STATE_SUPPLIER_UNBIND, so it skipped resuming the supplier and only
resumed the consumer which hanged (it sends IOs to resume scsi_device
while the SAS controller is suspended).

Simple flow is as follows:

device_release_driver_internal -> (supplier device)
    if device_links_busy ->
	device_links_unbind_consumers ->
	    ...
	    WRITE_ONCE(link->status, DL_STATE_SUPPLIER_UNBIND)
	    device_release_driver_internal (consumer device)
    pm_runtime_get_sync -> (consumer device)
	...
	__rpm_callback ->
	    rpm_get_suppliers ->
		if link->state == DL_STATE_SUPPLIER_UNBIND -> skip the action of resuming the supplier
		...
    pm_runtime_clean_up_links
    ...

Correct suspend/resume ordering between a supplier device and its consumer
devices (resume the supplier device before resuming consumer devices, and
suspend consumer devices before suspending the supplier device) should be
guaranteed by runtime PM, but the state checks in rpm_get_supplier() and
rpm_put_supplier() break this rule, so remove them.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
[ rjw: Subject and changelog edits ]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/runtime.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -291,8 +291,7 @@ static int rpm_get_suppliers(struct devi
 				device_links_read_lock_held()) {
 		int retval;
 
-		if (!(link->flags & DL_FLAG_PM_RUNTIME) ||
-		    READ_ONCE(link->status) == DL_STATE_SUPPLIER_UNBIND)
+		if (!(link->flags & DL_FLAG_PM_RUNTIME))
 			continue;
 
 		retval = pm_runtime_get_sync(link->supplier);
@@ -312,8 +311,6 @@ static void rpm_put_suppliers(struct dev
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
 				device_links_read_lock_held()) {
-		if (READ_ONCE(link->status) == DL_STATE_SUPPLIER_UNBIND)
-			continue;
 
 		while (refcount_dec_not_one(&link->rpm_active))
 			pm_runtime_put(link->supplier);


