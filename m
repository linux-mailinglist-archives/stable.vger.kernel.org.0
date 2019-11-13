Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C1EFA2D8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbfKMCGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:06:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbfKMCBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:01:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628D92245A;
        Wed, 13 Nov 2019 02:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610476;
        bh=uXJnpNa2DlT2etLUcYrrcS9giJvdo6ordh6k9tSg9PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNMwlBuHRQZITS7IkKk7EJjqzbWeDvss8mR7eX7kaE4lh8Ppf4gQewGDZEAksivx0
         ERoY+nghVnDIjMcr+sKUcj78ETIa0DZtyxM08k66mbIXlYbxznZOLn3Ez+6qMIDZ9g
         Mmzr9iQ4p4HP0iaDF0R7apQ7ngvgmtLUsAl2Y854=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Lianbo Jiang <lijiang@redhat.com>,
        Takashi Iwai <tiwai@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        baiyaowei@cmss.chinamobile.com, bhe@redhat.com,
        dan.j.williams@intel.com, dyoung@redhat.com,
        kexec@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 58/68] x86/kexec: Correct KEXEC_BACKUP_SRC_END off-by-one error
Date:   Tue, 12 Nov 2019 20:59:22 -0500
Message-Id: <20191113015932.12655-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 51fbf14f2528a8c6401290e37f1c893a2412f1d3 ]

The only use of KEXEC_BACKUP_SRC_END is as an argument to
walk_system_ram_res():

  int crash_load_segments(struct kimage *image)
  {
    ...
    walk_system_ram_res(KEXEC_BACKUP_SRC_START, KEXEC_BACKUP_SRC_END,
                        image, determine_backup_region);

walk_system_ram_res() expects "start, end" arguments that are inclusive,
i.e., the range to be walked includes both the start and end addresses.

KEXEC_BACKUP_SRC_END was previously defined as (640 * 1024UL), which is the
first address *past* the desired 0-640KB range.

Define KEXEC_BACKUP_SRC_END as (640 * 1024UL - 1) so the KEXEC_BACKUP_SRC
region is [0-0x9ffff], not [0-0xa0000].

Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Brijesh Singh <brijesh.singh@amd.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Lianbo Jiang <lijiang@redhat.com>
CC: Takashi Iwai <tiwai@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: baiyaowei@cmss.chinamobile.com
CC: bhe@redhat.com
CC: dan.j.williams@intel.com
CC: dyoung@redhat.com
CC: kexec@lists.infradead.org
Link: http://lkml.kernel.org/r/153805811578.1157.6948388946904655969.stgit@bhelgaas-glaptop.roam.corp.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kexec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 282630e4c6ea4..1624a7ffa95d8 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -66,7 +66,7 @@ struct kimage;
 
 /* Memory to backup during crash kdump */
 #define KEXEC_BACKUP_SRC_START	(0UL)
-#define KEXEC_BACKUP_SRC_END	(640 * 1024UL)	/* 640K */
+#define KEXEC_BACKUP_SRC_END	(640 * 1024UL - 1)	/* 640K */
 
 /*
  * CPU does not save ss and sp on stack if execution is already
-- 
2.20.1

