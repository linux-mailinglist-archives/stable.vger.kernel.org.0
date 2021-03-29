Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3576634C99A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhC2IaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234249AbhC2I17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 569B3619CC;
        Mon, 29 Mar 2021 08:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006421;
        bh=VWVsVUMY3SUNNZG6xwnbldaWKxsDHqWx8i0e/+hCGnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jceh37QRkPAV4ZV1Z9Zi6lpSfRB1atsLbbGMLlawjLIfSQjn57m0C7Y2vRivqc7Kh
         0xD5bG2eawYyeM//HdBsmSJfDccIkcrty6S59UmJqt47XCa82RjxbR+/ENu5sMsMJW
         lCpEmGqxy1uB2PpctYUb7DHSPN2vgvt4tY+mE5wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 014/254] net: intel: iavf: fix error return code of iavf_init_get_resources()
Date:   Mon, 29 Mar 2021 09:55:30 +0200
Message-Id: <20210329075633.616991327@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 6650d31f21b8a0043613ae0a4a2e42e49dc20b2d ]

When iavf_process_config() fails, no error return code of
iavf_init_get_resources() is assigned.
To fix this bug, err is assigned with the return value of
iavf_process_config(), and then err is checked.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 0a867d64d467..dc5b3c06d1e0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1776,7 +1776,8 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 		goto err_alloc;
 	}
 
-	if (iavf_process_config(adapter))
+	err = iavf_process_config(adapter);
+	if (err)
 		goto err_alloc;
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 
-- 
2.30.1



