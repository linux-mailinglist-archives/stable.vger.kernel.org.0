Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B217B328B26
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238294AbhCAS3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239775AbhCASWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:22:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7413D651E2;
        Mon,  1 Mar 2021 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619153;
        bh=RwdxeTRdlT/938+the2CncQrnJvJBUSBapoL3GxywDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgGTTRQM7qp3kD0wp7bSpsRksoh9W7DFNdxZm7Z45j5nm307EK9kpUH6Dn/z/uHaZ
         5oDHuR7s2MfZjtQPgmqRE5Ct0SA8VJy7aDtxj/oFcc1mFYLsJSjzLVjceMVcJDuuWn
         R6bhcbSpGfwuSvM24bUuIdhj3BGMeR5j8WZXX4Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/663] powerpc/pseries/dlpar: handle ibm, configure-connector delay status
Date:   Mon,  1 Mar 2021 17:09:59 +0100
Message-Id: <20210301161159.217719432@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 768d70e19ba525debd571b36e6d0ab19956c63d7 ]

dlpar_configure_connector() has two problems in its handling of
ibm,configure-connector's return status:

1. When the status is -2 (busy, call again), we call
   ibm,configure-connector again immediately without checking whether
   to schedule, which can result in monopolizing the CPU.
2. Extended delay status (9900..9905) goes completely unhandled,
   causing the configuration to unnecessarily terminate.

Fix both of these issues by using rtas_busy_delay().

Fixes: ab519a011caa ("powerpc/pseries: Kernel DLPAR Infrastructure")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210107025900.410369-1-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/dlpar.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 16e86ba8aa209..f6b7749d6ada7 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -127,7 +127,6 @@ void dlpar_free_cc_nodes(struct device_node *dn)
 #define NEXT_PROPERTY   3
 #define PREV_PARENT     4
 #define MORE_MEMORY     5
-#define CALL_AGAIN	-2
 #define ERR_CFG_USE     -9003
 
 struct device_node *dlpar_configure_connector(__be32 drc_index,
@@ -168,6 +167,9 @@ struct device_node *dlpar_configure_connector(__be32 drc_index,
 
 		spin_unlock(&rtas_data_buf_lock);
 
+		if (rtas_busy_delay(rc))
+			continue;
+
 		switch (rc) {
 		case COMPLETE:
 			break;
@@ -216,9 +218,6 @@ struct device_node *dlpar_configure_connector(__be32 drc_index,
 			last_dn = last_dn->parent;
 			break;
 
-		case CALL_AGAIN:
-			break;
-
 		case MORE_MEMORY:
 		case ERR_CFG_USE:
 		default:
-- 
2.27.0



