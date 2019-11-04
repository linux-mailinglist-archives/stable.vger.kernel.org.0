Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFB2EEDC3
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390448AbfKDWJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390055AbfKDWJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:41 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C565205C9;
        Mon,  4 Nov 2019 22:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905380;
        bh=+hrQ8CO5V7hymOZF9ycnpXtaRIUVruIS3X+KEKu2Znw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgdabKVQcdKZntvmmgr1kTiBbTgK72mVATDfKjCnR1seu4OWsFDVMdJ9xp7d9HTHV
         hMDWiRuL27weGqVAjPNyy6vKmGMTdR9+H9KOYo51G+VRsCsmaMZnI0/arYQux1IWMD
         7x56mNcvPd2LI18N77qzD7YTc06O1aQypUtFxvHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Brodkin <abrodkin@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.3 125/163] ARC: perf: Accommodate big-endian CPU
Date:   Mon,  4 Nov 2019 22:45:15 +0100
Message-Id: <20191104212149.283501179@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -614,8 +614,8 @@ static int arc_pmu_device_probe(struct p
 	/* loop thru all available h/w condition indexes */
 	for (i = 0; i < cc_bcr.c; i++) {
 		write_aux_reg(ARC_REG_CC_INDEX, i);
-		cc_name.indiv.word0 = read_aux_reg(ARC_REG_CC_NAME0);
-		cc_name.indiv.word1 = read_aux_reg(ARC_REG_CC_NAME1);
+		cc_name.indiv.word0 = le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME0));
+		cc_name.indiv.word1 = le32_to_cpu(read_aux_reg(ARC_REG_CC_NAME1));
 
 		arc_pmu_map_hw_event(i, cc_name.str);
 		arc_pmu_add_raw_event_attr(i, cc_name.str);


