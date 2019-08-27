Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0188C9DF56
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfH0HxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbfH0HxV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:53:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 993BB2173E;
        Tue, 27 Aug 2019 07:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892400;
        bh=nr+XhdCJv5KdUbvjEpdXWa5YBu+SA2axb6GLhdsPhOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJd80qykCQ2ihpbg7K/i8cSJsI4ovn5E+zXDHdSh0nOekjmi0QUOUkInfBE/gAAnW
         3kJxpCnJdjxaWJ6D65xKH3HL6dI6N81yq3Kie7vm4uFownbx8vorR7pjFjmnUtqwd4
         WguqDlwTzv9VOWk3T9uIIVe/i0hYyrnA+gIR5ohk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 4.14 41/62] drm/nouveau: Dont retry infinitely when receiving no data on i2c over AUX
Date:   Tue, 27 Aug 2019 09:50:46 +0200
Message-Id: <20190827072702.989407639@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit c358ebf59634f06d8ed176da651ec150df3c8686 upstream.

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
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c
@@ -40,8 +40,7 @@ nvkm_i2c_aux_i2c_xfer(struct i2c_adapter
 		u8 *ptr = msg->buf;
 
 		while (remaining) {
-			u8 cnt = (remaining > 16) ? 16 : remaining;
-			u8 cmd;
+			u8 cnt, retries, cmd;
 
 			if (msg->flags & I2C_M_RD)
 				cmd = 1;
@@ -51,10 +50,19 @@ nvkm_i2c_aux_i2c_xfer(struct i2c_adapter
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
@@ -64,8 +72,10 @@ nvkm_i2c_aux_i2c_xfer(struct i2c_adapter
 		msg++;
 	}
 
+	ret = num;
+out:
 	nvkm_i2c_aux_release(aux);
-	return num;
+	return ret;
 }
 
 static u32


