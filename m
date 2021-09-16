Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B469540E100
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241908AbhIPQ00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242077AbhIPQYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E262F6127B;
        Thu, 16 Sep 2021 16:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808977;
        bh=DPwHQ/O2t7CmzyS/XLygN1/o/YYDUSrXHbgLso137Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYMQPFwsBA1UKJf/OyO8ZTGI+72/I1bana13ERT9t7fN5Sbq++iDJIiS8x2XhczKE
         XT3w8WUpOwe0CKC9IUJGN2KmHiOlLI+qfaEba9IcDCRyVFIsT3DqZIpI/hiQZo+z/c
         YaIwSsJQVOUMajzcJ7wIxwuc6mnZPfy3PX4syLSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patryk Duda <pdk@semihalf.com>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.10 293/306] platform/chrome: cros_ec_proto: Send command again when timeout occurs
Date:   Thu, 16 Sep 2021 18:00:38 +0200
Message-Id: <20210916155804.090816696@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patryk Duda <pdk@semihalf.com>

commit 3abc16af57c9939724df92fcbda296b25cc95168 upstream.

Sometimes kernel is trying to probe Fingerprint MCU (FPMCU) when it
hasn't initialized SPI yet. This can happen because FPMCU is restarted
during system boot and kernel can send message in short window
eg. between sysjump to RW and SPI initialization.

Cc: <stable@vger.kernel.org> # 4.4+
Signed-off-by: Patryk Duda <pdk@semihalf.com>
Link: https://lore.kernel.org/r/20210518140758.29318-1-pdk@semihalf.com
Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_proto.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -279,6 +279,15 @@ static int cros_ec_host_command_proto_qu
 	msg->insize = sizeof(struct ec_response_get_protocol_info);
 
 	ret = send_command(ec_dev, msg);
+	/*
+	 * Send command once again when timeout occurred.
+	 * Fingerprint MCU (FPMCU) is restarted during system boot which
+	 * introduces small window in which FPMCU won't respond for any
+	 * messages sent by kernel. There is no need to wait before next
+	 * attempt because we waited at least EC_MSG_DEADLINE_MS.
+	 */
+	if (ret == -ETIMEDOUT)
+		ret = send_command(ec_dev, msg);
 
 	if (ret < 0) {
 		dev_dbg(ec_dev->dev,


