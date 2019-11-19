Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7CD101826
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfKSGGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:06:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbfKSFfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3534B20672;
        Tue, 19 Nov 2019 05:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141712;
        bh=LwqOr4I4zulBalz0R9isVxO+q7yNbwDmSBSJJrSTNSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Llxom0+5M/sm6zAUGZwtdCzZS8MiugE3YJzlAmtZPfh0wmwsxa7kgjS3WnI03qTYc
         rMVQs1+2rFWgsykLlG+6fVa856nuo4RM4I07S+a1KMUxT9Ie6f5A257eGTp9/+yrHW
         42pN8JQbAlVP3UEjZR4Guq81aKDaTYOv4Z5z79Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 254/422] ipmi_si: fix potential integer overflow on large shift
Date:   Tue, 19 Nov 2019 06:17:31 +0100
Message-Id: <20191119051415.447335103@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 97a103e6b584442cd848887ed8d47be2410b7e09 ]

Shifting unsigned char b by an int type can lead to sign-extension
overflow. For example, if b is 0xff and the shift is 24, then top
bit is sign-extended so the final value passed to writeq has all
the upper 32 bits set.  Fix this by casting b to a 64 bit unsigned
before the shift.

Detected by CoverityScan, CID#1465246 ("Unintended sign extension")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_si_mem_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_si_mem_io.c b/drivers/char/ipmi/ipmi_si_mem_io.c
index 638f4ab88f445..75583612ab105 100644
--- a/drivers/char/ipmi/ipmi_si_mem_io.c
+++ b/drivers/char/ipmi/ipmi_si_mem_io.c
@@ -51,7 +51,7 @@ static unsigned char mem_inq(const struct si_sm_io *io, unsigned int offset)
 static void mem_outq(const struct si_sm_io *io, unsigned int offset,
 		     unsigned char b)
 {
-	writeq(b << io->regshift, (io->addr)+(offset * io->regspacing));
+	writeq((u64)b << io->regshift, (io->addr)+(offset * io->regspacing));
 }
 #endif
 
-- 
2.20.1



