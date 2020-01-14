Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF91E13A506
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgANKEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbgANKEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:04:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE30324676;
        Tue, 14 Jan 2020 10:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996240;
        bh=cl//97gjwkIRDOCGwDGVLNszVfvVjfRu9Q3YSsNAVko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxCyEiKxUcwXNoDI5s00CoXfkKQ04l+qnLj3Srqfz9L2FWpb+uFf71pMsi+p5wW7w
         +tQEcFLJbLql7gAgoO+cOI3FUfag0ZCpqG31dEkivHxjR7/6jqf8bvUEjPhgcjLVAB
         l0S5jFy3JGrVfyj/OkGigBmhJ4khnDeZacFYhWCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>, Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.4 28/78] drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ
Date:   Tue, 14 Jan 2020 11:01:02 +0100
Message-Id: <20200114094357.456942081@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

commit c4e4fccc5d52d881afaac11d3353265ef4eccb8b upstream.

[Why]
According to DP spec, it should shift left 4 digits for NO_STOP_BIT
in REMOTE_I2C_READ message. Not 5 digits.

In current code, NO_STOP_BIT is always set to zero which means I2C
master is always generating a I2C stop at the end of each I2C write
transaction while handling REMOTE_I2C_READ sideband message. This issue
might have the generated I2C signal not meeting the requirement. Take
random read in I2C for instance, I2C master should generate a repeat
start to start to read data after writing the read address. This issue
will cause the I2C master to generate a stop-start rather than a
re-start which is not expected in I2C random read.

[How]
Correct the shifting value of NO_STOP_BIT for DP_REMOTE_I2C_READ case in
drm_dp_encode_sideband_req().

Changes since v1:(https://patchwork.kernel.org/patch/11312667/)
* Add more descriptions in commit and cc to stable

Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200103055001.10287-1-Wayne.Lin@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -339,7 +339,7 @@ static void drm_dp_encode_sideband_req(s
 			memcpy(&buf[idx], req->u.i2c_read.transactions[i].bytes, req->u.i2c_read.transactions[i].num_bytes);
 			idx += req->u.i2c_read.transactions[i].num_bytes;
 
-			buf[idx] = (req->u.i2c_read.transactions[i].no_stop_bit & 0x1) << 5;
+			buf[idx] = (req->u.i2c_read.transactions[i].no_stop_bit & 0x1) << 4;
 			buf[idx] |= (req->u.i2c_read.transactions[i].i2c_transaction_delay & 0xf);
 			idx++;
 		}


