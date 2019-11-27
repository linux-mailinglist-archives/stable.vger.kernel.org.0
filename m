Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC7D10BC69
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbfK0VH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:07:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732244AbfK0VH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3386A2086A;
        Wed, 27 Nov 2019 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888845;
        bh=5W9Egi4zKehIZf+zXK06b5qupqNkKPfecanbW4wj9z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DC90ol6hgwCfuQvuUPCysAHOFoK2NB7j24C31EAqJCv0dPwDXeqFWDWJNO/PFqCc7
         5kw0MCaFO2AAGF9iGlbz/lfYAu7JxYr0jHCg72j0G7tZnM3OSQrxT8Vl4H/F941jQn
         JIPMzwg7JfD8p3gaGLUcqaCeH55aciKi57SmJu1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hewenliang <hewenliang4@huawei.com>
Subject: [PATCH 4.19 293/306] usbip: tools: fix fd leakage in the function of read_attr_usbip_status
Date:   Wed, 27 Nov 2019 21:32:23 +0100
Message-Id: <20191127203136.156881270@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
@@ -69,7 +69,7 @@ static int32_t read_attr_usbip_status(st
 	}
 
 	value = atoi(status);
-
+	close(fd);
 	return value;
 }
 


