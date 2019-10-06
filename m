Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74274CD744
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbfJFRyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728644AbfJFRya (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:54:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D6FC22469;
        Sun,  6 Oct 2019 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383971;
        bh=QYuncw7U6eCu+v+lSMJpPfdq8LmiWt9sdzhJZ8oWmNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYoTfUH5FBdrKW6tmkzt5awG6PavgbrPFyZVt0Zu/hcgx50Ty3qDuEL9Q+YPSsvFv
         A1EI7vzGyyNJiwDetfKZBU9z2Hmheb96bo3Ze0/fM0/Zbb2H0EO9wbRr8sAfoSNrLk
         jdk9SAIqY6Crqr6EFxqVQXlFBHu2/b5kUphapKLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 162/166] NFC: fix attrs checks in netlink interface
Date:   Sun,  6 Oct 2019 19:22:08 +0200
Message-Id: <20191006171226.494412163@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

commit 18917d51472fe3b126a3a8f756c6b18085eb8130 upstream.

nfc_genl_deactivate_target() relies on the NFC_ATTR_TARGET_INDEX
attribute being present, but doesn't check whether it is actually
provided by the user. Same goes for nfc_genl_fw_download() and
NFC_ATTR_FIRMWARE_NAME.

This patch adds appropriate checks.

Found with syzkaller.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/netlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -970,7 +970,8 @@ static int nfc_genl_dep_link_down(struct
 	int rc;
 	u32 idx;
 
-	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
+	    !info->attrs[NFC_ATTR_TARGET_INDEX])
 		return -EINVAL;
 
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
@@ -1018,7 +1019,8 @@ static int nfc_genl_llc_get_params(struc
 	struct sk_buff *msg = NULL;
 	u32 idx;
 
-	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
+	    !info->attrs[NFC_ATTR_FIRMWARE_NAME])
 		return -EINVAL;
 
 	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);


