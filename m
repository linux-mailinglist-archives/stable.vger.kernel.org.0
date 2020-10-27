Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6C029B60B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796556AbgJ0PT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796549AbgJ0PTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B06720657;
        Tue, 27 Oct 2020 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811960;
        bh=Mq9awMcJ6k0JzZRAkkGApMurCLFtNgNNqlA8ompWHpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTFlMNdBcIcBNjfe6gR1oK0+y7QfsulkPk/dU3ghN5a+Shukur6hAWr561PXwoYRC
         nNkTetK7PaEhCWS9JNyY3Nx8QcFqWLREITtBxUd04noV19mF8L4JD2LbrNfLMOTIJQ
         Hv9GLPhLTvcZryAwA3y8h/XHVG/5eo4Q2QgiBnJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 012/757] net: ipa: skip suspend/resume activities if not set up
Date:   Tue, 27 Oct 2020 14:44:22 +0100
Message-Id: <20201027135451.102220228@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit d1704382821032fede445b816f4296fd379baacf ]

When processing a system suspend request we suspend modem endpoints
if they are enabled, and call ipa_cmd_tag_process() (which issues
IPA commands) to ensure the IPA pipeline is cleared.  It is an error
to attempt to issue an IPA command before setup is complete, so this
is clearly a bug.  But we also shouldn't suspend or resume any
endpoints that have not been set up.

Have ipa_endpoint_suspend() and ipa_endpoint_resume() immediately
return if setup hasn't completed, to avoid any attempt to configure
endpoints or issue IPA commands in that case.

Fixes: 84f9bd12d46d ("soc: qcom: ipa: IPA endpoints")
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_endpoint.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1471,6 +1471,9 @@ void ipa_endpoint_resume_one(struct ipa_
 
 void ipa_endpoint_suspend(struct ipa *ipa)
 {
+	if (!ipa->setup_complete)
+		return;
+
 	if (ipa->modem_netdev)
 		ipa_modem_suspend(ipa->modem_netdev);
 
@@ -1482,6 +1485,9 @@ void ipa_endpoint_suspend(struct ipa *ip
 
 void ipa_endpoint_resume(struct ipa *ipa)
 {
+	if (!ipa->setup_complete)
+		return;
+
 	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX]);
 	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_LAN_RX]);
 


