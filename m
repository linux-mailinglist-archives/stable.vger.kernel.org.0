Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E7C1220AC
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLQA5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:57:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35014 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbfLQAvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003LR-H8; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005VD-6d; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>,
        "Ulf Hansson" <ulf.hansson@linaro.org>
Date:   Tue, 17 Dec 2019 00:46:23 +0000
Message-ID: <lsq.1576543535.52329631@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 049/136] memstick: jmb38x_ms: Fix an error handling
 path in 'jmb38x_ms_probe()'
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 28c9fac09ab0147158db0baeec630407a5e9b892 upstream.

If 'jmb38x_ms_count_slots()' returns 0, we must undo the previous
'pci_request_regions()' call.

Goto 'err_out_int' to fix it.

Fixes: 60fdd931d577 ("memstick: add support for JMicron jmb38x MemoryStick host controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/memstick/host/jmb38x_ms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -947,7 +947,7 @@ static int jmb38x_ms_probe(struct pci_de
 	if (!cnt) {
 		rc = -ENODEV;
 		pci_dev_busy = 1;
-		goto err_out;
+		goto err_out_int;
 	}
 
 	jm = kzalloc(sizeof(struct jmb38x_ms)

