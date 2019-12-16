Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FCE12189B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfLPR5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbfLPR5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:57:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8318F21582;
        Mon, 16 Dec 2019 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519020;
        bh=SLLA6soTRudvRmoUb9fkFaD2Y3fKHbuYA00w0PGg8UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOrACA8yOJeRhU3fpDqS4MDZxuxBkWUs1uweFokndBIJc/bkj6xUmFR1X2is8ikBU
         7l7PxkGiEZJTlsHYmPsUbav3utNx6JiS8f+mrKO4QS1QD0RZ5EN9ynRQq7XMKCOyf4
         mmDVG/WjTyxAJhJQSOYOLwpJjxXqwAUQxOp1ko64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 162/267] USB: uas: heed CAPACITY_HEURISTICS
Date:   Mon, 16 Dec 2019 18:48:08 +0100
Message-Id: <20191216174911.377392511@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 335cbbd5762d5e5c67a8ddd6e6362c2aa42a328f upstream.

There is no need to ignore this flag. We should be as close
to storage in that regard as makes sense, so honor flags whose
cost is tiny.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191114112758.32747-3-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -845,6 +845,12 @@ static int uas_slave_configure(struct sc
 		sdev->fix_capacity = 1;
 
 	/*
+	 * in some cases we have to guess
+	 */
+	if (devinfo->flags & US_FL_CAPACITY_HEURISTICS)
+		sdev->guess_capacity = 1;
+
+	/*
 	 * Some devices don't like MODE SENSE with page=0x3f,
 	 * which is the command used for checking if a device
 	 * is write-protected.  Now that we tell the sd driver


