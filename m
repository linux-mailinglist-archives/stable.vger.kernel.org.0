Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A7E2E3BED
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404783AbgL1N4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407852AbgL1N4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 325F921D94;
        Mon, 28 Dec 2020 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163736;
        bh=Ozb6FoNu4dexz7v04R9eUZUqUWtOG50d1+5FMMFhUqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16Gzm9CrKdoxkFDOlfTedKJ1jfubl2lioakzCZT4h064RGUx+BUueDf8VMhzr9hvn
         ecf8p6eKCk+kRbCey/TtZVGo2XcLLG/fScGTU1efWWiT3ndVsjyU7Cm9qM5ZhCciJ8
         2+Cvcz/gA0tcQAZnHBmJfq8AxV9JEJfNbCo7igkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 390/453] um: Remove use of asprinf in umid.c
Date:   Mon, 28 Dec 2020 13:50:26 +0100
Message-Id: <20201228124955.974756850@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
 	char pid[sizeof("nnnnn\0")], *end, *file;
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


