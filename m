Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14403A788
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbfFIQue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731200AbfFIQud (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:50:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB082070B;
        Sun,  9 Jun 2019 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099033;
        bh=+6Rdq5w3wp1P6tGkrvd3YaT2CBY7QDquzepJZLwu7c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=net8a0qawjRJf7FVwrJTj2AAv7NeLmevpbrylOaZ08A3sT5YMAHhJkcQjtSEi47hn
         QtzO0F4OMS/zsFfyyrhdCctBE8pdJ6BZvoZ59mihm0Db8ydWv4xVtZCJgkCe9szgmy
         k8XGxGmmHqqNWaeAqJa1aqQPe4bstlJKt976Si+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.14 25/35] test_firmware: Use correct snprintf() limit
Date:   Sun,  9 Jun 2019 18:42:31 +0200
Message-Id: <20190609164127.010750878@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bd17cc5a20ae9aaa3ed775f360b75ff93cd66a1d upstream.

The limit here is supposed to be how much of the page is left, but it's
just using PAGE_SIZE as the limit.

The other thing to remember is that snprintf() returns the number of
bytes which would have been copied if we had had enough room.  So that
means that if we run out of space then this code would end up passing a
negative value as the limit and the kernel would print an error message.
I have change the code to use scnprintf() which returns the number of
bytes that were successfully printed (not counting the NUL terminator).

Fixes: c92316bf8e94 ("test_firmware: add batched firmware tests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/test_firmware.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -222,30 +222,30 @@ static ssize_t config_show(struct device
 
 	mutex_lock(&test_fw_mutex);
 
-	len += snprintf(buf, PAGE_SIZE,
+	len += scnprintf(buf, PAGE_SIZE - len,
 			"Custom trigger configuration for: %s\n",
 			dev_name(dev));
 
 	if (test_fw_config->name)
-		len += snprintf(buf+len, PAGE_SIZE,
+		len += scnprintf(buf+len, PAGE_SIZE - len,
 				"name:\t%s\n",
 				test_fw_config->name);
 	else
-		len += snprintf(buf+len, PAGE_SIZE,
+		len += scnprintf(buf+len, PAGE_SIZE - len,
 				"name:\tEMTPY\n");
 
-	len += snprintf(buf+len, PAGE_SIZE,
+	len += scnprintf(buf+len, PAGE_SIZE - len,
 			"num_requests:\t%u\n", test_fw_config->num_requests);
 
-	len += snprintf(buf+len, PAGE_SIZE,
+	len += scnprintf(buf+len, PAGE_SIZE - len,
 			"send_uevent:\t\t%s\n",
 			test_fw_config->send_uevent ?
 			"FW_ACTION_HOTPLUG" :
 			"FW_ACTION_NOHOTPLUG");
-	len += snprintf(buf+len, PAGE_SIZE,
+	len += scnprintf(buf+len, PAGE_SIZE - len,
 			"sync_direct:\t\t%s\n",
 			test_fw_config->sync_direct ? "true" : "false");
-	len += snprintf(buf+len, PAGE_SIZE,
+	len += scnprintf(buf+len, PAGE_SIZE - len,
 			"read_fw_idx:\t%u\n", test_fw_config->read_fw_idx);
 
 	mutex_unlock(&test_fw_mutex);


