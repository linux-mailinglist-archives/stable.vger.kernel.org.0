Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E809976DD1
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389127AbfGZPal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389119AbfGZPal (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:30:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E854205F4;
        Fri, 26 Jul 2019 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155040;
        bh=GQaj6qDMId0prqXX2EQtRMtN/1cgibciF4pkpinytAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t042ePzDHUXFittCjolrcBD1TqFF/Kk7Rc8+dqiij2n4bDFSD2KFYZl0In9biKPKQ
         eE82wSGo0JVIKLESCCNJ3SuZrC7Y0HI9nphvMvuOSfi3SEEmODTV2/nbfjUWuXlDKZ
         FFvEebIEt99g+QfHxbABDHoiElC5TLIRhC+tuMtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>
Subject: [PATCH 5.1 43/62] dma-buf: balance refcount inbalance
Date:   Fri, 26 Jul 2019 17:24:55 +0200
Message-Id: <20190726152306.483670022@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

commit 5e383a9798990c69fc759a4930de224bb497e62c upstream.

The debugfs take reference on fence without dropping them.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: Stéphane Marchesin <marcheu@chromium.org>
Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20181206161840.6578-1-jglisse@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma-buf/dma-buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1068,6 +1068,7 @@ static int dma_buf_debug_show(struct seq
 				   fence->ops->get_driver_name(fence),
 				   fence->ops->get_timeline_name(fence),
 				   dma_fence_is_signaled(fence) ? "" : "un");
+			dma_fence_put(fence);
 		}
 		rcu_read_unlock();
 


