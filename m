Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C67C1163105
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 20:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgBRT6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:58:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbgBRT6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:58:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 424F424125;
        Tue, 18 Feb 2020 19:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055909;
        bh=yYZKeSyGawqNcMCw4ypNqgx7uLhMIDMRc5yLeMvZ3TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgSRUfSvXZQtBz3N0gnamkpv9aczV4NUZZN4LtnNT5uww8UyQWeX45UnFx7M/DHz6
         NFsg2SSYguua6Euk7c1AR0bcQQe3aVEkcCzTl8o14sUip203ao6hk6+E9k3EDVKWOj
         dt4gPXeR1ddcTN8zSB+SAkWqPyNQ0NxVJHDVX2yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
        Borislav Petkov <bp@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5.4 28/66] EDAC/sysfs: Remove csrow objects on errors
Date:   Tue, 18 Feb 2020 20:54:55 +0100
Message-Id: <20200218190430.669318831@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@marvell.com>

commit 4d59588c09f2a2daedad2a544d4d1b602ab3a8af upstream.

All created csrow objects must be removed in the error path of
edac_create_csrow_objects(). The objects have been added as devices.

They need to be removed by doing a device_del() *and* put_device() call
to also free their memory. The missing put_device() leaves a memory
leak. Use device_unregister() instead of device_del() which properly
unregisters the device doing both.

Fixes: 7adc05d2dc3a ("EDAC/sysfs: Drop device references properly")
Signed-off-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: John Garry <john.garry@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200212120340.4764-4-rrichter@marvell.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/edac_mc_sysfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -447,8 +447,7 @@ error:
 		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
-
-		device_del(&mci->csrows[i]->dev);
+		device_unregister(&mci->csrows[i]->dev);
 	}
 
 	return err;


