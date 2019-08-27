Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AFE9E01D
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbfH0IAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbfH0IAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:00:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5998D217F5;
        Tue, 27 Aug 2019 08:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892834;
        bh=/zzZA9U0vrszr+exayCqiwcHv1WS9ZwywmCOOuoNULQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H98oh5wUvli8zyGKyXeK8sv+nn0giu8oDgLiYEdsNOdgaQmptmnHssFQqkDuVtaoD
         x/HEk88exjmuZT38Hk55Scyqk5LXYoKTHxOpSeb+oB8SF/pZwZklvZ3ICO8Y0E6K2Y
         ixVlZbaf2afgY/BeJ4wyXhFzlYu46wViVbHx5jcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Ilya Maximets <i.maximets@samsung.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 031/162] libbpf: fix using uninitialized ioctl results
Date:   Tue, 27 Aug 2019 09:49:19 +0200
Message-Id: <20190827072739.375906444@linuxfoundation.org>
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

[ Upstream commit decb705e01a5d325c9876b9674043cde4b54f0db ]

'channels.max_combined' initialized only on ioctl success and
errno is only valid on ioctl failure.

The code doesn't produce any runtime issues, but makes memory
sanitizers angry:

 Conditional jump or move depends on uninitialised value(s)
    at 0x55C056F: xsk_get_max_queues (xsk.c:336)
    by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
    by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
    by 0x55C0E57: xsk_socket__create (xsk.c:601)
  Uninitialised value was created by a stack allocation
    at 0x55C04CD: xsk_get_max_queues (xsk.c:318)

Additionally fixed warning on uninitialized bytes in ioctl arguments:

 Syscall param ioctl(SIOCETHTOOL) points to uninitialised byte(s)
    at 0x648D45B: ioctl (in /usr/lib64/libc-2.28.so)
    by 0x55C0546: xsk_get_max_queues (xsk.c:330)
    by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
    by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
    by 0x55C0E57: xsk_socket__create (xsk.c:601)
  Address 0x1ffefff378 is on thread 1's stack
  in frame #1, created by xsk_get_max_queues (xsk.c:318)
  Uninitialised value was created by a stack allocation
    at 0x55C04CD: xsk_get_max_queues (xsk.c:318)

CC: Magnus Karlsson <magnus.karlsson@intel.com>
Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index ca272c5b67f47..8e03b65830da0 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -327,15 +327,14 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 
 static int xsk_get_max_queues(struct xsk_socket *xsk)
 {
-	struct ethtool_channels channels;
-	struct ifreq ifr;
+	struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
+	struct ifreq ifr = {};
 	int fd, err, ret;
 
 	fd = socket(AF_INET, SOCK_DGRAM, 0);
 	if (fd < 0)
 		return -errno;
 
-	channels.cmd = ETHTOOL_GCHANNELS;
 	ifr.ifr_data = (void *)&channels;
 	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
 	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
@@ -345,7 +344,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		goto out;
 	}
 
-	if (channels.max_combined == 0 || errno == EOPNOTSUPP)
+	if (err || channels.max_combined == 0)
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
-- 
2.20.1



