Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B3134C892
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhC2IXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233466AbhC2IVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CCD66196F;
        Mon, 29 Mar 2021 08:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006090;
        bh=tLIxHiPcPHoJTYFICj5rIXFLKwMO/acwLvOfCh/B394=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ue38oxYWVzpIUeq7aCWLkWLvAIm2lXzesXbQdjaZdCDaNLxYzeyTkPZMBrJenUM33
         yoAiZb72/Zgf99nS4H92mKZn53EL/WsygCoE/v1v6GqEi39yqc+Z1uF96WsAVVVASD
         q4j1UEGXd8W+yKErLaJWi9DYHxy1aTa38ojU7+Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sujit Kautkar <sujitka@chromium.org>,
        Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/221] net: ipa: terminate message handler arrays
Date:   Mon, 29 Mar 2021 09:57:26 +0200
Message-Id: <20210329075633.043185062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 3a9ef3e11c5d33e5cb355b4aad1a4caad2407541 ]

When a QMI handle is initialized, an array of message handler
structures is provided, defining how any received message should
be handled based on its type and message ID.  The QMI core code
traverses this array when a message arrives and calls the function
associated with the (type, msg_id) found in the array.

The array is supposed to be terminated with an empty (all zero)
entry though.  Without it, an unsupported message will cause
the QMI core code to go past the end of the array.

Fix this bug, by properly terminating the message handler arrays
provided when QMI handles are set up by the IPA driver.

Fixes: 530f9216a9537 ("soc: qcom: ipa: AP/modem communications")
Reported-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_qmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 5090f0f923ad..1a87a49538c5 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -249,6 +249,7 @@ static struct qmi_msg_handler ipa_server_msg_handlers[] = {
 		.decoded_size	= IPA_QMI_DRIVER_INIT_COMPLETE_REQ_SZ,
 		.fn		= ipa_server_driver_init_complete,
 	},
+	{ },
 };
 
 /* Handle an INIT_DRIVER response message from the modem. */
@@ -269,6 +270,7 @@ static struct qmi_msg_handler ipa_client_msg_handlers[] = {
 		.decoded_size	= IPA_QMI_INIT_DRIVER_RSP_SZ,
 		.fn		= ipa_client_init_driver,
 	},
+	{ },
 };
 
 /* Return a pointer to an init modem driver request structure, which contains
-- 
2.30.1



