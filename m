Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AA3C14B2
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbfI2N5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbfI2N5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE18821835;
        Sun, 29 Sep 2019 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765440;
        bh=V4JDjBNY1ZSsHGFbo7C7wIHPvOEOz1geVmPIYaGMxsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaQ6OuTE3UvH0mFGPBNzFU9nAvA1bShiO8nBV48CHf5bxgNcmhrc7hUanN72taJ+2
         OJHBbCQM1TukWgxNOJ7/mj1LQzkzu0oowIoMbxffE1gkQWWzEfAFkT5l4psjuLt4Qg
         ZoX8K4n5H//C7iV6zd01TVIUbJ7M2GIA1WmgB59g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 08/63] HID: sony: Fix memory corruption issue on cleanup.
Date:   Sun, 29 Sep 2019 15:53:41 +0200
Message-Id: <20190929135032.746377634@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roderick Colenbrander <roderick.colenbrander@sony.com>

commit 2bcdacb70327013ca2066bfcf2af1009eff01f1d upstream.

The sony driver is not properly cleaning up from potential failures in
sony_input_configured. Currently it calls hid_hw_stop, while hid_connect
is still running. This is not a good idea, instead hid_hw_stop should
be moved to sony_probe. Similar changes were recently made to Logitech
drivers, which were also doing improper cleanup.

Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
CC: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-sony.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -2806,7 +2806,6 @@ err_stop:
 	sony_cancel_work_sync(sc);
 	sony_remove_dev_list(sc);
 	sony_release_device_id(sc);
-	hid_hw_stop(hdev);
 	return ret;
 }
 
@@ -2868,6 +2867,7 @@ static int sony_probe(struct hid_device
 	 */
 	if (!(hdev->claimed & HID_CLAIMED_INPUT)) {
 		hid_err(hdev, "failed to claim input\n");
+		hid_hw_stop(hdev);
 		return -ENODEV;
 	}
 


