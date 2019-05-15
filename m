Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606541F3E4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfEOLBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfEOLBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:01:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB75D20881;
        Wed, 15 May 2019 11:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918097;
        bh=COjpMTKRrd6+rqyZlyYzLSofHABkiXx5LjRNNSNKVjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVoeLQOv1bh9JqgMuN7oo81ydeI+zTqJ5JbkpDeRLpeZwXaBNruRK4hVl4+bWVivU
         gzvUY3Le79JdxAyozu7y0ZmrOrz/mjzVAJRwFSTHU0Cz4CP6ZNxBV4QZQ4PaaX9HFl
         b7x1rR1mT5Hm/5OBuQjYFzr8sQABiAaWpGsTy3PI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3.18 64/86] platform/x86: sony-laptop: Fix unintentional fall-through
Date:   Wed, 15 May 2019 12:55:41 +0200
Message-Id: <20190515090654.585128581@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 1cbd7a64959d33e7a2a1fa2bf36a62b350a9fcbd upstream.

It seems that the default case should return AE_CTRL_TERMINATE, instead
of falling through to case ACPI_RESOURCE_TYPE_END_TAG and returning AE_OK;
otherwise the line of code at the end of the function is unreachable and
makes no sense:

return AE_CTRL_TERMINATE;

This fix is based on the following thread of discussion:

https://lore.kernel.org/patchwork/patch/959782/

Fixes: 33a04454527e ("sony-laptop: Add SNY6001 device handling (sonypi reimplementation)")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/sony-laptop.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -4399,14 +4399,16 @@ sony_pic_read_possible_resource(struct a
 			}
 			return AE_OK;
 		}
+
+	case ACPI_RESOURCE_TYPE_END_TAG:
+		return AE_OK;
+
 	default:
 		dprintk("Resource %d isn't an IRQ nor an IO port\n",
 			resource->type);
+		return AE_CTRL_TERMINATE;
 
-	case ACPI_RESOURCE_TYPE_END_TAG:
-		return AE_OK;
 	}
-	return AE_CTRL_TERMINATE;
 }
 
 static int sony_pic_possible_resources(struct acpi_device *device)


