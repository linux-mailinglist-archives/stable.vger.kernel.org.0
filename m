Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9771F3719EF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhECQiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231634AbhECQhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33B5661244;
        Mon,  3 May 2021 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059764;
        bh=XCtJfkGFbC2VRs0fahHq2Xv98B7QeAWABesY4G/UWe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulDu9/Em5w7tkWx/QbkknJcyBZQFn9XBHmxvElpSrvvR3BZiipIwLkKLaCiKvNCFY
         kp9/ooZjYuctKUJxXzWENo4GVyJbC455CjqNvdQKri3h3/GBnhn1vWAqsv1A8vGzhT
         RSUFYb4JqWpXdAQeDG/M2V1fBucDpL9yRy506xT6/0WZIcK9Vn/76adA6bUJMPE5nN
         9i6XIXIsRh9Z5vV2gwUZtAkJLnmqtKyZ9bC1MeSPrIP6MpLOxl8f70XnbiQVIUaPet
         ULkEKSsrjQw+dZDW9EYW+cnQWCrkeA/yrLCNKPGHeO12R+NbDjbBVdREOMVrmq8ujq
         m5PFLsbQR5Bbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.12 032/134] atomisp: don't let it go past pipes array
Date:   Mon,  3 May 2021 12:33:31 -0400
Message-Id: <20210503163513.2851510-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 1f6c45ac5fd70ab59136ab5babc7def269f3f509 ]

In practice, IA_CSS_PIPE_ID_NUM should never be used when
calling atomisp_q_video_buffers_to_css(), as the driver should
discover the right pipe before calling it.

Yet, if some pipe parsing issue happens, it could end using
it.

So, add a WARN_ON() to prevent such case.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_fops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp_fops.c
index 453bb6913550..f1e6b2597853 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -221,6 +221,9 @@ int atomisp_q_video_buffers_to_css(struct atomisp_sub_device *asd,
 	unsigned long irqflags;
 	int err = 0;
 
+	if (WARN_ON(css_pipe_id >= IA_CSS_PIPE_ID_NUM))
+		return -EINVAL;
+
 	while (pipe->buffers_in_css < ATOMISP_CSS_Q_DEPTH) {
 		struct videobuf_buffer *vb;
 
-- 
2.30.2

