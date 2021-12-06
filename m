Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C731469BDE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359266AbhLFPRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356080AbhLFPOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E54C08EB3E;
        Mon,  6 Dec 2021 07:06:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D488B810F1;
        Mon,  6 Dec 2021 15:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD72C341C2;
        Mon,  6 Dec 2021 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803213;
        bh=SYADHwegBHLHX2IqBrWF5EqWP6v8l1dzTJnhdpZVJMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dm4cFnzd42s1sfGtAbu11R5/64hWZwQqWXg/5ntCPGx2sVzhV46LnZFTSbm1VWBNH
         VZN+UL2rvmSonEiCAvWYsjfw9i2HcH+drRkBo/eWc85Ufq5JgvXGiLVqouCbhJeABb
         Tyj55hpbilGqO2UBL7YZbfNOaWyNY++r+3mvVlf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 068/106] tty: hvc: replace BUG_ON() with negative return value
Date:   Mon,  6 Dec 2021 15:56:16 +0100
Message-Id: <20211206145557.824018686@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit e679004dec37566f658a255157d3aed9d762a2b7 upstream.

Xen frontends shouldn't BUG() in case of illegal data received from
their backends. So replace the BUG_ON()s when reading illegal data from
the ring page with negative return values.

Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20210707091045.460-1-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_xen.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -99,7 +99,11 @@ static int __write_console(struct xencon
 	cons = intf->out_cons;
 	prod = intf->out_prod;
 	mb();			/* update queue values before going on */
-	BUG_ON((prod - cons) > sizeof(intf->out));
+
+	if ((prod - cons) > sizeof(intf->out)) {
+		pr_err_once("xencons: Illegal ring page indices");
+		return -EINVAL;
+	}
 
 	while ((sent < len) && ((prod - cons) < sizeof(intf->out)))
 		intf->out[MASK_XENCONS_IDX(prod++, intf->out)] = data[sent++];
@@ -127,7 +131,10 @@ static int domU_write_console(uint32_t v
 	 */
 	while (len) {
 		int sent = __write_console(cons, data, len);
-		
+
+		if (sent < 0)
+			return sent;
+
 		data += sent;
 		len -= sent;
 
@@ -151,7 +158,11 @@ static int domU_read_console(uint32_t vt
 	cons = intf->in_cons;
 	prod = intf->in_prod;
 	mb();			/* get pointers before reading ring */
-	BUG_ON((prod - cons) > sizeof(intf->in));
+
+	if ((prod - cons) > sizeof(intf->in)) {
+		pr_err_once("xencons: Illegal ring page indices");
+		return -EINVAL;
+	}
 
 	while (cons != prod && recv < len)
 		buf[recv++] = intf->in[MASK_XENCONS_IDX(cons++, intf->in)];


