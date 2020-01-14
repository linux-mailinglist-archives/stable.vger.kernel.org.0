Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D5513A609
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgANKIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730913AbgANKIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:08:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E5D02468D;
        Tue, 14 Jan 2020 10:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996494;
        bh=eDkGYIEIZlDu/9ZxZEJp1nMsLRvkbalVZAg7BLOjr3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPu4dKAyyAGmMGin+np2nX8+gwJa6MvqnnR301yHWzyQT9bXNv4TqvT+aGoBzdUQb
         dAgv4fHpihqgBxKsAoKv7MQtS+dVr2qHcsdu6Tcj5+npgDgNHfrQML9oU1Mgyts1L3
         TUVJrl+FqpWsxMZLUqDREsQJDAo0r1+FjgNz8qC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 12/46] HID: uhid: Fix returning EPOLLOUT from uhid_char_poll
Date:   Tue, 14 Jan 2020 11:01:29 +0100
Message-Id: <20200114094343.008275214@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
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
@@ -775,7 +775,7 @@ static __poll_t uhid_char_poll(struct fi
 	if (uhid->head != uhid->tail)
 		return EPOLLIN | EPOLLRDNORM;
 
-	return 0;
+	return EPOLLOUT | EPOLLWRNORM;
 }
 
 static const struct file_operations uhid_fops = {


