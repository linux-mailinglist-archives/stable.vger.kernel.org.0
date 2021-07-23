Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EBE3D32E9
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhGWDSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234290AbhGWDSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E01560EFD;
        Fri, 23 Jul 2021 03:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012730;
        bh=bP7EfWyYpsjKDH4AQ8uVNKRnm8HyzjShB9bWxlcPHOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E//7lXsnjZ4QL8osvX+XkrovwMPpzfCIfrD0ILdyvlhllTkDZ50o8wVIFt453k6ci
         dNN6FdZw0XJKKH80PWZm3yGkKr5JIRYv53zFrNwTuB0acLjOtwj0v3C01NPR7/Mt4r
         bAeYJ5rnCxTcFIoCwSJKGFPATQ49dOD6JiOtqSizrgXSY9T1ZxnHwRbOBYfTJoVkp0
         2IZ/0gtdDus8V+12j8UgclH+/SuVswZmnXlkQISx91nPa9Ix9vaJPay7rYdwb3fpJH
         MUg/3begOlbpZVjZGaJy9EzzkHUfxVpVEsxhrDFCqFq4HDSqF9zfw3nw8XLWxbC446
         EWjZ26oaOdYKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.19 10/11] cifs: fix the out of range assignment to bit fields in parse_server_interfaces
Date:   Thu, 22 Jul 2021 23:58:34 -0400
Message-Id: <20210723035835.532148-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035835.532148-1-sashal@kernel.org>
References: <20210723035835.532148-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

