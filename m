Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A02D9EBB
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440694AbgLNSRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502359AbgLNRi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:59 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 058/105] habanalabs/gaudi: fix missing code in ECC handling
Date:   Mon, 14 Dec 2020 18:28:32 +0100
Message-Id: <20201214172558.060613388@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit 652b44453ea953d3157f02a7f17e18e329952649 ]

There is missing statement and missing "break;" in the ECC handling
code in gaudi.c
This will cause a wrong behavior upon certain ECC interrupts.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 2e55890ad6a61..8da1720357a26 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -5416,6 +5416,8 @@ static void gaudi_handle_ecc_event(struct hl_device *hdev, u16 event_type,
 		params.num_memories = 33;
 		params.derr = true;
 		params.disable_clock_gating = true;
+		extract_info_from_fw = false;
+		break;
 	default:
 		return;
 	}
-- 
2.27.0



