Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897DE4729A7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239480AbhLMKXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244206AbhLMKQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:16:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF7CC0497D2;
        Mon, 13 Dec 2021 01:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2582CB80E0B;
        Mon, 13 Dec 2021 09:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596A8C34601;
        Mon, 13 Dec 2021 09:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389352;
        bh=OOwzEBWooO4Xt9iEdMKQSRN7FM/QMo2QlJz1spvHOXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nspWftQOe/tTVII1K2ZiV5EirzsvZDF76G8IfVJSpUOGbUVUcTenHYXZpQhA731VQ
         TYipFpv4LX8sl889exnEufEtTio8ugX4swRTe5RfGM9QEO9Q+CnktFzJOS1kcW1pR9
         MKZKfXS9hdGX/Dkbw8CnGhfMKFbiF8aNhodRS29g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 071/171] scsi: qla2xxx: Format log strings only if needed
Date:   Mon, 13 Dec 2021 10:29:46 +0100
Message-Id: <20211213092947.462131104@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -2491,6 +2491,9 @@ ql_dbg(uint level, scsi_qla_host_t *vha,
 	struct va_format vaf;
 	char pbuf[64];
 
+	if (!ql_mask_match(level) && !trace_ql_dbg_log_enabled())
+		return;
+
 	va_start(va, fmt);
 
 	vaf.fmt = fmt;


