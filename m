Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7CB10AB61
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 09:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfK0IBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 03:01:37 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:34430 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfK0IBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 03:01:37 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1AF5EC0089;
        Wed, 27 Nov 2019 08:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1574841696; bh=09dgk+hW6TJG7TYxyAIHrqyQO/iUQcOtqxjGgerQ3TM=;
        h=From:To:Cc:Subject:Date:From;
        b=YJKCeqOugtUW3Nqi+6gDVs9Dscd6SC4sodYLHdWyzmcjibtecLVZG+0GfKHNbtm89
         WtuDOoxveuW9Lr/zhXZ0p8U70apyVaA94wPhssysqANn+q+XCD3thzHK5lGRQIMSCo
         9qONG1v+PwFB33PDvApg1sGC2aMFpqpf4wBA4h2+Pp+W5nk2gam7Llhno54eQMPYR+
         yyZkBHz4NKr3KU7imRjdSCu7nDavagC6k11cFlvKvaT/KO1N7ls3hxgDu/oeMBaqq8
         NTrZGTHDJOBjdAgBqg70AAy9eQqz6njPjeo7wRCdf0tUgV3qz7O7k9dCZuc85YWv02
         rIyppgKjfHuBQ==
Received: from ru20arcgnu1.internal.synopsys.com (ru20arcgnu1.internal.synopsys.com [10.121.9.48])
        by mailhost.synopsys.com (Postfix) with ESMTP id EE9C6A0065;
        Wed, 27 Nov 2019 08:01:33 +0000 (UTC)
From:   Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To:     stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-snps-arc@lists.infradead.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: [PATCH] ARC: perf: Accommodate big-endian CPU
Date:   Wed, 27 Nov 2019 11:01:23 +0300
Message-Id: <20191127080123.21890-1-abrodkin@synopsys.com>
X-Mailer: git-send-email 2.16.2
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

8-letter strings representing ARC perf events are stores in two
32-bit registers as ASCII characters like that: "IJMP", "IALL", "IJMPTAK" etc.

And the same order of bytes in the word is used regardless CPU endianness.

Which means in case of big-endian CPU core we need to swap bytes to get
the same order as if it was on little-endian CPU.

Otherwise we're seeing the following error message on boot:
------------------------->8----------------------
ARC perf        : 8 counters (32 bits), 40 conditions, [overflow IRQ support]
sysfs: cannot create duplicate filename '/devices/arc_pct/events/pmji'
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.2.18 #3
Stack Trace:
  arc_unwind_core+0xd4/0xfc
  dump_stack+0x64/0x80
  sysfs_warn_dup+0x46/0x58
  sysfs_add_file_mode_ns+0xb2/0x168
  create_files+0x70/0x2a0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/events/core.c:12144 perf_event_sysfs_init+0x70/0xa0
Failed to register pmu: arc_pct, reason -17
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.2.18 #3
Stack Trace:
  arc_unwind_core+0xd4/0xfc
  dump_stack+0x64/0x80
  __warn+0x9c/0xd4
  warn_slowpath_fmt+0x22/0x2c
  perf_event_sysfs_init+0x70/0xa0
---[ end trace a75fb9a9837bd1ec ]---
------------------------->8----------------------

What happens here we're trying to register more than one raw perf event
with the same name "PMJI". Why? Because ARC perf events are 4 to 8 letters
and encoded into two 32-bit words. In this particular case we deal with 2
events:
 * "IJMP____" which counts all jump & branch instructions
 * "IJMPC___" which counts only conditional jumps & branches

Those strings are split in two 32-bit words this way "IJMP" + "____" &
"IJMP" + "C___" correspondingly. Now if we read them swapped due to CPU core
being big-endian then we read "PMJI" + "____" & "PMJI" + "___C".

And since we interpret read array of ASCII letters as a null-terminated string
on big-endian CPU we end up with 2 events of the same name "PMJI".

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
Cc: stable@vger.kernel.org
---

Greg, Sasha, this is the same patch as
commit 5effc09c4907 ("ARC: perf: Accommodate big-endian CPU")
but fine-tuned to be applicable to kernels 4.19 and older.

 arch/arc/kernel/perf_event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
index 8aec462d90fb..30f66b123541 100644
--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -490,8 +490,8 @@ static int arc_pmu_device_probe(struct platform_device *pdev)
 	/* loop thru all available h/w condition indexes */
 	for (j = 0; j < cc_bcr.c; j++) {
 		write_aux_reg(ARC_REG_CC_INDEX, j);
-		cc_name.indiv.word0 = read_aux_reg(ARC_REG_CC_NAME0);
-		cc_name.indiv.word1 = read_aux_reg(ARC_REG_CC_NAME1);
+		cc_name.indiv.word0 = le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME0));
+		cc_name.indiv.word1 = le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME1));
 
 		/* See if it has been mapped to a perf event_id */
 		for (i = 0; i < ARRAY_SIZE(arc_pmu_ev_hw_map); i++) {
-- 
2.16.2

