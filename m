Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF57B3DA549
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbhG2OAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238044AbhG2N6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0921F60F4A;
        Thu, 29 Jul 2021 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567102;
        bh=G7spxjMpajrUiAs4d1yBhjMqin7zNSC/4LN4x7znHHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0mvcKcVOVv5XYVQe+Ium88lUV/4IVa/ue4enr2M0mhC8qC4N3ozerinYQBWoyHxU
         oJ1wqAY596tyGlXWvy7w6Nnsm+UuoqFlOYVLmEY/oZGkUVuzZLsMXT5DQ42zMuxR9z
         i/jObNbSIaLaVdwJArKKjbiBzexM0CQ/XemwjaEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/24] cifs: fix the out of range assignment to bit fields in parse_server_interfaces
Date:   Thu, 29 Jul 2021 15:54:40 +0200
Message-Id: <20210729135137.892961735@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
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
index b0b06eb86edf..81e087723777 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -497,8 +497,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
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



