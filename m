Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38D73DA4DB
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237938AbhG2N4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237924AbhG2N4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C93F260EB2;
        Thu, 29 Jul 2021 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627566991;
        bh=bP7EfWyYpsjKDH4AQ8uVNKRnm8HyzjShB9bWxlcPHOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQBjpMyDI9+zGYMH8TIiMMfXHfEdFgT5GxT6pKBjKJ88YgaVcGnuTqmy/qE4+JUdC
         U5iGjnfyn9xOTfBsl2zoauqE+AXco55STVcYasV6sDOQTm7AbbcqJ5UYOObzeQT50c
         sxhc1boZ7AhrI0BlO1M4om3eH08V602hyGVlRfFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/17] cifs: fix the out of range assignment to bit fields in parse_server_interfaces
Date:   Thu, 29 Jul 2021 15:54:17 +0200
Message-Id: <20210729135137.769364154@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit c9c9c6815f9004ee1ec87401ed0796853bd70f1b ]

Because the out of range assignment to bit fields
are compiler-dependant, the fields could have wrong
value.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5a14f518cd97..61955a7c838b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -386,8 +386,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 	while (bytes_left >= sizeof(*p)) {
 		info->speed = le64_to_cpu(p->LinkSpeed);
-		info->rdma_capable = le32_to_cpu(p->Capability & RDMA_CAPABLE);
-		info->rss_capable = le32_to_cpu(p->Capability & RSS_CAPABLE);
+		info->rdma_capable = le32_to_cpu(p->Capability & RDMA_CAPABLE) ? 1 : 0;
+		info->rss_capable = le32_to_cpu(p->Capability & RSS_CAPABLE) ? 1 : 0;
 
 		cifs_dbg(FYI, "%s: adding iface %zu\n", __func__, *iface_count);
 		cifs_dbg(FYI, "%s: speed %zu bps\n", __func__, info->speed);
-- 
2.30.2



