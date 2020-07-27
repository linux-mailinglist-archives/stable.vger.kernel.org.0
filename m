Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B822EFDA
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbgG0OTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731445AbgG0OTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 824F32075A;
        Mon, 27 Jul 2020 14:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859590;
        bh=FrXkJIjIfPxFCaet73fYO+GvqQejZFZxu7LwH5m4W6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QP6VQdqvzItpFCfZyRlNWp+LKQcsWAfJBHCjcWXC/YTuJMvx9XaWbP1s58lILZgcA
         fgmWYR5nbCkk0vImnk9BcAsIDshNXj7DvWfQGSp3ZTCS9FXxtv5kGJVEDDYJcq1HDc
         ZbZTFK5lyGVnGjpAbqRYzeXbsCJm107W1Ys/Ovg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Minqiang <ptpt52@gmail.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7 030/179] exfat: fix name_hash computation on big endian systems
Date:   Mon, 27 Jul 2020 16:03:25 +0200
Message-Id: <20200727134934.132666901@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Ponetayev <i.ponetaev@ndmsystems.com>

commit db415f7aae07cadcabd5d2a659f8ad825c905299 upstream.

On-disk format for name_hash field is LE, so it must be explicitly
transformed on BE system for proper result.

Fixes: 370e812b3ec1 ("exfat: add nls operations")
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Chen Minqiang <ptpt52@gmail.com>
Signed-off-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exfat/nls.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -495,7 +495,7 @@ static int exfat_utf8_to_utf16(struct su
 		struct exfat_uni_name *p_uniname, int *p_lossy)
 {
 	int i, unilen, lossy = NLS_NAME_NO_LOSSY;
-	unsigned short upname[MAX_NAME_LENGTH + 1];
+	__le16 upname[MAX_NAME_LENGTH + 1];
 	unsigned short *uniname = p_uniname->name;
 
 	WARN_ON(!len);
@@ -523,7 +523,7 @@ static int exfat_utf8_to_utf16(struct su
 		    exfat_wstrchr(bad_uni_chars, *uniname))
 			lossy |= NLS_NAME_LOSSY;
 
-		upname[i] = exfat_toupper(sb, *uniname);
+		upname[i] = cpu_to_le16(exfat_toupper(sb, *uniname));
 		uniname++;
 	}
 
@@ -614,7 +614,7 @@ static int exfat_nls_to_ucs2(struct supe
 		struct exfat_uni_name *p_uniname, int *p_lossy)
 {
 	int i = 0, unilen = 0, lossy = NLS_NAME_NO_LOSSY;
-	unsigned short upname[MAX_NAME_LENGTH + 1];
+	__le16 upname[MAX_NAME_LENGTH + 1];
 	unsigned short *uniname = p_uniname->name;
 	struct nls_table *nls = EXFAT_SB(sb)->nls_io;
 
@@ -628,7 +628,7 @@ static int exfat_nls_to_ucs2(struct supe
 		    exfat_wstrchr(bad_uni_chars, *uniname))
 			lossy |= NLS_NAME_LOSSY;
 
-		upname[unilen] = exfat_toupper(sb, *uniname);
+		upname[unilen] = cpu_to_le16(exfat_toupper(sb, *uniname));
 		uniname++;
 		unilen++;
 	}


