Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93613EB8AF
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242309AbhHMPPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242460AbhHMPOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1ACB610FC;
        Fri, 13 Aug 2021 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867626;
        bh=nDQm6gTdxU73JFUOTL+gs+qq/Xera47GLIY0IKrIDEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOTuZarjiRJtevqacGIq4alT+qjANw3ZIVMSWfBCj8m8SSL6c/L9UqFlwSSjMrsxd
         ynU0eo0cQmn/uBnvlMAzni4gNHrspJYpPB8ClwSwOhGQ8jJA9lvA79Zi77tAUN1Fhh
         nj1ICttuwNHYG2uXtRkMEmHY6qqPj5Jp1W1xr9Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Lecopzer Chen <lecopzer.chen@mediatek.com>
Subject: [PATCH 5.4 03/27] media: v4l2-mem2mem: always consider OUTPUT queue during poll
Date:   Fri, 13 Aug 2021 17:07:01 +0200
Message-Id: <20210813150523.479037958@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Courbot <gnurou@gmail.com>

commit 566463afdbc43c7744c5a1b89250fc808df03833 upstream.

If poll() is called on a m2m device with the EPOLLOUT event after the
last buffer of the CAPTURE queue is dequeued, any buffer available on
OUTPUT queue will never be signaled because v4l2_m2m_poll_for_data()
starts by checking whether dst_q->last_buffer_dequeued is set and
returns EPOLLIN in this case, without looking at the state of the OUTPUT
queue.

Fix this by not early returning so we keep checking the state of the
OUTPUT queue afterwards.

Signed-off-by: Alexandre Courbot <gnurou@gmail.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -635,10 +635,8 @@ static __poll_t v4l2_m2m_poll_for_data(s
 		 * If the last buffer was dequeued from the capture queue,
 		 * return immediately. DQBUF will return -EPIPE.
 		 */
-		if (dst_q->last_buffer_dequeued) {
-			spin_unlock_irqrestore(&dst_q->done_lock, flags);
-			return EPOLLIN | EPOLLRDNORM;
-		}
+		if (dst_q->last_buffer_dequeued)
+			rc |= EPOLLIN | EPOLLRDNORM;
 	}
 	spin_unlock_irqrestore(&dst_q->done_lock, flags);
 


