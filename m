Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB88B148246
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391575AbgAXL0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391573AbgAXL0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:39 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12311214DB;
        Fri, 24 Jan 2020 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865198;
        bh=r7IbhevZ3vbcrxTfXmNL6qpthsVQKciIUQJ7zwQ+h3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnFIDbY2NExa9KjkhZ98Iw1vvuwpnGP23PLc7ETEORhoXF3UqVGaTvsGIadVmolEm
         ZG0o4Q29FQ28M4pnm3mOdvJl0LWONcnuAb60fv1fAOoYmdFn4vdwaLj6CeflquG6pt
         8Q+H7sWowurbeHlDVVxzCLMERTm/pRGMBEsduPHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Alistair Popple <alistair@popple.id.au>,
        Eddie James <eajames@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 467/639] fsi: sbefifo: Dont fail operations when in SBE IPL state
Date:   Fri, 24 Jan 2020 10:30:37 +0100
Message-Id: <20200124093145.849193289@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 7ce98fb6c53d2311b3e9faae90b1a9c1a96534db ]

SBE fifo operations should be allowed while the SBE is in any of the
"IPL" states. Operations should succeed in this state.

Fixes: 9f4a8a2d7f9d fsi/sbefifo: Add driver for the SBE FIFO
Reviewed-by: Joel Stanley <joel@jms.id.au>
Tested-by: Alistair Popple <alistair@popple.id.au>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/1561575415-3282-1-git-send-email-eajames@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-sbefifo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/fsi/fsi-sbefifo.c b/drivers/fsi/fsi-sbefifo.c
index ae861342626e3..9fa3959e08554 100644
--- a/drivers/fsi/fsi-sbefifo.c
+++ b/drivers/fsi/fsi-sbefifo.c
@@ -289,11 +289,11 @@ static int sbefifo_check_sbe_state(struct sbefifo *sbefifo)
 	switch ((sbm & CFAM_SBM_SBE_STATE_MASK) >> CFAM_SBM_SBE_STATE_SHIFT) {
 	case SBE_STATE_UNKNOWN:
 		return -ESHUTDOWN;
+	case SBE_STATE_DMT:
+		return -EBUSY;
 	case SBE_STATE_IPLING:
 	case SBE_STATE_ISTEP:
 	case SBE_STATE_MPIPL:
-	case SBE_STATE_DMT:
-		return -EBUSY;
 	case SBE_STATE_RUNTIME:
 	case SBE_STATE_DUMP: /* Not sure about that one */
 		break;
-- 
2.20.1



