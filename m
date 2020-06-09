Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D731F441B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733143AbgFISAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731571AbgFIRyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DCC520774;
        Tue,  9 Jun 2020 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725257;
        bh=XEGidvdyGCOiAiBQ9Tc8EFoGZ03ZmvSA/xlWKKMAXOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFQPGNtZTA/ug4qD1sgjpPxjqtzJ+3I33slp85jX15vKs42Qt7cJKxPADoWz2m/eg
         C+SAfDmbMX2sV/LJUGWlv1f8lg7i9gb2g/IWVysZKzl0HE5HIWh2EPNqBqGf2ArzkM
         3p7K4rg4gi3LDWeitlTtYjNSeX/eP1TfNJNNq9YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jean Rene Dawin <jdawin@math.uni-bielefeld.de>
Subject: [PATCH 5.6 33/41] CDC-ACM: heed quirk also in error handling
Date:   Tue,  9 Jun 2020 19:45:35 +0200
Message-Id: <20200609174115.238537419@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 97fe809934dd2b0b37dfef3a2fc70417f485d7af upstream.

If buffers are iterated over in the error case, the lower limits
for quirky devices must be heeded.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Jean Rene Dawin <jdawin@math.uni-bielefeld.de>
Fixes: a4e7279cd1d19 ("cdc-acm: introduce a cool down")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200526124420.22160-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -584,7 +584,7 @@ static void acm_softint(struct work_stru
 	}
 
 	if (test_and_clear_bit(ACM_ERROR_DELAY, &acm->flags)) {
-		for (i = 0; i < ACM_NR; i++)
+		for (i = 0; i < acm->rx_buflimit; i++)
 			if (test_and_clear_bit(i, &acm->urbs_in_error_delay))
 					acm_submit_read_urb(acm, i, GFP_NOIO);
 	}


