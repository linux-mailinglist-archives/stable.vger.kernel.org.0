Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044892E66D1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgL1NRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387410AbgL1NQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:16:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82495207CF;
        Mon, 28 Dec 2020 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161377;
        bh=SnmQ7xExflvTQ9e7DPhplcTUzYhGNeJnVXpuzLjSSVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3sz0qUJDR6GMPNCz7+b/bRn7KcPuG0v7X0/8TAERDiaqv03WoSPicF6H4X/Ed0oL
         yGz9f0riTCHMCNmQGbFN1vSgzEd3Nhl7UwZ0YrQYP1dEcDMjDAcP7Ugf3ILOMwa+xn
         704sCel7MJponvTgRBXlw1u4F8Vmy6tCZ5kt7w0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 193/242] s390/dasd: fix list corruption of pavgroup group list
Date:   Mon, 28 Dec 2020 13:49:58 +0100
Message-Id: <20201228124914.180944959@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 0ede91f83aa335da1c3ec68eb0f9e228f269f6d8 upstream.

dasd_alias_add_device() moves devices to the active_devices list in case
of a scheduled LCU update regardless if they have previously been in a
pavgroup or not.

Example: device A and B are in the same pavgroup.

Device A has already been in a pavgroup and the private->pavgroup pointer
is set and points to a valid pavgroup. While going through dasd_add_device
it is moved from the pavgroup to the active_devices list.

In parallel device B might be removed from the same pavgroup in
remove_device_from_lcu() which in turn checks if the group is empty
and deletes it accordingly because device A has already been removed from
there.

When now device A enters remove_device_from_lcu() it is tried to remove it
from the pavgroup again because the pavgroup pointer is still set and again
the empty group will be cleaned up which leads to a list corruption.

Fix by setting private->pavgroup to NULL in dasd_add_device.

If the device has been the last device on the pavgroup an empty pavgroup
remains but this will be cleaned up by the scheduled lcu_update which
iterates over all existing pavgroups.

Fixes: 8e09f21574ea ("[S390] dasd: add hyper PAV support to DASD device driver, part 1")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_alias.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -634,6 +634,7 @@ int dasd_alias_add_device(struct dasd_de
 	}
 	if (lcu->flags & UPDATE_PENDING) {
 		list_move(&device->alias_list, &lcu->active_devices);
+		private->pavgroup = NULL;
 		_schedule_lcu_update(lcu, device);
 	}
 	spin_unlock_irqrestore(&lcu->lock, flags);


