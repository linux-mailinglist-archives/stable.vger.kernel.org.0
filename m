Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDB317AA81
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 17:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgCEQaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 11:30:11 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40186 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgCEQaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 11:30:10 -0500
Received: by mail-ed1-f65.google.com with SMTP id a13so7522164edu.7
        for <stable@vger.kernel.org>; Thu, 05 Mar 2020 08:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/+zqQclKUiPOxDf9bmBm73rCAC1WKMa2SzoJYpByfBU=;
        b=aanvPBPnU6nRimN+8HFckTLGPWFGHn6Zo0R4D3CZBUwnurXw2COlpSHyfdduYkuRL5
         cGSoBhpRd2kn2rhq95Hkm5ILe4baXl2kvVGBp977VSPj5JIghGLN+ohBXFVK4cTV5dsE
         ia0e6nUKbUb06CTOhJ1qU9z+VZBj/H3vtE9DpQxJQIYURZ2NTWpDVFOwlRU8Ozfum24r
         V49DdY5d87kKO6HRZN0C2qNP4sS6SRi9tF0TUr9WPqRi/wiqwLbZu1JSDxzc2KOqBiD2
         g5KRr9X0jNEwJjqTJOPPI1HOOen1dqB6w0mZaLXRM4nK0dabE9nRDfD/RTyWx/Jl1tUC
         8I2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/+zqQclKUiPOxDf9bmBm73rCAC1WKMa2SzoJYpByfBU=;
        b=BHc59HXc/0sRbmRh00BUyIIhend8Qj7G7zY+wPz21WbGYTr0Q8xC2N6AxX/HvLWpls
         XIwkJvId7TxJD/za6vpq8yWeaf4/TjT1V7CCwCz9kl/0nIBT8x6UQcswNuJNqTxdbPV5
         fmqVxyhW2oNl79o8H4zD0ap1j3drcR3B9FZxVsz8Ew+YqQmpIAjOa7cUMXoIlWwJS60v
         tyuWBtvnCj8NcvgIbFwzE14matp3Ye8gI7vCUmTRSiSR1wpfOAxYtYohUIqrzm1yv/yY
         4U1bczCyNYsVBNb3ixt9csYyT58BGz4DWSWjmyzrlIHpeV6/esispqMsAMApFl1s6MGu
         ZtDA==
X-Gm-Message-State: ANhLgQ0YBbLNgvKzkfavTiKSOvC+DmXbbOLdjh5CdyYPxUEu3wDWjxET
        dVLsc6X5XEwe/9Tw4aVlCSBhipY9
X-Google-Smtp-Source: ADFU+vvF74HhtvbK0c3Zrcm1gHGPO6DZtw2Q3D+WISyOSQgfwtEadpYRprH9/ytvvmfxsAZXvfTawg==
X-Received: by 2002:a50:f686:: with SMTP id d6mr9492006edn.285.1583425809177;
        Thu, 05 Mar 2020 08:30:09 -0800 (PST)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:d8ec:cf8e:d7de:fb22])
        by smtp.gmail.com with ESMTPSA id h22sm293651edq.28.2020.03.05.08.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 08:30:08 -0800 (PST)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.14 1/3] vhost: Check docket sk_family instead of call getname
Date:   Thu,  5 Mar 2020 17:30:05 +0100
Message-Id: <20200305163007.25659-2-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305163007.25659-1-jinpuwang@gmail.com>
References: <20200305163007.25659-1-jinpuwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugenio Pérez <eperezma@redhat.com>

commit 42d84c8490f9f0931786f1623191fcab397c3d64 upstream.

Doing so, we save one call to get data we already have in the struct.

Also, since there is no guarantee that getname use sockaddr_ll
parameter beyond its size, we add a little bit of security here.
It should do not do beyond MAX_ADDR_LEN, but syzbot found that
ax25_getname writes more (72 bytes, the size of full_sockaddr_ax25,
versus 20 + 32 bytes of sockaddr_ll + MAX_ADDR_LEN in syzbot repro).

Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
Reported-by: syzbot+f2a62d07a5198c819c7b@syzkaller.appspotmail.com
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[jwang: backport to 4.14]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/vhost/net.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 4d11152e60c1..8fe07622ae59 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1025,11 +1025,7 @@ static int vhost_net_release(struct inode *inode, struct file *f)
 
 static struct socket *get_raw_socket(int fd)
 {
-	struct {
-		struct sockaddr_ll sa;
-		char  buf[MAX_ADDR_LEN];
-	} uaddr;
-	int uaddr_len = sizeof uaddr, r;
+	int r;
 	struct socket *sock = sockfd_lookup(fd, &r);
 
 	if (!sock)
@@ -1041,12 +1037,7 @@ static struct socket *get_raw_socket(int fd)
 		goto err;
 	}
 
-	r = sock->ops->getname(sock, (struct sockaddr *)&uaddr.sa,
-			       &uaddr_len, 0);
-	if (r)
-		goto err;
-
-	if (uaddr.sa.sll_family != AF_PACKET) {
+	if (sock->sk->sk_family != AF_PACKET) {
 		r = -EPFNOSUPPORT;
 		goto err;
 	}
-- 
2.17.1

