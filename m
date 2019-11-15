Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66EBFE7FD
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfKOWfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:35:00 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40535 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfKOWeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:05 -0500
Received: by mail-pl1-f194.google.com with SMTP id e3so5626954plt.7
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HUM10/8Wh+ACpH8iy+zYVazM7/j5x9SwSLUXvaHdtoE=;
        b=ypkIu9LpYzuilaTSO1ddkj4eAfzXCWg5IShx48OXs6BvHNF3e7+rx/03wNN1tYaleh
         SnZM8RHGgSNVrsmiwniMNuQyH174+xgl/q4FEQxe7UVXDuVhTtT/3TIahPM8bt5ZmH3+
         ud8Eos51tOebTw0Y0mq1tqIEY0ssGv6FbVUe9ALZXTAWJPcnpmI7iUshmshcvm770Ayk
         jRwA1AXpceNmz1E6uqRFqcGSLc2lSSfvePTl8s/unV8Lzx+f9sx/TSGf3xflzHr4szxN
         BXuLl9NHzQ6cEOZbYvbeYcQ1U5te3v0DNBTnZ3Ab2FwTA3bfYQBRlEMA2uNi2PTy8N92
         PCxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HUM10/8Wh+ACpH8iy+zYVazM7/j5x9SwSLUXvaHdtoE=;
        b=laQ+B7kNHawW5IkJIAEnWpfCKQdBTHNegxII+EQpjXIBT3PcwerXtmQrbUfczhic3X
         f5zPzt8SpukvSP8ls1RD5Z8oCbBkw8en5Hndh0AwIiMbouR//CENy0OUrpRPp6J0FzUR
         CyBrWZ/x0ZKlZUPY/sDcq9FyjUHcqbjacqzNWF+b4VAaau59AzsjPC7eElbcUV9dTlsY
         HCJ1wx0x2fOCFyJ/hll1yQz6uvJG/qQGFPnDZ9R3FfBH6chNbbPgz8VrIhPLf1hc+t6a
         LsGAoI0UF1+SnxZe1Vl/hzCeGMOZifZfEeI5wIeexwXLaalONyAqfP3BjgHAAQyUp5yc
         8r9g==
X-Gm-Message-State: APjAAAWx9XMKk/LnXyQeu/THRBGtmmEtp073SPczFIjZgqEPml96d6FJ
        /xLsdHD2gthkCiuoZTKQ4wPM0Do8Sxk=
X-Google-Smtp-Source: APXvYqyMzfmiYdBbALgyJW/Yz44XD67/vMuUxQ8EgtUszaDCbgKhRiI6HNcF282zphiYMjPaFRLwFg==
X-Received: by 2002:a17:90a:256f:: with SMTP id j102mr22689164pje.124.1573857244238;
        Fri, 15 Nov 2019 14:34:04 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:03 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 08/20] remoteproc: fix rproc_da_to_va in case of unallocated carveout
Date:   Fri, 15 Nov 2019 15:33:44 -0700
Message-Id: <20191115223356.27675-8-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Pallardy <loic.pallardy@st.com>

commit 74457c40f97a98142bb13153395d304ad3c85cdd upstream

With introduction of rproc_alloc_registered_carveouts() which
delays carveout allocation just before the start of the remote
processor, rproc_da_to_va() could be called before all carveouts
are allocated.
This patch adds a check in rproc_da_to_va() to return NULL if
carveout is not allocated.

Fixes: d7c51706d095 ("remoteproc: add alloc ops in rproc_mem_entry struct")

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/remoteproc/remoteproc_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index aa6206706fe3..af9d443e7796 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -183,6 +183,10 @@ void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
 	list_for_each_entry(carveout, &rproc->carveouts, node) {
 		int offset = da - carveout->da;
 
+		/*  Verify that carveout is allocated */
+		if (!carveout->va)
+			continue;
+
 		/* try next carveout if da is too small */
 		if (offset < 0)
 			continue;
-- 
2.17.1

