Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC1638AB47
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbhETLWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240465AbhETLUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7991B61D84;
        Thu, 20 May 2021 10:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505469;
        bh=ZpKop7a3TUJCeE4gnzgdKitIvMnEbF0gqyaNlowowLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFv6j/8lnq3g0pCP61pgpbhebHZrwgDK9zPq39bGvE9cGD4isjglpkMDg+95oXuIM
         6UqAcfyXbvxKDT8O8uAcKM8t05jit4yRlTgzq/yx7kNsQV1Q+HXS1ql718ipfc6GBp
         V+8xYV3NM+5zrz21kQ7MRjXtPSy92+fisiFNUa00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 115/190] nfc: pn533: prevent potential memory corruption
Date:   Thu, 20 May 2021 11:22:59 +0200
Message-Id: <20210520092106.004568090@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ca4d4c34ae9aa5c3c0da76662c5e549d2fc0cc86 ]

If the "type_a->nfcid_len" is too large then it would lead to memory
corruption in pn533_target_found_type_a() when we do:

	memcpy(nfc_tgt->nfcid1, tgt_type_a->nfcid_data, nfc_tgt->nfcid1_len);

Fixes: c3b1e1e8a76f ("NFC: Export NFCID1 from pn533")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index bb3d5ea9869c..001c12867e43 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1250,6 +1250,9 @@ static bool pn533_target_type_a_is_valid(struct pn533_target_type_a *type_a,
 	if (PN533_TYPE_A_SEL_CASCADE(type_a->sel_res) != 0)
 		return false;
 
+	if (type_a->nfcid_len > NFC_NFCID1_MAXSIZE)
+		return false;
+
 	return true;
 }
 
-- 
2.30.2



