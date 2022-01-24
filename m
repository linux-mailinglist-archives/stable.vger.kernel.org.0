Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FF24997C2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347513AbiAXVQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:16:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33760 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448020AbiAXVLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:11:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F31D6B8121C;
        Mon, 24 Jan 2022 21:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D495C340E5;
        Mon, 24 Jan 2022 21:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058711;
        bh=AqUHJMQ2oY0NsP6WS7PPXKuOprmnYcXcK6FdrOhbVas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PewUrMZpCqOV30LoK6McSnp1HXenZbUZpU/EZH9Z2Dz80cGj9sTsSnXSgwXz9lyNT
         AACOs+vrgGvxmPXSeK48F/n4hXp9zgYzAP+4hQySTrER080KcxJ2w9WZBHTOCyAvnE
         0puTROgrWaK9FwqwdC7GVaahhdeQWp2TTpo/08sI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Qiang Wang <wangqiang.wq.frank@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0378/1039] libbpf: Use probe_name for legacy kprobe
Date:   Mon, 24 Jan 2022 19:36:07 +0100
Message-Id: <20220124184138.019901056@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiang Wang <wangqiang.wq.frank@bytedance.com>

[ Upstream commit 71cff670baff5cc6a6eeb0181e2cc55579c5e1e0 ]

Fix a bug in commit 46ed5fc33db9, which wrongly used the
func_name instead of probe_name to register legacy kprobe.

Fixes: 46ed5fc33db9 ("libbpf: Refactor and simplify legacy kprobe code")
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Link: https://lore.kernel.org/bpf/20211227130713.66933-1-wangqiang.wq.frank@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fd25e30e70cc2..2696f0b7f0acc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9769,7 +9769,7 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 		gen_kprobe_legacy_event_name(probe_name, sizeof(probe_name),
 					     func_name, offset);
 
-		legacy_probe = strdup(func_name);
+		legacy_probe = strdup(probe_name);
 		if (!legacy_probe)
 			return libbpf_err_ptr(-ENOMEM);
 
-- 
2.34.1



