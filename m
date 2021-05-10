Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E357378336
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhEJKmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhEJKlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4533461971;
        Mon, 10 May 2021 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642722;
        bh=7hBYsmq3KtSYF2pUFkYJxrX++i1XE/CS+Ns8JFKTeL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mh7el/fLeKpCxk2ilIzAlBljV1azGybxEzhLsdEi+mZW1naOpRU/5eRBB1EVV3dXx
         B9tOzXO4S06y9o0sfyFQhpvcnYttX1gHt2N7gApQF2VLEeRP/iJqXRfA1N4BYgR9oy
         rDCrjG00BTvcepDVk+8EEK/o8PcYOPtNHI3RZnRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Hartmayer <mhartmay@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 007/299] s390/zcrypt: fix zcard and zqueue hot-unplug memleak
Date:   Mon, 10 May 2021 12:16:44 +0200
Message-Id: <20210510102005.068076700@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

commit 70fac8088cfad9f3b379c9082832b4d7532c16c2 upstream.

Tests with kvm and a kmemdebug kernel showed, that on hot unplug the
zcard and zqueue structs for the unplugged card or queue are not
properly freed because of a mismatch with get/put for the embedded
kref counter.

This fix now adjusts the handling of the kref counters. With init the
kref counter starts with 1. This initial value needs to drop to zero
with the unregister of the card or queue to trigger the release and
free the object.

Fixes: 29c2680fd2bf ("s390/ap: fix ap devices reference counting")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_card.c  |    1 +
 drivers/s390/crypto/zcrypt_queue.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/s390/crypto/zcrypt_card.c
+++ b/drivers/s390/crypto/zcrypt_card.c
@@ -192,5 +192,6 @@ void zcrypt_card_unregister(struct zcryp
 	spin_unlock(&zcrypt_list_lock);
 	sysfs_remove_group(&zc->card->ap_dev.device.kobj,
 			   &zcrypt_card_attr_group);
+	zcrypt_card_put(zc);
 }
 EXPORT_SYMBOL(zcrypt_card_unregister);
--- a/drivers/s390/crypto/zcrypt_queue.c
+++ b/drivers/s390/crypto/zcrypt_queue.c
@@ -223,5 +223,6 @@ void zcrypt_queue_unregister(struct zcry
 	sysfs_remove_group(&zq->queue->ap_dev.device.kobj,
 			   &zcrypt_queue_attr_group);
 	zcrypt_card_put(zc);
+	zcrypt_queue_put(zq);
 }
 EXPORT_SYMBOL(zcrypt_queue_unregister);


