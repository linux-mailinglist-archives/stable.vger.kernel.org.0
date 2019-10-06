Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52265CD706
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfJFRi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbfJFRiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:38:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7B2C2053B;
        Sun,  6 Oct 2019 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383535;
        bh=QYuncw7U6eCu+v+lSMJpPfdq8LmiWt9sdzhJZ8oWmNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYL0fCWSR4lmYw0FynYFKi31rD4FeunxtEIcgaCHZbc88WB2d/LpMIwvlqGsYKYdN
         ezCerJr2lmfxtXsPaViGAee7K1e1xcQ2YOxk+HCnVHUsNami2sPMYUpU/y/pImTHc1
         mSN/DHbLrsjMDIC43dx+vZnmP5SF0KGhmyGHnJzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 133/137] NFC: fix attrs checks in netlink interface
Date:   Sun,  6 Oct 2019 19:21:57 +0200
Message-Id: <20191006171220.461067562@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
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


