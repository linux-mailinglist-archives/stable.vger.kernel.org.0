Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0060213A5DE
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgANKEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:04:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729887AbgANKEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:04:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F323224673;
        Tue, 14 Jan 2020 10:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996269;
        bh=UL/UGLYbiL1OR7mUNYU0zJhjbTK65irE5L1L83wy4zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYkyQhHdEGN6MiDQBRIwZbsVkjc8LrzI41FHfpBIFo7BC8GgQOb8ojUxQNYDAlQfR
         ZAZ6tj78SgaKO3711oi7PQ3ZnK0TQwghWfaAmv+b87LV2Qnxa0tJylkH7kncgKCBkC
         jNQHj1ZAZWkfdhENciQjUA01jsgdZJ1E/13nZ3UU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 18/78] HID: uhid: Fix returning EPOLLOUT from uhid_char_poll
Date:   Tue, 14 Jan 2020 11:00:52 +0100
Message-Id: <20200114094356.166466578@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

commit be54e7461ffdc5809b67d2aeefc1ddc9a91470c7 upstream.

Always return EPOLLOUT from uhid_char_poll to allow polling /dev/uhid
for writable state.

Fixes: 1f9dec1e0164 ("HID: uhid: allow poll()'ing on uhid devices")
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/uhid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -772,7 +772,7 @@ static __poll_t uhid_char_poll(struct fi
 	if (uhid->head != uhid->tail)
 		return EPOLLIN | EPOLLRDNORM;
 
-	return 0;
+	return EPOLLOUT | EPOLLWRNORM;
 }
 
 static const struct file_operations uhid_fops = {


