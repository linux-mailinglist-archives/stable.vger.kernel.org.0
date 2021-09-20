Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993D0411E61
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347614AbhITRa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347913AbhITR2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:28:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961DC61AAB;
        Mon, 20 Sep 2021 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157396;
        bh=ixuY3a0UrtYDmZDeLqu+/tO2jdxICJpxyE48c7wpCIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hopzwCq6XcUjtuydExFf0lmsLrIdEdB70fOb+29V3pQ4y+oBHPBCn7EsVEUuo3MWf
         ClrKPj9RXeM9vUBjAftj3BHPwvW8ZPFxlLfRMkLXAoA8UDxDg8CcVlRVWzhMeElzj3
         PmVWQmtLAUCXcg7x2+EvF0dm3lAQhI5OZBAZT/K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patryk Duda <pdk@semihalf.com>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 4.14 190/217] platform/chrome: cros_ec_proto: Send command again when timeout occurs
Date:   Mon, 20 Sep 2021 18:43:31 +0200
Message-Id: <20210920163931.066672695@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
@@ -217,6 +217,15 @@ static int cros_ec_host_command_proto_qu
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


