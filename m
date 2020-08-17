Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F79246B50
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387872AbgHQPwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387861AbgHQPwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:52:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2976820885;
        Mon, 17 Aug 2020 15:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679562;
        bh=/1ramI7N/PC/FCx1+3BMK/mKLPfXJVkRCE13JhUik0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16Ti1SJ0k3hTx5St89zqILwMb/ZSkZDDKHViWgRSpj4xOx5gv1ROKsVCf//LLGD2t
         ugf2iFMu5ndFfO2jy3jSDi6BlQyYqwxAnAG6MdVLPj8jc446vrLV0bpAmBoBiiUArB
         OaJSydNhoEmZDzhOlHSDl3h7D83wbVyY20U8hMbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kars Mulder <kerneldev@karsmulder.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 226/393] usb: core: fix quirks_param_set() writing to a const pointer
Date:   Mon, 17 Aug 2020 17:14:36 +0200
Message-Id: <20200817143830.587028784@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kars Mulder <kerneldev@karsmulder.nl>

[ Upstream commit b1b6bed3b5036509b449b5965285d5057ba42527 ]

The function quirks_param_set() takes as argument a const char* pointer
to the new value of the usbcore.quirks parameter. It then casts this
pointer to a non-const char* pointer and passes it to the strsep()
function, which overwrites the value.

Fix this by creating a copy of the value using kstrdup() and letting
that copy be written to by strsep().

Fixes: 027bd6cafd9a ("usb: core: Add "quirks" parameter for usbcore")
Signed-off-by: Kars Mulder <kerneldev@karsmulder.nl>

Link: https://lore.kernel.org/r/5ee2-5f048a00-21-618c5c00@230659773
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index e0b77674869ce..c96c50faccf72 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -25,17 +25,23 @@ static unsigned int quirk_count;
 
 static char quirks_param[128];
 
-static int quirks_param_set(const char *val, const struct kernel_param *kp)
+static int quirks_param_set(const char *value, const struct kernel_param *kp)
 {
-	char *p, *field;
+	char *val, *p, *field;
 	u16 vid, pid;
 	u32 flags;
 	size_t i;
 	int err;
 
+	val = kstrdup(value, GFP_KERNEL);
+	if (!val)
+		return -ENOMEM;
+
 	err = param_set_copystring(val, kp);
-	if (err)
+	if (err) {
+		kfree(val);
 		return err;
+	}
 
 	mutex_lock(&quirk_mutex);
 
@@ -60,10 +66,11 @@ static int quirks_param_set(const char *val, const struct kernel_param *kp)
 	if (!quirk_list) {
 		quirk_count = 0;
 		mutex_unlock(&quirk_mutex);
+		kfree(val);
 		return -ENOMEM;
 	}
 
-	for (i = 0, p = (char *)val; p && *p;) {
+	for (i = 0, p = val; p && *p;) {
 		/* Each entry consists of VID:PID:flags */
 		field = strsep(&p, ":");
 		if (!field)
@@ -144,6 +151,7 @@ static int quirks_param_set(const char *val, const struct kernel_param *kp)
 
 unlock:
 	mutex_unlock(&quirk_mutex);
+	kfree(val);
 
 	return 0;
 }
-- 
2.25.1



