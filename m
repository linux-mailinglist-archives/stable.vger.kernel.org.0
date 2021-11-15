Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C886451223
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhKOTaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244415AbhKOTOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:14:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF0A4634BA;
        Mon, 15 Nov 2021 18:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000454;
        bh=xvsneodb9iu8RfigzdnqoTq6y9kcK9nZfgU3x8e1D6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWl6fAQnDY5JINDixY440xQQvUm2+ZH83OjbId+FKaa13/rPanIywt0NTVgZ/jN+I
         h/GfRd30U+G6h5N4o+O4Pt4Ync7VNgragu2wb05rjBiGunjZiL8dZWjI6UtUzUMlmJ
         DmvqJs2gLHvK3aWn5HcMBMDQP+QP0gAUa8KoPtgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 665/849] rpmsg: Fix rpmsg_create_ept return when RPMSG config is not defined
Date:   Mon, 15 Nov 2021 18:02:28 +0100
Message-Id: <20211115165442.764836551@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index d97dcd049f18f..a8dcf8a9ae885 100644
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -231,7 +231,7 @@ static inline struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_device *rpdev
 	/* This shouldn't be possible */
 	WARN_ON(1);
 
-	return ERR_PTR(-ENXIO);
+	return NULL;
 }
 
 static inline int rpmsg_send(struct rpmsg_endpoint *ept, void *data, int len)
-- 
2.33.0



