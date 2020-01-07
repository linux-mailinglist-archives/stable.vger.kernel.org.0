Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3C81332F7
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgAGVPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:32926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729379AbgAGVIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:08:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C1E2077B;
        Tue,  7 Jan 2020 21:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431313;
        bh=hH3BpXvUSthOpywz1EXtWem4Tr0fToBTO+LJZEemSFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCB4Ts3bhoBrrXBftsekZZywwAkWAvStq01OtX6XO6A0XjIiRsVzbCUUG0yveJHlx
         Sq203F65BuuWFx5UjLjWikg17n30EexzoJwFMxsde+lFFNSwHia3btsXgrsgxsnIeI
         FegNptjgoOeJ8p2vM44nZFf8OnZx7QkmdCy//6Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.19 089/115] media: flexcop-usb: ensure -EIO is returned on error condition
Date:   Tue,  7 Jan 2020 21:54:59 +0100
Message-Id: <20200107205306.668297634@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 74a96b51a36de4d86660fbc56b05d86668162d6b upstream.

An earlier commit hard coded a return 0 to function flexcop_usb_i2c_req
even though the an -EIO was intended to be returned in the case where
ret != buflen.  Fix this by replacing the return 0 with the return of
ret to return the error return code.

Addresses-Coverity: ("Unused value")

Fixes: b430eaba0be5 ("[media] flexcop-usb: don't use stack for DMA")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/b2c2/flexcop-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -294,7 +294,7 @@ static int flexcop_usb_i2c_req(struct fl
 
 	mutex_unlock(&fc_usb->data_mutex);
 
-	return 0;
+	return ret;
 }
 
 /* actual bus specific access functions,


