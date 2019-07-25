Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A448C7581B
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 21:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfGYTkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 15:40:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbfGYTkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 15:40:20 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B457883F45;
        Thu, 25 Jul 2019 19:40:19 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-11.bss.redhat.com [10.20.1.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F194A5C6D9;
        Thu, 25 Jul 2019 19:40:18 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drm/nouveau: Don't retry infinitely when receiving no data on i2c over AUX
Date:   Thu, 25 Jul 2019 15:40:01 -0400
Message-Id: <20190725194005.16572-3-lyude@redhat.com>
In-Reply-To: <20190725194005.16572-1-lyude@redhat.com>
References: <20190725194005.16572-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 25 Jul 2019 19:40:19 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While I had thought I had fixed this issue in:

commit 342406e4fbba ("drm/nouveau/i2c: Disable i2c bus access after
->fini()")

It turns out that while I did fix the error messages I was seeing on my
P50 when trying to access i2c busses with the GPU in runtime suspend, I
accidentally had missed one important detail that was mentioned on the
bug report this commit was supposed to fix: that the CPU would only lock
up when trying to access i2c busses _on connected devices_ _while the
GPU is not in runtime suspend_. Whoops. That definitely explains why I
was not able to get my machine to hang with i2c bus interactions until
now, as plugging my P50 into it's dock with an HDMI monitor connected
allowed me to finally reproduce this locally.

Now that I have managed to reproduce this issue properly, it looks like
the problem is much simpler then it looks. It turns out that some
connected devices, such as MST laptop docks, will actually ACK i2c reads
even if no data was actually read:

[  275.063043] nouveau 0000:01:00.0: i2c: aux 000a: 1: 0000004c 1
[  275.063447] nouveau 0000:01:00.0: i2c: aux 000a: 00 01101000 10040000
[  275.063759] nouveau 0000:01:00.0: i2c: aux 000a: rd 00000001
[  275.064024] nouveau 0000:01:00.0: i2c: aux 000a: rd 00000000
[  275.064285] nouveau 0000:01:00.0: i2c: aux 000a: rd 00000000
[  275.064594] nouveau 0000:01:00.0: i2c: aux 000a: rd 00000000

Because we don't handle the situation of i2c ack without any data, we
end up entering an infinite loop in nvkm_i2c_aux_i2c_xfer() since the
value of cnt always remains at 0. This finally properly explains how
this could result in a CPU hang like the ones observed in the
aforementioned commit.

So, fix this by retrying transactions if no data is written or received,
and give up and fail the transaction if we continue to not write or
receive any data after 32 retries.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
index b4e7404fe660..a11637b0f6cc 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
@@ -40,8 +40,7 @@ nvkm_i2c_aux_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 		u8 *ptr = msg->buf;
 
 		while (remaining) {
-			u8 cnt = (remaining > 16) ? 16 : remaining;
-			u8 cmd;
+			u8 cnt, retries, cmd;
 
 			if (msg->flags & I2C_M_RD)
 				cmd = 1;
@@ -51,10 +50,19 @@ nvkm_i2c_aux_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			if (mcnt || remaining > 16)
 				cmd |= 4; /* MOT */
 
-			ret = aux->func->xfer(aux, true, cmd, msg->addr, ptr, &cnt);
-			if (ret < 0) {
-				nvkm_i2c_aux_release(aux);
-				return ret;
+			for (retries = 0, cnt = 0;
+			     retries < 32 && !cnt;
+			     retries++) {
+				cnt = min_t(u8, remaining, 16);
+				ret = aux->func->xfer(aux, true, cmd,
+						      msg->addr, ptr, &cnt);
+				if (ret < 0)
+					goto out;
+			}
+			if (!cnt) {
+				AUX_TRACE(aux, "no data after 32 retries");
+				ret = -EIO;
+				goto out;
 			}
 
 			ptr += cnt;
@@ -64,8 +72,10 @@ nvkm_i2c_aux_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 		msg++;
 	}
 
+	ret = num;
+out:
 	nvkm_i2c_aux_release(aux);
-	return num;
+	return ret;
 }
 
 static u32
-- 
2.21.0

