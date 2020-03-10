Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D2917FBC1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgCJNMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729230AbgCJNMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:12:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 544C120409;
        Tue, 10 Mar 2020 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845962;
        bh=AB3A3EN5bgLeJbsr19jt0Pt9O73+r4j8zG6bQbnFd+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCWGmpRoopu/XLW4rRlPOAA4i8VLAHt0LvmuU69mOtG+EWRHVj0n+kiT9ZeeNZ0Cg
         2D1uh7e6bZvspjif5baB9Z0OiAnIDYus9NGqXUgLY7wGT5EQXWmDELl3N/5JVYvKbH
         2FM9ZTFjnvcW/BCXglAvKc+rSUbf2PGL4Yg+8xI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.19 38/86] usb: core: hub: fix unhandled return by employing a void function
Date:   Tue, 10 Mar 2020 13:45:02 +0100
Message-Id: <20200310124532.839754769@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>

commit 63d6d7ed475c53dc1cabdfedf63de1fd8dcd72ee upstream.

Address below Coverity complaint (Feb 25, 2020, 8:06 AM CET):

---
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1833,7 +1833,7 @@ static int hub_probe(struct usb_interfac
 
 	if (id->driver_info & HUB_QUIRK_DISABLE_AUTOSUSPEND) {
 		hub->quirk_disable_autosuspend = 1;
-		usb_autopm_get_interface(intf);
+		usb_autopm_get_interface_no_resume(intf);
 	}
 
 	if (hub_configure(hub, &desc->endpoint[0].desc) >= 0)


