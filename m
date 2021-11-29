Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297BE461EA2
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbhK2Sip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:38:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41382 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379625AbhK2Sg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:36:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E44B3B815C3;
        Mon, 29 Nov 2021 18:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1B1C53FAD;
        Mon, 29 Nov 2021 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210789;
        bh=S9anbES425jn8PdzDLo3Io70Wb16S0SbaConbkvpnS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmoPYyFwxBFduK2ZvUYPDtJvi/9QsuNhMkyIPxKTmeveWSOVOtJOkITb3ByOUuS4v
         wxRyWNIuxRofTDgoDxDxR1Fz3zBCIiOlExLyLaNMnw1OqQaXTlkK2CgEP/WJjk3j28
         RNL9hNoPh5C63ft/0Kc/Szc7VclHZYDlT9N/Qed8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 117/121] tty: hvc: replace BUG_ON() with negative return value
Date:   Mon, 29 Nov 2021 19:19:08 +0100
Message-Id: <20211129181715.597203561@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_xen.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -86,7 +86,11 @@ static int __write_console(struct xencon
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
@@ -114,7 +118,10 @@ static int domU_write_console(uint32_t v
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
 
@@ -138,7 +145,11 @@ static int domU_read_console(uint32_t vt
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


