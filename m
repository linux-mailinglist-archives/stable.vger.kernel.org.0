Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9DE246B3D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbgHQPu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730890AbgHQPum (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:50:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126932063A;
        Mon, 17 Aug 2020 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679441;
        bh=byHwtIwlZgL0WdEMuf+rCeZTZK2eJE6pssQD0B2LeE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/P4WAVgDrB/ZQrUFw7/xweb+cIu9Ajxs46XrBtGM5bfEMHkJMwjitwceLKrDkQHt
         /CvrtZHfp6C/uxYqnjwF/766uEjvo41h0ntBXy5gZ16Quk0jmh5RTKIkVz4HYs7bui
         DkLufo0s5k0BdJ5ugKt+8n5kUL9z1vCJrbA7QniI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 212/393] ima: Fail rule parsing when the KEY_CHECK hook is combined with an invalid cond
Date:   Mon, 17 Aug 2020 17:14:22 +0200
Message-Id: <20200817143829.909642782@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

[ Upstream commit eb624fe214a2e156ddafd9868377cf91499f789d ]

The KEY_CHECK function only supports the uid, pcr, and keyrings
conditionals. Make this clear at policy load so that IMA policy authors
don't assume that other conditionals are supported.

Fixes: 5808611cccb2 ("IMA: Add KEY_CHECK func to measure keys")
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a77e0b34e72f7..3e3e568c81309 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1023,6 +1023,13 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 		if (entry->action & ~(MEASURE | DONT_MEASURE))
 			return false;
 
+		if (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR |
+				     IMA_KEYRINGS))
+			return false;
+
+		if (ima_rule_contains_lsm_cond(entry))
+			return false;
+
 		break;
 	default:
 		return false;
-- 
2.25.1



