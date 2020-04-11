Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C781A541F
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgDKXEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgDKXEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6636215A4;
        Sat, 11 Apr 2020 23:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646261;
        bh=LH/0XbyTfE2JnQhWXC2C1VsC70CAwJrX6gzmWQ2KEZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwlP2+hqzZg5kLcAIRYCOM4Ea+HLP+jHElHZeTzJNyo0N5C1Xxy661P3QTUAmSN9U
         804UiD9+zvLQdFa1bPnWmzxdXQ5NzgnlHQ9ffAVB9OcH+mV4JSFyS66tzMZTYa5+gL
         ADs9ptSJFmP5GpDWSVDMv0l6cXOq9igTnetAue/M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Jon Mason <jdmason@kudzu.us>,
        Sasha Levin <sashal@kernel.org>, linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.6 027/149] ntb_tool: Fix printk format
Date:   Sat, 11 Apr 2020 19:01:44 -0400
Message-Id: <20200411230347.22371-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 2ef97a6c181eba48f14c9ed98ce4398d21164683 ]

The correct printk format is %pa or %pap, but not %pa[p].

Fixes: 7f46c8b3a5523 ("NTB: ntb_tool: Add full multi-port NTB API support")
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_tool.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ntb/test/ntb_tool.c b/drivers/ntb/test/ntb_tool.c
index d592c0ffbd198..69da758fe64c8 100644
--- a/drivers/ntb/test/ntb_tool.c
+++ b/drivers/ntb/test/ntb_tool.c
@@ -678,19 +678,19 @@ static ssize_t tool_mw_trans_read(struct file *filep, char __user *ubuf,
 			 &inmw->dma_base);
 
 	off += scnprintf(buf + off, buf_size - off,
-			 "Window Size    \t%pa[p]\n",
+			 "Window Size    \t%pap\n",
 			 &inmw->size);
 
 	off += scnprintf(buf + off, buf_size - off,
-			 "Alignment      \t%pa[p]\n",
+			 "Alignment      \t%pap\n",
 			 &addr_align);
 
 	off += scnprintf(buf + off, buf_size - off,
-			 "Size Alignment \t%pa[p]\n",
+			 "Size Alignment \t%pap\n",
 			 &size_align);
 
 	off += scnprintf(buf + off, buf_size - off,
-			 "Size Max       \t%pa[p]\n",
+			 "Size Max       \t%pap\n",
 			 &size_max);
 
 	ret = simple_read_from_buffer(ubuf, size, offp, buf, off);
@@ -907,16 +907,16 @@ static ssize_t tool_peer_mw_trans_read(struct file *filep, char __user *ubuf,
 			 "Virtual address     \t0x%pK\n", outmw->io_base);
 
 	off += scnprintf(buf + off, buf_size - off,
-			 "Phys Address        \t%pa[p]\n", &map_base);
+			 "Phys Address        \t%pap\n", &map_base);
 
 	off += scnprintf(buf + off, buf_size - off,
-			 "Mapping Size        \t%pa[p]\n", &map_size);
+			 "Mapping Size        \t%pap\n", &map_size);
 
 	off += scnprintf(buf + off, buf_size - off,
 			 "Translation Address \t0x%016llx\n", outmw->tr_base);
 
 	off += scnprintf(buf + off, buf_size - off,
-			 "Window Size         \t%pa[p]\n", &outmw->size);
+			 "Window Size         \t%pap\n", &outmw->size);
 
 	ret = simple_read_from_buffer(ubuf, size, offp, buf, off);
 	kfree(buf);
-- 
2.20.1

