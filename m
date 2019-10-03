Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1B4CA218
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731932AbfJCQBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731928AbfJCQBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:01:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52CA021A4C;
        Thu,  3 Oct 2019 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118514;
        bh=zhlYxEHaGCVikA60k3MAIF+EJmj7oCxcoIJOOn1L+Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbuquQDIBT/liCIbJV+9qHwMV7n1OX5gtOMsj4IwZo/vtGOZQNI/5Nn0VaV7aVBsU
         RiQBM8zk31RwYX9xYV88Xx8yEFhfLoJPoqVFecPadiY6q9VamlJ+5HGmYN5rULhXCx
         pfC1MNkmA70FM5SUfUcz34XCIbtgoHqMKL1stYDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.9 008/129] media: tvp5150: fix switch exit in set control handler
Date:   Thu,  3 Oct 2019 17:52:11 +0200
Message-Id: <20191003154322.788073384@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit 2d29bcc8c237874795175b2930fa9a45a115175a upstream.

The function only consists of a single switch case block without a
default case. Unsupported control requests are indicated by the -EINVAL
return code trough the last return statement at the end of the function. So
exiting just the switch case block returns the -EINVAL error code but the
hue control is supported and a zero should be returned instead.

Replace the break by a 'return 0' to fix this behaviour.

Fixes: d183e4efcae8 ("[media] v4l: tvp5150: Add missing break in set
control handler")

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/tvp5150.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -824,7 +824,7 @@ static int tvp5150_s_ctrl(struct v4l2_ct
 		return 0;
 	case V4L2_CID_HUE:
 		tvp5150_write(sd, TVP5150_HUE_CTL, ctrl->val);
-		break;
+		return 0;
 	case V4L2_CID_TEST_PATTERN:
 		decoder->enable = ctrl->val ? false : true;
 		tvp5150_selmux(sd);


