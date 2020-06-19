Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CF3200ED0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403861AbgFSPLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403853AbgFSPLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:11:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBC9E2158C;
        Fri, 19 Jun 2020 15:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579507;
        bh=wJyh5j0fx3dTdY/TvsFuOEKeXxSb+H8xonC0coZh0V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEer/xEJph/n1jGsK6dev0bTBhbtsUGFodnBuOCZfECvSd+u+ZPRiFkYWaicwC6cw
         nz8z0xkwMjR5Pwv3cl12zDXzIrXCHx1gZJXGza4uwU4dCCvWV3E+2gQYRZKCiSkxP8
         pW3Z6T69Q5eCWE+44clRiGPmmJXdA612LbAlhROU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Protopopov <a.s.protopopov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/261] bpf: Fix map permissions check
Date:   Fri, 19 Jun 2020 16:32:45 +0200
Message-Id: <20200619141657.254727951@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 1ea0f9120c8ce105ca181b070561df5cbd6bc049 ]

The map_lookup_and_delete_elem() function should check for both FMODE_CAN_WRITE
and FMODE_CAN_READ permissions because it returns a map element to user space.

Fixes: bd513cd08f10 ("bpf: add MAP_LOOKUP_AND_DELETE_ELEM syscall")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200527185700.14658-5-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 946cfdd3b2cc..e7af1ac69d75 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1118,7 +1118,8 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
-	if (!(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
+	if (!(map_get_sys_perms(map, f) & FMODE_CAN_READ) ||
+	    !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
 		err = -EPERM;
 		goto err_put;
 	}
-- 
2.25.1



