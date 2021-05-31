Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3C3396260
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhEaOzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234035AbhEaOxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BB4D61CA8;
        Mon, 31 May 2021 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469508;
        bh=KehBeMlUcm4nj9j+kHyJww7Flwp46LChGWKgxp7iCQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbjqZRdd8e2V/rFimnzDYIER0bo2dxwG4w94Eak7Q4lWycdgM3sMXxeVgq0I/axPh
         JyBQgWWdFhdxLCv0v0J/e9wNgd00Txahf2tRoanYf2CKb4PI7l8yQzL8+FKIgh5421
         feOU4Sr7tX4NCEiqRmliZBtU5rBFHlmGtoozQmYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 225/296] usb: cdnsp: Fix lack of removing request from pending list.
Date:   Mon, 31 May 2021 15:14:40 +0200
Message-Id: <20210531130711.387687081@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit 3b414d1b0107fa51ad6063de9752d4b2a8063980 ]

Patch fixes lack of removing request from ep->pending_list on failure
of the stop endpoint command. Driver even after failing this command
must remove request from ep->pending_list.
Without this fix driver can stuck in cdnsp_gadget_ep_disable function
in loop:
        while (!list_empty(&pep->pending_list)) {
                preq = next_request(&pep->pending_list);
                cdnsp_ep_dequeue(pep, preq);
        }

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210420042813.34917-1-pawell@gli-login.cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index 56707b6b0f57..c083985e387b 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -422,17 +422,17 @@ unmap:
 int cdnsp_ep_dequeue(struct cdnsp_ep *pep, struct cdnsp_request *preq)
 {
 	struct cdnsp_device *pdev = pep->pdev;
-	int ret;
+	int ret_stop = 0;
+	int ret_rem;
 
 	trace_cdnsp_request_dequeue(preq);
 
-	if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_RUNNING) {
-		ret = cdnsp_cmd_stop_ep(pdev, pep);
-		if (ret)
-			return ret;
-	}
+	if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_RUNNING)
+		ret_stop = cdnsp_cmd_stop_ep(pdev, pep);
+
+	ret_rem = cdnsp_remove_request(pdev, preq, pep);
 
-	return cdnsp_remove_request(pdev, preq, pep);
+	return ret_rem ? ret_rem : ret_stop;
 }
 
 static void cdnsp_zero_in_ctx(struct cdnsp_device *pdev)
-- 
2.30.2



