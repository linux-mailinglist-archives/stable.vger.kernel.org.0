Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004E435BED5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238924AbhDLJCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239150AbhDLI7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:59:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB0C6124C;
        Mon, 12 Apr 2021 08:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217857;
        bh=B6lBmkJc9AGNNM626ehx8HKi/VCxD74uQiqmG5rhVgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pE/D8pwxSUVj+tGtBQ/J6wJ2oxebkABBoiOcqXPOwHYTeu6Co0iJMRpDwcAbVvOSu
         STi+fM988PuJ0uLNikiigj5lQ3uks6JkfPGn+i9oLo8h1+aZ9ACFZvv67McvnVaxzz
         W2KOFvgSCn1sMQksfEz7zPSkq0rEfLcvHxwtp5K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Roche <william.roche@oracle.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 169/188] RAS/CEC: Correct ce_add_elem()s returned values
Date:   Mon, 12 Apr 2021 10:41:23 +0200
Message-Id: <20210412084019.250214213@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
 static int cec_add_elem(u64 pfn)
 {
 	struct ce_array *ca = &ce_arr;
+	int count, err, ret = 0;
 	unsigned int to = 0;
-	int count, ret = 0;
 
 	/*
 	 * We can be called very early on the identify_cpu() path where we are
@@ -330,8 +339,8 @@ static int cec_add_elem(u64 pfn)
 	if (ca->n == MAX_ELEMS)
 		WARN_ON(!del_lru_elem_unlocked(ca));
 
-	ret = find_elem(ca, pfn, &to);
-	if (ret < 0) {
+	err = find_elem(ca, pfn, &to);
+	if (err < 0) {
 		/*
 		 * Shift range [to-end] to make room for one more element.
 		 */


