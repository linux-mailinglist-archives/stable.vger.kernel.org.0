Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FB838A477
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhETKFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234791AbhETKDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:03:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1BCC61920;
        Thu, 20 May 2021 09:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503610;
        bh=/p25MvBZwqA5Nbc7FIOez90h7AqEppRc9rZIT7jkqpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmQTTMR+zapBgYLh6Re9oHfdVN5b858q0BEwgLFoN0ERNMA+GHgCvVDNrE4B4bTcs
         417TYcwDLkqOKnyuEMCGemG/5oWo15xXVPtv+QoSxaFnjQuswvr/AypS67kG5rditO
         Kdo/yeOUyEcA+goQzi1MuJroGsI8q9+E3i+wAV7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 4.19 300/425] Revert "fdt: Properly handle "no-map" field in the memory region"
Date:   Thu, 20 May 2021 11:21:09 +0200
Message-Id: <20210520092141.305440850@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

This reverts commit 03972d6b1bbac1620455589e0367f6f69ff7b2df.
It is not really a fix, and the backport misses dependencies, which
breaks existing platforms.

Reported-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/fdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1173,7 +1173,7 @@ int __init __weak early_init_dt_reserve_
 					phys_addr_t size, bool nomap)
 {
 	if (nomap)
-		return memblock_mark_nomap(base, size);
+		return memblock_remove(base, size);
 	return memblock_reserve(base, size);
 }
 


