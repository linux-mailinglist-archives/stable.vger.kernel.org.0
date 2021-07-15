Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237323CA74F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbhGOSxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239159AbhGOSwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:52:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BA6613D1;
        Thu, 15 Jul 2021 18:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374990;
        bh=9oZV2sweLG7QNjxJq5lidgr3AufUJfafWyGDoLTwjao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKyJ+n19YfzubNDrYBbWsNWRQ7baEAmU8PDAkbLYUJQB94LoZLM7W1eNVQDNY6uhU
         aZhV7B8FG2J2JzWvtKqI7K8IJJRy/P/LEmDO5W3NmVbjA8Adw7PcuWBQSYXZSjUQ6t
         kecD00KCwcw54O4K+rVeae8ElVIrVdtYZmNqOGu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/215] media, bpf: Do not copy more entries than user space requested
Date:   Thu, 15 Jul 2021 20:38:05 +0200
Message-Id: <20210715182619.516039030@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 647d446d66e493d23ca1047fa8492b0269674530 ]

The syscall bpf(BPF_PROG_QUERY, &attr) should use the prog_cnt field to
see how many entries user space provided and return ENOSPC if there are
more programs than that. Before this patch, this is not checked and
ENOSPC is never returned.

Note that one lirc device is limited to 64 bpf programs, and user space
I'm aware of -- ir-keytable -- always gives enough space for 64 entries
already. However, we should not copy program ids than are requested.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210623213754.632-1-sean@mess.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/bpf-lirc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 3fe3edd80876..afae0afe3f81 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -326,7 +326,8 @@ int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 	}
 
 	if (attr->query.prog_cnt != 0 && prog_ids && cnt)
-		ret = bpf_prog_array_copy_to_user(progs, prog_ids, cnt);
+		ret = bpf_prog_array_copy_to_user(progs, prog_ids,
+						  attr->query.prog_cnt);
 
 unlock:
 	mutex_unlock(&ir_raw_handler_lock);
-- 
2.30.2



