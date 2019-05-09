Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D67419208
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfEITDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbfEIStW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:49:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6773320578;
        Thu,  9 May 2019 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427761;
        bh=m5v/VQDEu53kIn8smOqM7gN/gtLhfkr4W9EBM+BYU1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/oWImlQrN9mLvwiEBinU0g2/UkYhTlcZUn2NA7B490WerHTcaubt/Suw6G/5DKwr
         gTg34Y8enAu7XdvMgrrxMagFqubThmDOs98XvATrMQWY9VfYuZxDBJwUbnpxhw0bKi
         7ULg1vD6M72v8Kg06n6lwwqacyUCCb6dw/DvRu6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <YangX92@hotmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.19 61/66] Bluetooth: hidp: fix buffer overflow
Date:   Thu,  9 May 2019 20:42:36 +0200
Message-Id: <20190509181307.845881067@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Young Xiao <YangX92@hotmail.com>

commit a1616a5ac99ede5d605047a9012481ce7ff18b16 upstream.

Struct ca is copied from userspace. It is not checked whether the "name"
field is NULL terminated, which allows local users to obtain potentially
sensitive information from kernel stack memory, via a HIDPCONNADD command.

This vulnerability is similar to CVE-2011-1079.

Signed-off-by: Young Xiao <YangX92@hotmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hidp/sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -76,6 +76,7 @@ static int hidp_sock_ioctl(struct socket
 			sockfd_put(csock);
 			return err;
 		}
+		ca.name[sizeof(ca.name)-1] = 0;
 
 		err = hidp_connection_add(&ca, csock, isock);
 		if (!err && copy_to_user(argp, &ca, sizeof(ca)))


