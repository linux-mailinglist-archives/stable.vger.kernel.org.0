Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3467C45C08E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344994AbhKXNJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347429AbhKXNHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C1D61504;
        Wed, 24 Nov 2021 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757534;
        bh=N51A8M4E4KpN+AgISpEgJ0kmxYPyBjNN1up9UZGqqPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAVKYR/N7Hpy5ZiUPcWr25LH3QxdKpcxn+hFY6hM6NAR3UMdZ+IHRX3ppIWoMYlUq
         lGC4xa8I9aOYPPw+2X14etLGfpbijf5cIiPM//s3kWCl+DVJtCklP0Zf9DzDk+lFaT
         WTPgcsLF1hn3yuj0xRx5KnCGlWEZKy9RViCMpNE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 201/323] rpmsg: Fix rpmsg_create_ept return when RPMSG config is not defined
Date:   Wed, 24 Nov 2021 12:56:31 +0100
Message-Id: <20211124115725.731880259@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>

[ Upstream commit 537d3af1bee8ad1415fda9b622d1ea6d1ae76dfa ]

According to the description of the rpmsg_create_ept in rpmsg_core.c
the function should return NULL on error.

Fixes: 2c8a57088045 ("rpmsg: Provide function stubs for API")
Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20210712123912.10672-1-arnaud.pouliquen@foss.st.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rpmsg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index 9fe156d1c018e..a68972b097b72 100644
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -177,7 +177,7 @@ static inline struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_device *rpdev
 	/* This shouldn't be possible */
 	WARN_ON(1);
 
-	return ERR_PTR(-ENXIO);
+	return NULL;
 }
 
 static inline int rpmsg_send(struct rpmsg_endpoint *ept, void *data, int len)
-- 
2.33.0



