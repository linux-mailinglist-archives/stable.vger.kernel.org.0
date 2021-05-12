Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB78737C200
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhELPGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233231AbhELPEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE9E61940;
        Wed, 12 May 2021 14:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831586;
        bh=XCMFh/w4SQjPhg8ctR6kIDWBG6AEOKhdEwqAv9L6tAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FeRzC7CESmLH96Fz2iSigAvuZv0glsx2LQnT5W1a6TZEaRtx8PYMYLd0NQgQde9Fw
         jQ08uV4x3lAQg7jD+sVWh4mFPd21x1Ax4+t1yAKKZCCzGM30/2xR2Jkoc1yw63f7kC
         sbrsV25Oa5gTzkGS1znxV3h4JMvIKska18f90Y4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 179/244] nfc: pn533: prevent potential memory corruption
Date:   Wed, 12 May 2021 16:49:10 +0200
Message-Id: <20210512144748.723023958@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
 drivers/nfc/pn533/pn533.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a172a32aa9d9..3ea38ce86cc9 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -680,6 +680,9 @@ static bool pn533_target_type_a_is_valid(struct pn533_target_type_a *type_a,
 	if (PN533_TYPE_A_SEL_CASCADE(type_a->sel_res) != 0)
 		return false;
 
+	if (type_a->nfcid_len > NFC_NFCID1_MAXSIZE)
+		return false;
+
 	return true;
 }
 
-- 
2.30.2



