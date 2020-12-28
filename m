Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60E22E3E7E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502546AbgL1O2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502554AbgL1O2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 615C1221F0;
        Mon, 28 Dec 2020 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165687;
        bh=IQ6vgFz9x4ScKW4PKMTUZSzjyHMKBWg0BaUAwIo9Bg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XI5esLmJbU5hCEthC5VYwGNxYS9bkcBPtL78RMYyMnkOgCruVcrxg8eSIhJDJtZb0
         IJq/bIMnwqgrIQvBKqH4Js/wE3xu0AWciNfWrt+qJf39dMTBQWEteJC+ZVk1B/WdwV
         VUlbQNwZDyod635TJeqqjyDQD5t51zHIwq2tm4hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 620/717] um: Remove use of asprinf in umid.c
Date:   Mon, 28 Dec 2020 13:50:18 +0100
Message-Id: <20201228125050.632289154@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

commit 97be7ceaf7fea68104824b6aa874cff235333ac1 upstream.

asprintf is not compatible with the existing uml memory allocation
mechanism. Its use on the "user" side of UML results in a corrupt slab
state.

Fixes: 0d4e5ac7e780 ("um: remove uses of variable length arrays")
Cc: stable@vger.kernel.org
Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/os-Linux/umid.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/arch/um/os-Linux/umid.c
+++ b/arch/um/os-Linux/umid.c
@@ -137,20 +137,13 @@ static inline int is_umdir_used(char *di
 {
 	char pid[sizeof("nnnnnnnnn")], *end, *file;
 	int dead, fd, p, n, err;
-	size_t filelen;
+	size_t filelen = strlen(dir) + sizeof("/pid") + 1;
 
-	err = asprintf(&file, "%s/pid", dir);
-	if (err < 0)
-		return 0;
+	file = malloc(filelen);
+	if (!file)
+		return -ENOMEM;
 
-	filelen = strlen(file);
-
-	n = snprintf(file, filelen, "%s/pid", dir);
-	if (n >= filelen) {
-		printk(UM_KERN_ERR "is_umdir_used - pid filename too long\n");
-		err = -E2BIG;
-		goto out;
-	}
+	snprintf(file, filelen, "%s/pid", dir);
 
 	dead = 0;
 	fd = open(file, O_RDONLY);


