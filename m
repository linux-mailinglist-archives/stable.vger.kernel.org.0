Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 857B69E025
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbfH0IAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730495AbfH0IAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:00:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD729206BA;
        Tue, 27 Aug 2019 08:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892854;
        bh=EunKMO7NaZsk1SXtNvSwvp1m/3+ajkQvwMfGkrVaCYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGRn7JgR/QPFMdUeveu7qQAVZn4Lth3Jyluy/2BtpnWtbKK0Zn3Mq+iSdO0rjUlNY
         5TJxu99HQIKnK3mCshrM0klkcVnw3OSw9qni+lVJrpoo6FAR44/XM2xEPBuH52OCES
         sdEgevEjU4fuTXbd/8FciGWal7ICOsu2X0+HWX3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 037/162] libbpf: silence GCC8 warning about string truncation
Date:   Tue, 27 Aug 2019 09:49:25 +0200
Message-Id: <20190827072739.562169335@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cb8ffde5694ae5fffb456eae932aac442aa3a207 ]

Despite a proper NULL-termination after strncpy(..., ..., IFNAMSIZ - 1),
GCC8 still complains about *expected* string truncation:

  xsk.c:330:2: error: 'strncpy' output may be truncated copying 15 bytes
  from a string of length 15 [-Werror=stringop-truncation]
    strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);

This patch gets rid of the issue altogether by using memcpy instead.
There is no performance regression, as strncpy will still copy and fill
all of the bytes anyway.

v1->v2:
- rebase against bpf tree.

Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 8e03b65830da0..fa948c5445ecf 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -336,7 +336,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		return -errno;
 
 	ifr.ifr_data = (void *)&channels;
-	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
+	memcpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
 	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
 	err = ioctl(fd, SIOCETHTOOL, &ifr);
 	if (err && errno != EOPNOTSUPP) {
@@ -561,7 +561,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		err = -errno;
 		goto out_socket;
 	}
-	strncpy(xsk->ifname, ifname, IFNAMSIZ - 1);
+	memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
 	xsk->ifname[IFNAMSIZ - 1] = '\0';
 
 	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
-- 
2.20.1



