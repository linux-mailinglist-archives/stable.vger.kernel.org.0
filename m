Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D50521FBBA
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgGNTD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731023AbgGNS4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC317229CA;
        Tue, 14 Jul 2020 18:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753003;
        bh=qlLNvsE77hLkylIVZ+jK60slbvjQdGxm1kMv+RPlm5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPhT6JtopkOus+Ac6NAcjmC1RX1nmNAlG4ArKduCC9jfWsPrQGPkpTP22ZWp5mTCz
         SYDnxOQnIS/NbG+4w5JRJSfqwn22DIiL10towI7804ZN6LIgfugP4ska06TK4vTikP
         CgHNaJwIeDHJQYispopeGDUF/P8I5iuY8rcozLIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 082/166] net: ipa: fix QMI structure definition bugs
Date:   Tue, 14 Jul 2020 20:44:07 +0200
Message-Id: <20200714184119.779061934@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 74478ea4ded519db35cb1f059948b1e713bb4abf ]

Building with "W=1" did exactly what it was supposed to do, namely
point out some suspicious-looking code to be verified not to contain
bugs.

Some QMI message structures defined in "ipa_qmi_msg.c" contained
some bad field names (duplicating the "elem_size" field instead of
defining the "offset" field), almost certainly due to copy/paste
errors that weren't obvious in a scan of the code.  Fix these bugs.

Fixes: 530f9216a953 ("soc: qcom: ipa: AP/modem communications")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_qmi_msg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
index 03a1d0e559644..73413371e3d3e 100644
--- a/drivers/net/ipa/ipa_qmi_msg.c
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -119,7 +119,7 @@ struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
 			sizeof_field(struct ipa_driver_init_complete_rsp,
 				     rsp),
 		.tlv_type	= 0x02,
-		.elem_size	= offsetof(struct ipa_driver_init_complete_rsp,
+		.offset		= offsetof(struct ipa_driver_init_complete_rsp,
 					   rsp),
 		.ei_array	= qmi_response_type_v01_ei,
 	},
@@ -137,7 +137,7 @@ struct qmi_elem_info ipa_init_complete_ind_ei[] = {
 			sizeof_field(struct ipa_init_complete_ind,
 				     status),
 		.tlv_type	= 0x02,
-		.elem_size	= offsetof(struct ipa_init_complete_ind,
+		.offset		= offsetof(struct ipa_init_complete_ind,
 					   status),
 		.ei_array	= qmi_response_type_v01_ei,
 	},
@@ -218,7 +218,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 			sizeof_field(struct ipa_init_modem_driver_req,
 				     platform_type_valid),
 		.tlv_type	= 0x10,
-		.elem_size	= offsetof(struct ipa_init_modem_driver_req,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   platform_type_valid),
 	},
 	{
-- 
2.25.1



