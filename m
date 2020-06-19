Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0253220139E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403921AbgFSPMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403915AbgFSPMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:12:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA4DA206FA;
        Fri, 19 Jun 2020 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579555;
        bh=RCzbOfWKdsuNjoZhh37a3FIUbTHPuINlTo8uqPP3G9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7sP31Dc/HqxE3VYuEZI7aOeLrxSUlPYgIPTLDwYfVgvIER6u/kFb5NoKYGOSXNRA
         S1Uvjsk/pNdECnJ3Be8m5sRYBhR2N/A6RzJbCnkYhjp+Z5EZQne1nKSn8yk0Zwzjq/
         6F6lq7/a3ScuzxKI/aEoUYa8l9L7r7HJ7fqrF85g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 5.4 179/261] ima: Remove __init annotation from ima_pcrread()
Date:   Fri, 19 Jun 2020 16:33:10 +0200
Message-Id: <20200619141658.504030609@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 8b8c704d913b0fe490af370631a4200e26334ec0 upstream.

Commit 6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in
ima_eventdigest_init()") added a call to ima_calc_boot_aggregate() so that
the digest can be recalculated for the boot_aggregate measurement entry if
the 'd' template field has been requested. For the 'd' field, only SHA1 and
MD5 digests are accepted.

Given that ima_eventdigest_init() does not have the __init annotation, all
functions called should not have it. This patch removes __init from
ima_pcrread().

Cc: stable@vger.kernel.org
Fixes:  6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -645,7 +645,7 @@ int ima_calc_buffer_hash(const void *buf
 	return calc_buffer_shash(buf, len, hash);
 }
 
-static void __init ima_pcrread(u32 idx, struct tpm_digest *d)
+static void ima_pcrread(u32 idx, struct tpm_digest *d)
 {
 	if (!ima_tpm_chip)
 		return;


