Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857112171A1
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgGGPWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729884AbgGGPWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 352BE206E2;
        Tue,  7 Jul 2020 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135357;
        bh=K0CLogGZWlodpjrfwb0pe+ZZdvaZn1MTmQelP12Mxfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rymcV+IViFngStWOJ//HpIFVM+8FJuL4d68lziuJu2Cb+z7DdIRelW9BMRGyCA0+9
         RLiZLAUn4RRWJGzdBYfGzZ2LMustFuW1Paluykzc1yolbB1IRd+uUKmJezbQq2EZBQ
         8thBuSsIqCAMPERXYQ/4S1ahY4F/zBEB3k1PGhD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Hyeongseok.Kim" <Hyeongseok@gmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 001/112] exfat: Set the unused characters of FileName field to the value 0000h
Date:   Tue,  7 Jul 2020 17:16:06 +0200
Message-Id: <20200707145801.001010596@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeongseok.Kim <Hyeongseok@gmail.com>

[ Upstream commit 4ba6ccd695f5ed3ae851e59b443b757bbe4557fe ]

Some fsck tool complain that padding part of the FileName field
is not set to the value 0000h. So let's maintain filesystem cleaner,
as exfat's spec. recommendation.

Signed-off-by: Hyeongseok.Kim <Hyeongseok@gmail.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 4b91afb0f0515..349ca0c282c2c 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -430,10 +430,12 @@ static void exfat_init_name_entry(struct exfat_dentry *ep,
 	ep->dentry.name.flags = 0x0;
 
 	for (i = 0; i < EXFAT_FILE_NAME_LEN; i++) {
-		ep->dentry.name.unicode_0_14[i] = cpu_to_le16(*uniname);
-		if (*uniname == 0x0)
-			break;
-		uniname++;
+		if (*uniname != 0x0) {
+			ep->dentry.name.unicode_0_14[i] = cpu_to_le16(*uniname);
+			uniname++;
+		} else {
+			ep->dentry.name.unicode_0_14[i] = 0x0;
+		}
 	}
 }
 
-- 
2.25.1



