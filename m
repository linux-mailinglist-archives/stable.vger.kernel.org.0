Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40942FAAA6
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393893AbhARTxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390392AbhARLhm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:37:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F316D229CA;
        Mon, 18 Jan 2021 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969786;
        bh=taEIuTZFQJci8gjiNNphvJLh79yAjAzttAyS2kCiBR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9ZSJ2nhhvTtEv68X3ZNZbEb+BDkkOaRVmELl9OcMa9C0PYXBUBtsAw3KzGiy2feV
         whXfJxZEQfwGqTuV9ZkX9lWcU9+ERiFJ+gNK+AtZlBO796+hmWABBvHT8obzmUug2a
         AmM5SjLkPry5x+5FIzlVis0yl6IrFpxoL1GnENvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 4.19 25/43] ima: Remove __init annotation from ima_pcrread()
Date:   Mon, 18 Jan 2021 12:34:48 +0100
Message-Id: <20210118113336.157957455@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -641,7 +641,7 @@ int ima_calc_buffer_hash(const void *buf
 	return calc_buffer_shash(buf, len, hash);
 }
 
-static void __init ima_pcrread(int idx, u8 *pcr)
+static void ima_pcrread(int idx, u8 *pcr)
 {
 	if (!ima_tpm_chip)
 		return;


