Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8EFD9DEC
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395082AbfJPVyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390245AbfJPVyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:51 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C14D20872;
        Wed, 16 Oct 2019 21:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262890;
        bh=VSbXwjB/rESacjz5cqElma2cY0HPqi2u7mtCeUhEyZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zBQ7Vlp7OPtns3VJbGF8JftDCop5d3lUOHJF56V1Dvd2EunBvNiHeAeDpKCn1ECI4
         RugevvriTnKldO3xRXEsIcFH8XdC6o/8jMHw3Ylshv2hvJ0z90KQA3lb43yUJWol52
         6YE4rpWHZ/LoAnUAmfuHEKTm8JW7k5BGt7RaG7Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 4.9 47/92] USB: adutux: remove redundant variable minor
Date:   Wed, 16 Oct 2019 14:50:20 -0700
Message-Id: <20191016214834.728835208@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 8444efc4a052332d643ed5c8aebcca148c7de032 upstream.

Variable minor is being assigned but never read, hence it is redundant
and can be removed. Cleans up clang warning:

drivers/usb/misc/adutux.c:770:2: warning: Value stored to 'minor' is
never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/adutux.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -789,13 +789,11 @@ error:
 static void adu_disconnect(struct usb_interface *interface)
 {
 	struct adu_device *dev;
-	int minor;
 
 	dev = usb_get_intfdata(interface);
 
 	mutex_lock(&dev->mtx);	/* not interruptible */
 	dev->udev = NULL;	/* poison */
-	minor = dev->minor;
 	usb_deregister_dev(interface, &adu_class);
 	mutex_unlock(&dev->mtx);
 


