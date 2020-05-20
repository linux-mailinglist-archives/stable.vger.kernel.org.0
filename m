Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57761DBE70
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 21:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgETTyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 15:54:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25799 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgETTyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 15:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590004489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cgN7tmFj25tx6e5PNZ63Ky6t5MTHpxwjxxdlmrg0Pyc=;
        b=NPUvV/T5v29fb6cSZOO2rwFRpSGiNkoeffCUFULKIvx+sScg2bAWfUlHjaj4Ast/BFsPUi
        alq7/Rv6W5Ia7iEUeGhPQU6Yu5XE61EllvxTLAeJrpZoTBoRVibiWt+kRYcfVhOHOvlg21
        g/JHTgBf9DjQ5WDMUExpDZ2JJhOVD70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-f6ceAZVSNqGPNn9dNvUk0A-1; Wed, 20 May 2020 15:54:46 -0400
X-MC-Unique: f6ceAZVSNqGPNn9dNvUk0A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED936100530A;
        Wed, 20 May 2020 19:54:44 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-91.ams2.redhat.com [10.36.112.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D35941943D;
        Wed, 20 May 2020 19:54:43 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/8] virt: vbox: Fix guest capabilities mask check
Date:   Wed, 20 May 2020 21:54:34 +0200
Message-Id: <20200520195440.38759-2-hdegoede@redhat.com>
In-Reply-To: <20200520195440.38759-1-hdegoede@redhat.com>
References: <20200520195440.38759-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check the passed in capabilities against VMMDEV_GUEST_CAPABILITIES_MASK
instead of against VMMDEV_EVENT_VALID_EVENT_MASK.
This tightens the allowed mask from 0x7ff to 0x7.

Fixes: 0ba002bc4393 ("virt: Add vboxguest driver for Virtual Box Guest integration")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/virt/vboxguest/vboxguest_core.c | 2 +-
 drivers/virt/vboxguest/vmmdev.h         | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/vboxguest/vboxguest_core.c b/drivers/virt/vboxguest/vboxguest_core.c
index 8fab04e76c14..18ebd7a6af98 100644
--- a/drivers/virt/vboxguest/vboxguest_core.c
+++ b/drivers/virt/vboxguest/vboxguest_core.c
@@ -1444,7 +1444,7 @@ static int vbg_ioctl_change_guest_capabilities(struct vbg_dev *gdev,
 	or_mask = caps->u.in.or_mask;
 	not_mask = caps->u.in.not_mask;
 
-	if ((or_mask | not_mask) & ~VMMDEV_EVENT_VALID_EVENT_MASK)
+	if ((or_mask | not_mask) & ~VMMDEV_GUEST_CAPABILITIES_MASK)
 		return -EINVAL;
 
 	ret = vbg_set_session_capabilities(gdev, session, or_mask, not_mask,
diff --git a/drivers/virt/vboxguest/vmmdev.h b/drivers/virt/vboxguest/vmmdev.h
index 6337b8d75d96..21f408120e3f 100644
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
-- 
2.26.2

