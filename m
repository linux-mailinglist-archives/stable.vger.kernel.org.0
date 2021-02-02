Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5FC30CBC3
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhBBTex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233364AbhBBN4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 256FA64F6A;
        Tue,  2 Feb 2021 13:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273510;
        bh=9jI4xKYfiKIsaXaY4fKZ3vns/czDlGUzbtr3/Jyq51k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBisOTM9AxBvh9E/3lh1KqatxEYv1TtGkYOldxdnjjsfVy6+ApNBnSWfxPTOkP4TZ
         HhRrZjijdkek0NPqUV7oDSohwHTvFDhzdu7PwaN6pIGSTvWYiDriry26CgJRdh8kem
         TwEXP1A2VqIRXPgvMXSa19rYQu0P2mZ/h3VP2b4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 133/142] NFC: fix resource leak when target index is invalid
Date:   Tue,  2 Feb 2021 14:38:16 +0100
Message-Id: <20210202133003.182032473@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 3a30537cee233fb7da302491b28c832247d89bbe upstream.

Goto to the label put_dev instead of the label error to fix potential
resource leak on path that the target index is invalid.

Fixes: c4fbb6515a4d ("NFC: The core part should generate the target index")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121152748.98409-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/rawsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -105,7 +105,7 @@ static int rawsock_connect(struct socket
 	if (addr->target_idx > dev->target_next_idx - 1 ||
 	    addr->target_idx < dev->target_next_idx - dev->n_targets) {
 		rc = -EINVAL;
-		goto error;
+		goto put_dev;
 	}
 
 	rc = nfc_activate_target(dev, addr->target_idx, addr->nfc_protocol);


