Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B9F28B790
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389503AbgJLNoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731421AbgJLNnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:43:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B8B121BE5;
        Mon, 12 Oct 2020 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510191;
        bh=hy3wofTbcHYl/O6Wzjta6ryuFIEiG9aOQHF4fXFAF8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzAxl9MZU/dGAD4ZgseFLkDM1eNMnRfbFzInnpgEOXKDiAz6Oje8R0F1M4D0ZfAHU
         32tw/1L0J42QgcFi8dCwkjeOpvbQsEuB/NpGzo9WY0hFqqNAdO3020aHQJXTN3D+XG
         zrEyMgC64TsUqR4VkQ4Hj9u9wV2duvErJL8Mdgf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/85] xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate
Date:   Mon, 12 Oct 2020 15:27:12 +0200
Message-Id: <20201012132635.225387533@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 545e5c571662b1cd79d9588f9d3b6e36985b8007 ]

XFRMA_SET_MARK and XFRMA_SET_MARK_MASK was not cloned from the old
to the new. Migrate these two attributes during XFRMA_MSG_MIGRATE

Fixes: 9b42c1f179a6 ("xfrm: Extend the output_mark to support input direction and masking.")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index f3423562d9336..10d30f0338d72 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1507,6 +1507,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	}
 
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
+	memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
 
 	if (xfrm_init_state(x) < 0)
 		goto error;
-- 
2.25.1



