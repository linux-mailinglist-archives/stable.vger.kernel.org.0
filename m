Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD671ACC34
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410558AbgDPP5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895792AbgDPN2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:28:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2407221D82;
        Thu, 16 Apr 2020 13:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043717;
        bh=IXc2+E9hVVLIpvFapORhoJC08y/a0HDb+C+wTixsHN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hK29YDlSkkaXGBtEMD1kEZVZcz4pPWBv+cy/1r2iRyGYdphIYmROnJqu2P7sHl/mt
         mfSThRX7r3Tf6c+ipZXycNGMU9eDZwtCc7I5zcfgCkBYlrZlJLy58vRUxlNRFu03Kg
         WfKSrTOunhU+epRvRSzsq8EQGpV3HWa4Ylta0bl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 4.19 070/146] tpm: tpm2_bios_measurements_next should increase position index
Date:   Thu, 16 Apr 2020 15:23:31 +0200
Message-Id: <20200416131252.532858013@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit f9bf8adb55cd5a357b247a16aafddf8c97b276e0 upstream.

If .next function does not change position index,
following .show function will repeat output related
to current position index.

For /sys/kernel/security/tpm0/binary_bios_measurements:
1) read after lseek beyound end of file generates whole last line.
2) read after lseek to middle of last line generates
expected end of last line and unexpected whole last line once again.

Cc: stable@vger.kernel.org # 4.19.x
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/eventlog/tpm2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tpm/eventlog/tpm2.c
+++ b/drivers/char/tpm/eventlog/tpm2.c
@@ -143,6 +143,7 @@ static void *tpm2_bios_measurements_next
 	size_t event_size;
 	void *marker;
 
+	(*pos)++;
 	event_header = log->bios_event_log;
 
 	if (v == SEQ_START_TOKEN) {
@@ -167,7 +168,6 @@ static void *tpm2_bios_measurements_next
 	if (((v + event_size) >= limit) || (event_size == 0))
 		return NULL;
 
-	(*pos)++;
 	return v;
 }
 


