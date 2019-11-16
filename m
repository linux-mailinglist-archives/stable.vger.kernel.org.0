Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CADFF169
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbfKPPs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:48:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730055AbfKPPs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:29 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F511207FA;
        Sat, 16 Nov 2019 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919308;
        bh=KzaYq/ZxefBgTK1mWLIBUbunCDUrWNx+9I10MwP1UNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSxvpbz9hBBcVpARK0ayyIqJwwhlQenSsa82/mWHkijnEwL7nG7VgFHAbruoxsu1y
         +tO4shHVp+OUSmijF3VOUcKiZYdLsgQF2Cqyn8l0uJMm7VhmOqof8nQ8klB7OUXBms
         T0TwTSBCVzAKyqzF21rsZ7FQVjhq5OChJ6jYROiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 051/150] usbip: tools: fix atoi() on non-null terminated string
Date:   Sat, 16 Nov 2019 10:45:49 -0500
Message-Id: <20191116154729.9573-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e325808c0051b16729ffd472ff887c6cae5c6317 ]

Currently the call to atoi is being passed a single char string
that is not null terminated, so there is a potential read overrun
along the stack when parsing for an integer value.  Fix this by
instead using a 2 char string that is initialized to all zeros
to ensure that a 1 char read into the string is always terminated
with a \0.

Detected by cppcheck:
"Invalid atoi() argument nr 1. A nul-terminated string is required."

Fixes: 3391ba0e2792 ("usbip: tools: Extract generic code to be shared with vudc backend")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/usb/usbip/libsrc/usbip_host_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/usb/usbip/libsrc/usbip_host_common.c b/tools/usb/usbip/libsrc/usbip_host_common.c
index 6ff7b601f8545..f5ad219a324e8 100644
--- a/tools/usb/usbip/libsrc/usbip_host_common.c
+++ b/tools/usb/usbip/libsrc/usbip_host_common.c
@@ -43,7 +43,7 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	int size;
 	int fd;
 	int length;
-	char status;
+	char status[2] = { 0 };
 	int value = 0;
 
 	size = snprintf(status_attr_path, sizeof(status_attr_path),
@@ -61,14 +61,14 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 		return -1;
 	}
 
-	length = read(fd, &status, 1);
+	length = read(fd, status, 1);
 	if (length < 0) {
 		err("error reading attribute %s", status_attr_path);
 		close(fd);
 		return -1;
 	}
 
-	value = atoi(&status);
+	value = atoi(status);
 
 	return value;
 }
-- 
2.20.1

