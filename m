Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBE2B1E5B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388504AbfIMNJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388498AbfIMNJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:09:24 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26E40206A5;
        Fri, 13 Sep 2019 13:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380163;
        bh=bORrhSqK3pcJToWmKEo0Pa4DNQLJt2fCkk6U57wF2TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtizNrJ8jSyuPyMX8MhD7w0sTzLr3kOqwootL3llKYPOtPlvq2fLaKgxv9L+HOz5h
         NpssmusR30OjkUKqiL79goGdH+mhphsKALyLTxs/IavzNrS6UuatVMG7sARdmMSRiC
         oQlqWNZCy4Ot1PoT0E13d2/XwuCpAE+M+91llDRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lidong Chen <lidongchen@tencent.com>,
        ruippan <ruippan@tencent.com>, yongduan <yongduan@tencent.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 4.9 14/14] vhost: make sure log_num < in_num
Date:   Fri, 13 Sep 2019 14:07:07 +0100
Message-Id: <20190913130446.949716002@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
References: <20190913130440.264749443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yongduan <yongduan@tencent.com>

commit 060423bfdee3f8bc6e2c1bac97de24d5415e2bc4 upstream.

The code assumes log_num < in_num everywhere, and that is true as long as
in_num is incremented by descriptor iov count, and log_num by 1. However
this breaks if there's a zero sized descriptor.

As a result, if a malicious guest creates a vring desc with desc.len = 0,
it may cause the host kernel to crash by overflowing the log array. This
bug can be triggered during the VM migration.

There's no need to log when desc.len = 0, so just don't increment log_num
in this case.

Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
Cc: stable@vger.kernel.org
Reviewed-by: Lidong Chen <lidongchen@tencent.com>
Signed-off-by: ruippan <ruippan@tencent.com>
Signed-off-by: yongduan <yongduan@tencent.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vhost.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1989,7 +1989,7 @@ static int get_indirect(struct vhost_vir
 		/* If this is an input descriptor, increment that count. */
 		if (access == VHOST_ACCESS_WO) {
 			*in_num += ret;
-			if (unlikely(log)) {
+			if (unlikely(log && ret)) {
 				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
 				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
 				++*log_num;
@@ -2125,7 +2125,7 @@ int vhost_get_vq_desc(struct vhost_virtq
 			/* If this is an input descriptor,
 			 * increment that count. */
 			*in_num += ret;
-			if (unlikely(log)) {
+			if (unlikely(log && ret)) {
 				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
 				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
 				++*log_num;


