Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28AA20DEBB
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389103AbgF2U2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731758AbgF2TZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA21253CD;
        Mon, 29 Jun 2020 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445301;
        bh=+tp58noZXQoEUGiIglKdWJQNuoOipzmLxZuJLK3D7ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gV0tO65lk3U/jMSmJlrRExtwyPjSBL8iBOq2jWc+IZX7O8oOCpK5FLUJ47csQ0cDu
         tFvhDhFfQXM+MGmWmkw99Cc3G1yKAgO9bojfC8E23KBv22z/PHLoOGkFltJaXgOSxq
         pg7c7gZxaV55tbTm9TR3137bp86OnCO6TnvgnjFc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     tannerlove <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 073/191] selftests/net: in timestamping, strncpy needs to preserve null byte
Date:   Mon, 29 Jun 2020 11:38:09 -0400
Message-Id: <20200629154007.2495120-74-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: tannerlove <tannerlove@google.com>

[ Upstream commit 8027bc0307ce59759b90679fa5d8b22949586d20 ]

If user passed an interface option longer than 15 characters, then
device.ifr_name and hwtstamp.ifr_name became non-null-terminated
strings. The compiler warned about this:

timestamping.c:353:2: warning: ‘strncpy’ specified bound 16 equals \
destination size [-Wstringop-truncation]
  353 |  strncpy(device.ifr_name, interface, sizeof(device.ifr_name));

Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/networking/timestamping/timestamping.c   | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/networking/timestamping/timestamping.c b/tools/testing/selftests/networking/timestamping/timestamping.c
index 5cdfd743447b7..900ed4b478996 100644
--- a/tools/testing/selftests/networking/timestamping/timestamping.c
+++ b/tools/testing/selftests/networking/timestamping/timestamping.c
@@ -332,10 +332,16 @@ int main(int argc, char **argv)
 	int val;
 	socklen_t len;
 	struct timeval next;
+	size_t if_len;
 
 	if (argc < 2)
 		usage(0);
 	interface = argv[1];
+	if_len = strlen(interface);
+	if (if_len >= IFNAMSIZ) {
+		printf("interface name exceeds IFNAMSIZ\n");
+		exit(1);
+	}
 
 	for (i = 2; i < argc; i++) {
 		if (!strcasecmp(argv[i], "SO_TIMESTAMP"))
@@ -369,12 +375,12 @@ int main(int argc, char **argv)
 		bail("socket");
 
 	memset(&device, 0, sizeof(device));
-	strncpy(device.ifr_name, interface, sizeof(device.ifr_name));
+	memcpy(device.ifr_name, interface, if_len + 1);
 	if (ioctl(sock, SIOCGIFADDR, &device) < 0)
 		bail("getting interface IP address");
 
 	memset(&hwtstamp, 0, sizeof(hwtstamp));
-	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
+	memcpy(hwtstamp.ifr_name, interface, if_len + 1);
 	hwtstamp.ifr_data = (void *)&hwconfig;
 	memset(&hwconfig, 0, sizeof(hwconfig));
 	hwconfig.tx_type =
-- 
2.25.1

