Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B1C371B0E
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhECQnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232373AbhECQkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBBE3613F6;
        Mon,  3 May 2021 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059864;
        bh=XCtJfkGFbC2VRs0fahHq2Xv98B7QeAWABesY4G/UWe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjStaHo5QXjBgcjuKgk3s2ETUiJ5NXrUUKiq8wKXj7odzqLzoQpIGdBVkVyQ4052X
         wAuZgoGyVL4JyPjO/6br1slxeJd0jhdoBXAZMwn8VNT/rNlPeC+0kcSUPchLrrGDjT
         cUSJzaYtD31Q/NPe36JKEgfQrfdX4vwfIsht1qkgdMQB+rkErDUPmHabyyZ535uU5g
         TXnctt9niMGPPV0mbTDLvCuV/B/zt/FrmrvA6iKnf+SB28gwxZLfjlE7rxpPmynMiV
         Fx6adAsad8wdysK+G3MmZJErPLYIEh+sHF+aCq7f7DVu9jRAmFQ5jtcDJmJhYshy9E
         5efCsZohOeGkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.11 029/115] atomisp: don't let it go past pipes array
Date:   Mon,  3 May 2021 12:35:33 -0400
Message-Id: <20210503163700.2852194-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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

