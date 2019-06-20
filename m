Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF234D7CD
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfFTSKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfFTSKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:10:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C25321537;
        Thu, 20 Jun 2019 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054246;
        bh=zgbUZHD2UZoYFx3E8SfXLifV6MSgtlLNZd2Kb/AYhUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iolHElDxNhkKy5B/aPERTXogiP5Xz+esA2D8w7Fw6XIn7qOZ+e/Fhy969FFAgHENF
         kmpJR1LjWLNe3vafOwT9cy1bM+L0Jh34/V0hs/cv5gGZHAWFUn0cfeX2yF2hTfPAWY
         5WlJT8gvZYiLFaTqElnCjeIxYHWuC8apYnMJ8nEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/61] usb: xhci: Fix a potential null pointer dereference in xhci_debugfs_create_endpoint()
Date:   Thu, 20 Jun 2019 19:57:19 +0200
Message-Id: <20190620174341.492732267@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



