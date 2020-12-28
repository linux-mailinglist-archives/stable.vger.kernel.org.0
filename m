Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE42F2E3FFC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502926AbgL1OXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502923AbgL1OXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2111229C5;
        Mon, 28 Dec 2020 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165415;
        bh=Rj1m7vnH1+Avc/wyv1ixCXQSgP2BE6bZljsD3dh4mTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFSPXrkaE3qBfToIZp3Y5RKqG4MacE3AJvwkV7nXLMilPBgZmdWcLcC2d1d2on+so
         nf6nJZJQfOWC8jwLtMA1vbyFuEXMByaJzF0lq391cKUjlHLjsYq5W6AKxMwNvGMyIa
         iimSE6Y0EjaFnbbm0h4EFLLkNc0yOmMWZed6LuD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 524/717] media: ipu3-cio2: Remove traces of returned buffers
Date:   Mon, 28 Dec 2020 13:48:42 +0100
Message-Id: <20201228125046.074691249@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 61e7f892b5ee1dd10ea8bff805f3c3fe6e535959 upstream.

If starting a video buffer queue fails, the buffers are returned to
videobuf2. Remove the reference to the buffer from the driver's queue as
well.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org # v4.16 and up
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -791,6 +791,7 @@ static void cio2_vb2_return_all_buffers(
 			atomic_dec(&q->bufs_queued);
 			vb2_buffer_done(&q->bufs[i]->vbb.vb2_buf,
 					state);
+			q->bufs[i] = NULL;
 		}
 	}
 }


