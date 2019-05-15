Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94B91EE6F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbfEOLVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731295AbfEOLVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:21:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F404206BF;
        Wed, 15 May 2019 11:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919290;
        bh=pL0hkTf2rl78dlcSOKzwSlb/2Hh1mO15LS8IoPCp9ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w66YnCRVKToR7yR5oWEohRJA3hZAhZwjpzU73v6lm3JanzqraO57nTxkMf8ON/fH8
         9x7/bSt+4XRRcN11WIG5v3Jv7QdG1Zhv+9pXGxpXKMRpa7ZCCCsiP9kiO0rXbr9acq
         TUZHG/fe350AWIVxy7ec7xy7DthQmWNV13L6uLl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 002/113] platform/x86: sony-laptop: Fix unintentional fall-through
Date:   Wed, 15 May 2019 12:54:53 +0200
Message-Id: <20190515090652.993636012@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
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
@@ -4424,14 +4424,16 @@ sony_pic_read_possible_resource(struct a
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


