Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B197E2F167D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbhAKNxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbhAKNIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 710722251F;
        Mon, 11 Jan 2021 13:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370475;
        bh=03QIzvnRplZlJC1D4Z2elr/xFNXfVFUhnrgchIP0d/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlXgZpGhzxprCfEiLmHvPgwkEYTsH86Admq9CWHrXCDzsTJMh3SfL2G3z013Xvgbn
         qVq1iY02DlF6H5sQ0/jxY7SNOASmbTxUq55OvsYFz5G75ccEX/Fq/rfJesfWjxnfm+
         Iz58b8MT8VpqQ++YwokOf7aPxEJZ2m49dsMm9pLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.19 39/77] Bluetooth: revert: hci_h5: close serdev device and free hu in h5_close
Date:   Mon, 11 Jan 2021 14:01:48 +0100
Message-Id: <20210111130038.290994079@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 5c3b5796866f85354a5ce76a28f8ffba0dcefc7e upstream.

There have been multiple revisions of the patch fix the h5->rx_skb
leak. Accidentally the first revision (which is buggy) and v5 have
both been merged:

v1 commit 70f259a3f427 ("Bluetooth: hci_h5: close serdev device and free
hu in h5_close");
v5 commit 855af2d74c87 ("Bluetooth: hci_h5: fix memory leak in h5_close")

The correct v5 makes changes slightly higher up in the h5_close()
function, which allowed both versions to get merged without conflict.

The changes from v1 unconditionally frees the h5 data struct, this
is wrong because in the serdev enumeration case the memory is
allocated in h5_serdev_probe() like this:

        h5 = devm_kzalloc(dev, sizeof(*h5), GFP_KERNEL);

So its lifetime is tied to the lifetime of the driver being bound
to the serdev and it is automatically freed when the driver gets
unbound. In the serdev case the same h5 struct is re-used over
h5_close() and h5_open() calls and thus MUST not be free-ed in
h5_close().

The serdev_device_close() added to h5_close() is incorrect in the
same way, serdev_device_close() is called on driver unbound too and
also MUST no be called from h5_close().

This reverts the changes made by merging v1 of the patch, so that
just the changes of the correct v5 remain.

Cc: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_h5.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -263,12 +263,8 @@ static int h5_close(struct hci_uart *hu)
 	if (h5->vnd && h5->vnd->close)
 		h5->vnd->close(h5);
 
-	if (hu->serdev)
-		serdev_device_close(hu->serdev);
-
-	kfree_skb(h5->rx_skb);
-	kfree(h5);
-	h5 = NULL;
+	if (!hu->serdev)
+		kfree(h5);
 
 	return 0;
 }


