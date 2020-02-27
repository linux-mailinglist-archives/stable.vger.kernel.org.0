Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D397F172153
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgB0NoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbgB0NoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:44:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0183C20726;
        Thu, 27 Feb 2020 13:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811039;
        bh=vKMWUGzAoBSJssGD/lNWiThFdqknKjAGO2lhp3M16mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0U+iqJGfdqWJYYW5GJ7oFD7cqFXF0WWd+5bZ7zkoXo0636VkmGL5p+67/5GLBFvw
         8vWBqEer57xai+pwPj48HrPe8WQduZc7oZnQXqoi5HPfGpGmYNbB1QGnLgjrLAgCjq
         2FSCCYSAcPaJLlyEIyq3ubXVgclCJzAyq9K+NBy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pietro Oliva <pietroliva@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4.4 092/113] staging: rtl8188eu: Fix potential overuse of kernel memory
Date:   Thu, 27 Feb 2020 14:36:48 +0100
Message-Id: <20200227132226.465499280@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 4ddf8ab8d15ddbc52eefb44eb64e38466ce1f70f upstream.

In routine wpa_supplicant_ioctl(), the user-controlled p->length is
checked to be at least the size of struct ieee_param size, but the code
does not detect the case where p->length is greater than the size
of the struct, thus a malicious user could be wasting kernel memory.
Fixes commit a2c60d42d97c ("Add files for new driver - part 16").

Reported by: Pietro Oliva <pietroliva@gmail.com>
Cc: Pietro Oliva <pietroliva@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Fixes commit a2c60d42d97c ("Add files for new driver - part 16").
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://lore.kernel.org/r/20200210180235.21691-4-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2054,7 +2054,7 @@ static int wpa_supplicant_ioctl(struct n
 	struct ieee_param *param;
 	uint ret = 0;
 
-	if (p->length < sizeof(struct ieee_param) || !p->pointer) {
+	if (!p->pointer || p->length != sizeof(struct ieee_param)) {
 		ret = -EINVAL;
 		goto out;
 	}


