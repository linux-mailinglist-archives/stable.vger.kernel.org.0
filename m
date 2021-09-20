Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF141234B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378135AbhITSXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377316AbhITSU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 475A761A7A;
        Mon, 20 Sep 2021 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158634;
        bh=vZ2tKc+2Xa7Zsse5l2RmsGfKa3kyAD+Q4A8y/hduqEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2UAwLMGUWH2kU5KprVKLx0aqNEey5XdujRtmlek9ia7s0wqUe12cVEt2E1YeBiS6
         QhjHgzYsr1cVI9YjwJOPzp8VBfjFP6BfQNyMZCOoBVryhA/ZXHaAK1TII/OWZf5xh2
         mUO8DtxWwYyWMjINICgz/20he1skOfbEczwtx+nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 246/260] NTB: perf: Fix an error code in perf_setup_inbuf()
Date:   Mon, 20 Sep 2021 18:44:24 +0200
Message-Id: <20210920163939.479248252@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 0097ae5f7af5684f961a5f803ff7ad3e6f933668 ]

When the function IS_ALIGNED() returns false, the value of ret is 0.
So, we set ret to -EINVAL to indicate this error.

Clean up smatch warning:
drivers/ntb/test/ntb_perf.c:602 perf_setup_inbuf() warn: missing error
code 'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_perf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 5ce4766a6c9e..251fe75798c1 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -597,6 +597,7 @@ static int perf_setup_inbuf(struct perf_peer *peer)
 		return -ENOMEM;
 	}
 	if (!IS_ALIGNED(peer->inbuf_xlat, xlat_align)) {
+		ret = -EINVAL;
 		dev_err(&perf->ntb->dev, "Unaligned inbuf allocated\n");
 		goto err_free_inbuf;
 	}
-- 
2.30.2



