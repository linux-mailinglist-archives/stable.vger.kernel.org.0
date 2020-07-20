Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF05226598
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbgGTPzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbgGTPzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:55:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157912065E;
        Mon, 20 Jul 2020 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260507;
        bh=/1F5DfyPEiFatuucRq9wLd+j+KSGjk050XpQErs1I2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyNuS287sm924p+ZH63Wiv2Qmj7P59Hmzs78if0BuvkblDzyax5xwWXwrC5Umq5f0
         mLliW8el7WxuC3V1scF7YvPR2TAdPeJqJaK9V/WtKd3bkG4q+PT/eFcPGR5qPw6cDE
         HML8oTr1u7ImeYqQ28qtlwhOc/Wpf6VxUoYo/P2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4.19 100/133] virt: vbox: Fix guest capabilities mask check
Date:   Mon, 20 Jul 2020 17:37:27 +0200
Message-Id: <20200720152808.560790960@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 59d1d2e8e1e7c50d2657d5e4812b53f71f507968 upstream.

Check the passed in capabilities against VMMDEV_GUEST_CAPABILITIES_MASK
instead of against VMMDEV_EVENT_VALID_EVENT_MASK.
This tightens the allowed mask from 0x7ff to 0x7.

Fixes: 0ba002bc4393 ("virt: Add vboxguest driver for Virtual Box Guest integration")
Cc: stable@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200709120858.63928-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virt/vboxguest/vboxguest_core.c |    2 +-
 drivers/virt/vboxguest/vmmdev.h         |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/virt/vboxguest/vboxguest_core.c
+++ b/drivers/virt/vboxguest/vboxguest_core.c
@@ -1408,7 +1408,7 @@ static int vbg_ioctl_change_guest_capabi
 	or_mask = caps->u.in.or_mask;
 	not_mask = caps->u.in.not_mask;
 
-	if ((or_mask | not_mask) & ~VMMDEV_EVENT_VALID_EVENT_MASK)
+	if ((or_mask | not_mask) & ~VMMDEV_GUEST_CAPABILITIES_MASK)
 		return -EINVAL;
 
 	ret = vbg_set_session_capabilities(gdev, session, or_mask, not_mask,
--- a/drivers/virt/vboxguest/vmmdev.h
+++ b/drivers/virt/vboxguest/vmmdev.h
@@ -206,6 +206,8 @@ VMMDEV_ASSERT_SIZE(vmmdev_mask, 24 + 8);
  * not.
  */
 #define VMMDEV_GUEST_SUPPORTS_GRAPHICS                      BIT(2)
+/* The mask of valid capabilities, for sanity checking. */
+#define VMMDEV_GUEST_CAPABILITIES_MASK                      0x00000007U
 
 /** struct vmmdev_hypervisorinfo - Hypervisor info structure. */
 struct vmmdev_hypervisorinfo {


