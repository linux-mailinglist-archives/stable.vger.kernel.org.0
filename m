Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B4235BD9A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbhDLIwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238708AbhDLIu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEEC8611F0;
        Mon, 12 Apr 2021 08:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217411;
        bh=7khwu2IG/1lnTGfD54GNj/hWdGYeQlKlWGEELSEg1Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKu7emLZspIJwwprmLjfaBGErmE50scgz7uGOzHCxBIDCog4wzA1Aj5A+QJwzuktj
         Ye6VoWbyyak6LMAA/9Kxh9lYH5LXSVpMuSa2fOaUWCunT6EkoNNHwGgjPOREH0Qt0K
         vWHiRFvvNtOxgXQjGQ+WwwCXPmYXZ+kZrE0x7Dho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Roche <william.roche@oracle.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 094/111] RAS/CEC: Correct ce_add_elem()s returned values
Date:   Mon, 12 Apr 2021 10:41:12 +0200
Message-Id: <20210412084007.383311692@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Roche <william.roche@oracle.com>

commit 3a62583c2853b0ab37a57dde79decea210b5fb89 upstream.

ce_add_elem() uses different return values to signal a result from
adding an element to the collector. Commit in Fixes: broke the case
where the element being added is not found in the array. Correct that.

 [ bp: Rewrite commit message, add kernel-doc comments. ]

Fixes: de0e0624d86f ("RAS/CEC: Check count_threshold unconditionally")
Signed-off-by: William Roche <william.roche@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/1617722939-29670-1-git-send-email-william.roche@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ras/cec.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -309,11 +309,20 @@ static bool sanity_check(struct ce_array
 	return ret;
 }
 
+/**
+ * cec_add_elem - Add an element to the CEC array.
+ * @pfn:	page frame number to insert
+ *
+ * Return values:
+ * - <0:	on error
+ * -  0:	on success
+ * - >0:	when the inserted pfn was offlined
+ */
 int cec_add_elem(u64 pfn)
 {
 	struct ce_array *ca = &ce_arr;
+	int count, err, ret = 0;
 	unsigned int to = 0;
-	int count, ret = 0;
 
 	/*
 	 * We can be called very early on the identify_cpu() path where we are
@@ -330,8 +339,8 @@ int cec_add_elem(u64 pfn)
 	if (ca->n == MAX_ELEMS)
 		WARN_ON(!del_lru_elem_unlocked(ca));
 
-	ret = find_elem(ca, pfn, &to);
-	if (ret < 0) {
+	err = find_elem(ca, pfn, &to);
+	if (err < 0) {
 		/*
 		 * Shift range [to-end] to make room for one more element.
 		 */


