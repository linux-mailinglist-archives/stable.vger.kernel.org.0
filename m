Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCEF3283C3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbhCAQYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237799AbhCAQUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30EE964EDF;
        Mon,  1 Mar 2021 16:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615491;
        bh=k+0mhPMHJkOmXl+l7eX63dFVI1xz6lYmW/TzZ2lIwN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7Y3MNkiXCqSku4tmTnSWKlB2FecvLr0MGJtTrm+BGZeDn2oZRiMYLG1KhOiiBnIM
         Z4YQkulMv1+X6Af4rtJMvA5LXma3LY1MEpRQbeQfMWdC6d7dRyQYc0REqmjSH5kga/
         OyvFz7x22SPFV3EY25MY19GnHWduyQR5ARtVEY8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 48/93] powerpc/pseries/dlpar: handle ibm, configure-connector delay status
Date:   Mon,  1 Mar 2021 17:13:00 +0100
Message-Id: <20210301161009.274124361@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index 551ba5b35df9d..91a667d8b1e90 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -131,7 +131,6 @@ void dlpar_free_cc_nodes(struct device_node *dn)
 #define NEXT_PROPERTY   3
 #define PREV_PARENT     4
 #define MORE_MEMORY     5
-#define CALL_AGAIN	-2
 #define ERR_CFG_USE     -9003
 
 struct device_node *dlpar_configure_connector(__be32 drc_index,
@@ -173,6 +172,9 @@ struct device_node *dlpar_configure_connector(__be32 drc_index,
 
 		spin_unlock(&rtas_data_buf_lock);
 
+		if (rtas_busy_delay(rc))
+			continue;
+
 		switch (rc) {
 		case COMPLETE:
 			break;
@@ -225,9 +227,6 @@ struct device_node *dlpar_configure_connector(__be32 drc_index,
 			parent_path = last_dn->parent->full_name;
 			break;
 
-		case CALL_AGAIN:
-			break;
-
 		case MORE_MEMORY:
 		case ERR_CFG_USE:
 		default:
-- 
2.27.0



