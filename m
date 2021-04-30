Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0423E36FC34
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhD3OWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhD3OWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:22:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B8B761462;
        Fri, 30 Apr 2021 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792473;
        bh=ehPkF3RaxD2CIqmUjSPRG1tSe3Cb5HSOfYBWDqMUJOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9PKqTSw+sZQTE96TIRzhR5ItNkUpjnCRMIPGndROxuRSkBVATbvmPwRS7LWoQ8x+
         eKg/ODo10KRnkPXpzHALUaB+aS6RdEAZl/gah+JMc6yI0DkOifxAKcW+eLaBN9v+J6
         FhJ+B2+kSUOh7nO8D4XN4Xmw596HSOpR0xsvGnAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.12 2/5] USB: CDC-ACM: fix poison/unpoison imbalance
Date:   Fri, 30 Apr 2021 16:20:57 +0200
Message-Id: <20210430141910.975059660@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141910.899518186@linuxfoundation.org>
References: <20210430141910.899518186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit a8b3b519618f30a87a304c4e120267ce6f8dc68a upstream.

suspend() does its poisoning conditionally, resume() does it
unconditionally. On a device with combined interfaces this
will balance, on a device with two interfaces the counter will
go negative and resubmission will fail.

Both actions need to be done conditionally.

Fixes: 6069e3e927c8f ("USB: cdc-acm: untangle a circular dependency between callback and softint")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210421074513.4327-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1634,12 +1634,13 @@ static int acm_resume(struct usb_interfa
 	struct urb *urb;
 	int rv = 0;
 
-	acm_unpoison_urbs(acm);
 	spin_lock_irq(&acm->write_lock);
 
 	if (--acm->susp_count)
 		goto out;
 
+	acm_unpoison_urbs(acm);
+
 	if (tty_port_initialized(&acm->port)) {
 		rv = usb_submit_urb(acm->ctrlurb, GFP_ATOMIC);
 


