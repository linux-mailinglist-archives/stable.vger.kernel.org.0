Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C45472696
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhLMJxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:53:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41458 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237484AbhLMJuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:50:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3C61CE0E8C;
        Mon, 13 Dec 2021 09:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFD8C00446;
        Mon, 13 Dec 2021 09:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389004;
        bh=/0k9/J4TVvUWcWxNxah1yNR3pB44URDvTeV7rqKD0NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbhyZYCns/AgPBLwDLtkeLpTl3K1me46/FsYda2ZVnS1cIm9uGOKfbResnIaDWmUJ
         l1yZusQm2IPKcMid7O8amZ4vcPGP6yjIM/DsPjxpXJowWmH/RZGRU0QYvEaPQlKh2s
         eUWa5hHiE2DlI6fihjHGgsTVawn/KNPbk7O10Xr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 051/132] scsi: qla2xxx: Format log strings only if needed
Date:   Mon, 13 Dec 2021 10:29:52 +0100
Message-Id: <20211213092940.872716772@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

commit 69002c8ce914ef0ae22a6ea14b43bb30b9a9a6a8 upstream.

Commit 598a90f2002c ("scsi: qla2xxx: add ring buffer for tracing debug
logs") introduced unconditional log string formatting to ql_dbg() even if
ql_dbg_log event is disabled. It harms performance because some strings are
formatted in fastpath and/or interrupt context.

Link: https://lore.kernel.org/r/20211112145446.51210-1-r.bolshakov@yadro.com
Fixes: 598a90f2002c ("scsi: qla2xxx: add ring buffer for tracing debug logs")
Cc: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2477,6 +2477,9 @@ ql_dbg(uint level, scsi_qla_host_t *vha,
 	struct va_format vaf;
 	char pbuf[64];
 
+	if (!ql_mask_match(level) && !trace_ql_dbg_log_enabled())
+		return;
+
 	va_start(va, fmt);
 
 	vaf.fmt = fmt;


