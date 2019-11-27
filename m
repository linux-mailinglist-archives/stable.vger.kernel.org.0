Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855E110BBB1
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387656AbfK0VPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:15:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387653AbfK0VPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:15:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 365E621771;
        Wed, 27 Nov 2019 21:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889307;
        bh=in531OI/aSvSHnK/VUVcGLFwWJ/vlmpNhxmEMvrlhx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOirw/OZvJ9quJJpB/wjqm0owRBFrQgdTQO+/GdCyjx6ptwoG9toz2qYDVO67ScV5
         EICkgOQZWNTjtIh5k6444IJDn1gmgdlLxeDWkaBwIk4717ZZalmRvmKnqP3vwPGudg
         HbhPfXxJVqA7lzr00TRqjDEwMeP/ExDb7wQrW9Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hewenliang <hewenliang4@huawei.com>
Subject: [PATCH 5.4 54/66] usbip: tools: fix fd leakage in the function of read_attr_usbip_status
Date:   Wed, 27 Nov 2019 21:32:49 +0100
Message-Id: <20191127202734.350489840@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hewenliang <hewenliang4@huawei.com>

commit 26a4d4c00f85cb844dd11dd35e848b079c2f5e8f upstream.

We should close the fd before the return of read_attr_usbip_status.

Fixes: 3391ba0e2792 ("usbip: tools: Extract generic code to be shared with vudc backend")
Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191025043515.20053-1-hewenliang4@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/usb/usbip/libsrc/usbip_host_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/usb/usbip/libsrc/usbip_host_common.c
+++ b/tools/usb/usbip/libsrc/usbip_host_common.c
@@ -57,7 +57,7 @@ static int32_t read_attr_usbip_status(st
 	}
 
 	value = atoi(status);
-
+	close(fd);
 	return value;
 }
 


