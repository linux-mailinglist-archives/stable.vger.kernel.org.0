Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886A012207C
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfLQAzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:55:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35272 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbfLQAvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003Mn-N7; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005Zh-MC; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vineet Gupta" <vgupta@synopsys.com>,
        "Alexey Brodkin" <abrodkin@synopsys.com>,
        "Alexey Brodkin" <Alexey.Brodkin@synopsys.com>
Date:   Tue, 17 Dec 2019 00:46:57 +0000
Message-ID: <lsq.1576543535.455415966@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 083/136] ARC: perf: Accommodate big-endian CPU
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>

commit 5effc09c4907901f0e71e68e5f2e14211d9a203f upstream.

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
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arc/kernel/perf_event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -274,8 +274,8 @@ static int arc_pmu_device_probe(struct p
 
 	for (j = 0; j < cc_bcr.c; j++) {
 		write_aux_reg(ARC_REG_CC_INDEX, j);
-		cc_name.indiv.word0 = read_aux_reg(ARC_REG_CC_NAME0);
-		cc_name.indiv.word1 = read_aux_reg(ARC_REG_CC_NAME1);
+		cc_name.indiv.word0 = le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME0));
+		cc_name.indiv.word1 = le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME1));
 		for (i = 0; i < ARRAY_SIZE(arc_pmu_ev_hw_map); i++) {
 			if (arc_pmu_ev_hw_map[i] &&
 			    !strcmp(arc_pmu_ev_hw_map[i], cc_name.str) &&

