Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26D4411AE0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbhITQw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244594AbhITQu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D668E6124C;
        Mon, 20 Sep 2021 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156565;
        bh=6oOBJ1qGDe0ntOruCDolaOWVwqicF3bNkq2aqk+9SZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CV9q+7w2/FisUzWY3S/pGiQ9fQT3ZQYaCYtKUjXoxgIpFThq20JEMx0tkEwTj/O2b
         TPOq40l7aLwR9O6wMYq7rTnsJLjG4SAd4wgdwwxc9eNrisqvwOpQ9lpkNQzqj/J9MI
         abKxyunEJSv58wM2vEoI3OeL3iME2DL+SquVxFrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patryk Duda <pdk@semihalf.com>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 4.4 117/133] platform/chrome: cros_ec_proto: Send command again when timeout occurs
Date:   Mon, 20 Sep 2021 18:43:15 +0200
Message-Id: <20210920163916.451142469@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
@@ -182,6 +182,15 @@ static int cros_ec_host_command_proto_qu
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


