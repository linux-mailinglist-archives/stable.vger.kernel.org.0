Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D484D3DA568
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbhG2OBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238580AbhG2N7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:59:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 733D260EBC;
        Thu, 29 Jul 2021 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567156;
        bh=fXLshooyu6CXZgrwY9P/V1miLE1nXfHBUuRz6MhFA+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jqw/PpJjnkeAEgJmuFyUw0cbxJoXCJJQrYz+ANKn5WE9FMmBTHzyQE7ho6tfw/XQd
         0wg/k37kP/qlFCPj5KGNg+1y/4vghsn1IBL2Ulj5MV0H5E7eQDVExTAGmSqXke8RrJ
         ajPhZIcnRjmzx3QAPVttXbgdwIP3Uxe1ChjivhmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 18/22] cifs: fix the out of range assignment to bit fields in parse_server_interfaces
Date:   Thu, 29 Jul 2021 15:54:49 +0200
Message-Id: <20210729135137.903737924@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
References: <20210729135137.336097792@linuxfoundation.org>
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
index 64cad843ce72..398c941e3897 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -555,8 +555,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
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



