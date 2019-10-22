Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5E6E05D9
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 16:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389029AbfJVOEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 10:04:22 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:35144 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388435AbfJVOEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 10:04:22 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2495DC0D58;
        Tue, 22 Oct 2019 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1571753061; bh=PlFMRCj9hMpOe7fD5AdKfYzQfRNkA41VuXOPF/zY0I4=;
        h=From:To:Cc:Subject:Date:From;
        b=gUpL5SAIZnWNDGO7a7mPmwl+MZsM4kZ/WNmGkOAhaybPAIxG93H+Md4ylWbSmYM4u
         G2HeqRFYlpkzD/FtIhHyQAcixWNH/HqEZHT3Xil5C+L6xZJwb7ZDTmy5nA55tajZWc
         DgnY4zmdYgUwRnJaaA5ifsvMZPC1aslwSzaS10lndy8u+kEQadASEcfzmPNiYP4Dht
         WIBc1YathvVxpEaLQWHg9/y0O8blWzbxCfnNPH3vWhFd+Q4wz3/iH10m7yxgBTGwZs
         6oNmYp6EP/Tlxa0gm1rWNAZd1Io4M+FmB495C2Aoj4SoATtLn5P20WrCx6CS3xFxWa
         okEiGQG5PoYCA==
Received: from ru20arcgnu1.internal.synopsys.com (ru20arcgnu1.internal.synopsys.com [10.121.9.48])
        by mailhost.synopsys.com (Postfix) with ESMTP id CA9CDA005D;
        Tue, 22 Oct 2019 14:04:13 +0000 (UTC)
From:   Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To:     linux-snps-arc@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        stable@vger.kernel.org
Subject: [PATCH] ARC: perf: Accommodate big-endian CPU
Date:   Tue, 22 Oct 2019 17:04:11 +0300
Message-Id: <20191022140411.10193-1-abrodkin@synopsys.com>
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
 arch/arc/kernel/perf_event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
index 861a8aea51f9..661fd842ea97 100644
--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -614,8 +614,8 @@ static int arc_pmu_device_probe(struct platform_device *pdev)
 	/* loop thru all available h/w condition indexes */
 	for (i = 0; i < cc_bcr.c; i++) {
 		write_aux_reg(ARC_REG_CC_INDEX, i);
-		cc_name.indiv.word0 = read_aux_reg(ARC_REG_CC_NAME0);
-		cc_name.indiv.word1 = read_aux_reg(ARC_REG_CC_NAME1);
+		cc_name.indiv.word0 = le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME0));
+		cc_name.indiv.word1 = le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME1));
 
 		arc_pmu_map_hw_event(i, cc_name.str);
 		arc_pmu_add_raw_event_attr(i, cc_name.str);
-- 
2.16.2

