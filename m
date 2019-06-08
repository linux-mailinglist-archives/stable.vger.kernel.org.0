Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983AD39E05
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfFHLnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbfFHLnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:43:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C96AD214AF;
        Sat,  8 Jun 2019 11:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994189;
        bh=lwKR71ZRj7Zr9zES63ArSSUXvbi1ImHyvWXs/ZGcBfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWb29LW2GOFLlDpTN/RBIbysS1d/eJQJ1CzDx9Yxh9p4Bs1lSLJV6gLVnFUQ/7RPd
         eSUQYNfnuGV4lSJ0C4Jv1Le5gYb4eW1ITan6ONBXJHEXLjoHud54uqafVaNJ66mmwz
         h8rxdRRboX/qt4Lz3JZeIb4A6w0VtE27yui3N4hI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/49] usb: xhci: Fix a potential null pointer dereference in xhci_debugfs_create_endpoint()
Date:   Sat,  8 Jun 2019 07:41:51 -0400
Message-Id: <20190608114232.8731-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114232.8731-1-sashal@kernel.org>
References: <20190608114232.8731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 5bce256f0b528624a34fe907db385133bb7be33e ]

In xhci_debugfs_create_slot(), kzalloc() can fail and
dev->debugfs_private will be NULL.
In xhci_debugfs_create_endpoint(), dev->debugfs_private is used without
any null-pointer check, and can cause a null pointer dereference.

To fix this bug, a null-pointer check is added in
xhci_debugfs_create_endpoint().

This bug is found by a runtime fuzzing tool named FIZZER written by us.

[subjet line change change, add potential -Mathais]
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci-debugfs.c b/drivers/usb/host/xhci-debugfs.c
index cadc01336bf8..7ba6afc7ef23 100644
--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -440,6 +440,9 @@ void xhci_debugfs_create_endpoint(struct xhci_hcd *xhci,
 	struct xhci_ep_priv	*epriv;
 	struct xhci_slot_priv	*spriv = dev->debugfs_private;
 
+	if (!spriv)
+		return;
+
 	if (spriv->eps[ep_index])
 		return;
 
-- 
2.20.1

