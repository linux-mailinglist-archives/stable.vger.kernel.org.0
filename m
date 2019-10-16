Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C84D9FF0
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404656AbfJPWGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438198AbfJPV6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:35 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 270EB21925;
        Wed, 16 Oct 2019 21:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263115;
        bh=KBAU9OMK2sBXQWd9cYoO7tzeT75xTCJgt3hVD5ITMPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPqOncP2g45v1l7j3t29ptCeeWqMZzQhgWlZaaiLB2+Q8T+1AZpx2Tct6eJF9lA3F
         KchbnSKYBlT/3fyae+URMqBNBVvUEVj8FfHQn5dimLqV5aTO8xSvSHQze01y0vUs5A
         XGs/4/ZQd8nbO8mXrUEA4Hk9q0d559ZlG3fNc4hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 039/112] USB: legousbtower: fix slab info leak at probe
Date:   Wed, 16 Oct 2019 14:50:31 -0700
Message-Id: <20191016214854.216542720@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 1d427be4a39defadda6dd8f4659bc17f7591740f upstream.

Make sure to check for short transfers when retrieving the version
information at probe to avoid leaking uninitialised slab data when
logging it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190919083039.30898-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/legousbtower.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -891,8 +891,10 @@ static int tower_probe (struct usb_inter
 				  get_version_reply,
 				  sizeof(*get_version_reply),
 				  1000);
-	if (result < 0) {
-		dev_err(idev, "LEGO USB Tower get version control request failed\n");
+	if (result < sizeof(*get_version_reply)) {
+		if (result >= 0)
+			result = -EIO;
+		dev_err(idev, "get version request failed: %d\n", result);
 		retval = result;
 		goto error;
 	}


