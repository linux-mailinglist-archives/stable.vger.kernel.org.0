Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569CE2A5845
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbgKCUtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731469AbgKCUtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C06220719;
        Tue,  3 Nov 2020 20:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436549;
        bh=AdTf9HgGqo6rrm0nJ2IxExXRKWayPLYvU3xc+t/6plA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+hQ2S+ojgneaJSJT7gaiLLADRRfufDFeDuAvEVJ6vRxEYEI00iawoHuVjplGsFne
         zGFc4vJifOB0oTz16vyaHOqwLfly09Z/G5lbfcI5agbNApjKJrL333PkPlA3fpf9Gg
         Ec6FzN7LIIey+H2n3X84WEhJi+QuEkkVIrgbKLD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.9 297/391] remoteproc: Fixup coredump debugfs disable request
Date:   Tue,  3 Nov 2020 21:35:48 +0100
Message-Id: <20201103203407.119720425@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit 1894622636745237f882bfab47925afc48e122e0 upstream.

Fix the discrepancy observed between accepted input and read back value
while disabling remoteproc coredump through the coredump debugfs entry.

Fixes: 3afdc59e4390 ("remoteproc: Add coredump debugfs entry")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200916145100.15872-1-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/remoteproc_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -94,7 +94,7 @@ static ssize_t rproc_coredump_write(stru
 		goto out;
 	}
 
-	if (!strncmp(buf, "disable", count)) {
+	if (!strncmp(buf, "disabled", count)) {
 		rproc->dump_conf = RPROC_COREDUMP_DISABLED;
 	} else if (!strncmp(buf, "inline", count)) {
 		rproc->dump_conf = RPROC_COREDUMP_INLINE;


