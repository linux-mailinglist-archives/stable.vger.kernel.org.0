Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E814A66742D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjALOD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbjALODX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:03:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999AB517C3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37D9E60AB3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD8C433EF;
        Thu, 12 Jan 2023 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532201;
        bh=X1jEoKlEuN1HMnmds3YmDePDpDM3RRYLTf26AB9bl7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHcWiwoPcoE9WFoqUA1gfSH12TXyaosg0s0rUFM4d4PJ5gCfHdr4s/SKKCSp95cGK
         x+xFck/Pk8N1ngL17IqaVcJhSsQzLhwwYcdca/wJN/jNCajwXDXLwnQHaitIl0STKh
         E72VQcyLqHH5vVwc4kIWcIlUGHjOqdWtK3zCtK48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Phil Auld <pauld@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/783] cpu/hotplug: Make target_store() a nop when target == state
Date:   Thu, 12 Jan 2023 14:46:40 +0100
Message-Id: <20230112135528.061657316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Auld <pauld@redhat.com>

[ Upstream commit 64ea6e44f85b9b75925ebe1ba0e6e8430cc4e06f ]

Writing the current state back in hotplug/target calls cpu_down()
which will set cpu dying even when it isn't and then nothing will
ever clear it. A stress test that reads values and writes them back
for all cpu device files in sysfs will trigger the BUG() in
select_fallback_rq once all cpus are marked as dying.

kernel/cpu.c::target_store()
	...
        if (st->state < target)
                ret = cpu_up(dev->id, target);
        else
                ret = cpu_down(dev->id, target);

cpu_down() -> cpu_set_state()
	 bool bringup = st->state < target;
	 ...
	 if (cpu_dying(cpu) != !bringup)
		set_cpu_dying(cpu, !bringup);

Fix this by letting state==target fall through in the target_store()
conditional. Also make sure st->target == target in that case.

Fixes: 757c989b9994 ("cpu/hotplug: Make target state writeable")
Signed-off-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://lore.kernel.org/r/20221117162329.3164999-2-pauld@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3c9ee966c56a..008b50da2224 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2231,8 +2231,10 @@ static ssize_t write_cpuhp_target(struct device *dev,
 
 	if (st->state < target)
 		ret = cpu_up(dev->id, target);
-	else
+	else if (st->state > target)
 		ret = cpu_down(dev->id, target);
+	else if (WARN_ON(st->target != target))
+		st->target = target;
 out:
 	unlock_device_hotplug();
 	return ret ? ret : count;
-- 
2.35.1



