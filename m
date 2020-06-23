Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602C92064E2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389263AbgFWUPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389076AbgFWUPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:15:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1918520E65;
        Tue, 23 Jun 2020 20:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943331;
        bh=i5iK6Geo9zFFEd/wda9ByJSv2VnmGt0IxoWxQFcwyOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtXEBu3XiTS1ARgnix60SOhR3QRKiZzUgkwb8S52E/OmKchKtLkwI+U4Ut3Gl38KR
         C5TJxuwk+qTf4Sk2rukIVG7hqUHDIVqbhW2ikQJPNERbv7JR48OJhMUUXn3xMdjtRz
         +BB53a7l3f7QGC8wafi9h5kUKkVRNBQ76qPcWqQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 351/477] selftests/net: in timestamping, strncpy needs to preserve null byte
Date:   Tue, 23 Jun 2020 21:55:48 +0200
Message-Id: <20200623195424.131507166@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 tools/testing/selftests/net/timestamping.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/timestamping.c b/tools/testing/selftests/net/timestamping.c
index aca3491174a1e..f4bb4fef0f399 100644
--- a/tools/testing/selftests/net/timestamping.c
+++ b/tools/testing/selftests/net/timestamping.c
@@ -313,10 +313,16 @@ int main(int argc, char **argv)
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
@@ -350,12 +356,12 @@ int main(int argc, char **argv)
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



