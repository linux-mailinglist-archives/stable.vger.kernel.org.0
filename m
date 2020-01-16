Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9675613FFD8
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390767AbgAPXVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733270AbgAPXVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8ACC2072B;
        Thu, 16 Jan 2020 23:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216870;
        bh=iwbzRoMlWNxTx6ctffmQh4iUTa8eAHWNn/VOMT8iP6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfT57ydR/bUHwQb5Xh8XkyhsHcSIQOQjQsDVY/V6ghcfkynmMm6QN2X/qIOBbIMTv
         82rKapmrHcaekyRLLuMxG85kCUDkZHnv6UB4C/4Az+2gdEx9sBczVLI62x/xQSrR1i
         cQhwZYEzFWsak5vjQ4tyUki3EtE6SApbQbLbXNB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 037/203] s390/qeth: fix initialization on old HW
Date:   Fri, 17 Jan 2020 00:15:54 +0100
Message-Id: <20200116231747.356660900@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

commit 0b698c838e84149b690c7e979f78cccb6f8aa4b9 upstream.

I stumbled over an old OSA model that claims to support DIAG_ASSIST,
but then rejects the cmd to query its DIAG capabilities.

In the old code this was ok, as the returned raw error code was > 0.
Now that we translate the raw codes to errnos, the "rc < 0" causes us
to fail the initialization of the device.

The fix is trivial: don't bail out when the DIAG query fails. Such an
error is not critical, we can still use the device (with a slightly
reduced set of features).

Fixes: 742d4d40831d ("s390/qeth: convert remaining legacy cmd callbacks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/net/qeth_core_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4968,10 +4968,8 @@ retriable:
 	}
 	if (qeth_adp_supported(card, IPA_SETADP_SET_DIAG_ASSIST)) {
 		rc = qeth_query_setdiagass(card);
-		if (rc < 0) {
+		if (rc)
 			QETH_CARD_TEXT_(card, 2, "8err%d", rc);
-			goto out;
-		}
 	}
 	return 0;
 out:


