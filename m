Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 038C7616F6
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfGGToF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:44:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57346 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727559AbfGGTiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:09 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0006hb-8i; Sun, 07 Jul 2019 20:38:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0005bc-QZ; Sun, 07 Jul 2019 20:38:02 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "Jia Zhang" <zhang.jia@linux.alibaba.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.519842194@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 066/129] tpm: Fix off-by-one when reading
 binary_bios_measurements
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Zhang <zhang.jia@linux.alibaba.com>

commit 64494d39ff630a63b5308042b20132b491e3706b upstream.

It is unable to read the entry when it is the only one in
binary_bios_measurements:

00000000  00 00 00 00 08 00 00 00  c4 2f ed ad 26 82 00 cb
00000010  1d 15 f9 78 41 c3 44 e7  9d ae 33 20 00 00 00 00
00000020

This is obviously a firmware problem on my linux machine:

	Manufacturer: Inspur
	Product Name: SA5212M4
	Version: 01

However, binary_bios_measurements should return it any way,
rather than nothing, after all its content is completely
valid.

Fixes: 55a82ab3181b ("tpm: add bios measurement log")
Signed-off-by: Jia Zhang <zhang.jia@linux.alibaba.com>
Reviewd-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
[bwh: Backported to 3.16:
 - Fix an additional comparison in tpm1_bios_measurements_start()
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -81,7 +81,7 @@ static void *tpm_bios_measurements_start
 	for (i = 0; i < *pos; i++) {
 		event = addr;
 
-		if ((addr + sizeof(struct tcpa_event)) < limit) {
+		if ((addr + sizeof(struct tcpa_event)) <= limit) {
 			if (event->event_type == 0 && event->event_size == 0)
 				return NULL;
 			addr += sizeof(struct tcpa_event) + event->event_size;
@@ -89,13 +89,13 @@ static void *tpm_bios_measurements_start
 	}
 
 	/* now check if current entry is valid */
-	if ((addr + sizeof(struct tcpa_event)) >= limit)
+	if ((addr + sizeof(struct tcpa_event)) > limit)
 		return NULL;
 
 	event = addr;
 
 	if ((event->event_type == 0 && event->event_size == 0) ||
-	    ((addr + sizeof(struct tcpa_event) + event->event_size) >= limit))
+	    ((addr + sizeof(struct tcpa_event) + event->event_size) > limit))
 		return NULL;
 
 	return addr;
@@ -111,7 +111,7 @@ static void *tpm_bios_measurements_next(
 	v += sizeof(struct tcpa_event) + event->event_size;
 
 	/* now check if current entry is valid */
-	if ((v + sizeof(struct tcpa_event)) >= limit)
+	if ((v + sizeof(struct tcpa_event)) > limit)
 		return NULL;
 
 	event = v;
@@ -120,7 +120,7 @@ static void *tpm_bios_measurements_next(
 		return NULL;
 
 	if ((event->event_type == 0 && event->event_size == 0) ||
-	    ((v + sizeof(struct tcpa_event) + event->event_size) >= limit))
+	    ((v + sizeof(struct tcpa_event) + event->event_size) > limit))
 		return NULL;
 
 	(*pos)++;

