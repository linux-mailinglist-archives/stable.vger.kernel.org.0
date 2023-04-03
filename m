Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4696D490B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjDCOek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjDCOej (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:34:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE8216F32
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89A0561DE3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD7DC433D2;
        Mon,  3 Apr 2023 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532440;
        bh=yl2rk6VyLYTv1k3iTf9DXMBvKRXy+Vadx1an0oQ3kwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDsS3Hpt4KEp8Lc6QCcVfcY7aLHWohduXd0mz0FouV62KvHw/BD27K688sx7g28dV
         KG1qy53au4ZzBQ/W0aL2MIA3sSldK07F1IzM23uGtPWUEQ+MP0lylASXlmjV6623/b
         7rm3lyJ4mXNU65sYufN0frt2hcxxuR5x6XqMzbF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tasos Sahanidis <tasos@tasossah.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 54/99] ALSA: ymfpci: Create card with device-managed snd_devm_card_new()
Date:   Mon,  3 Apr 2023 16:09:17 +0200
Message-Id: <20230403140405.390334438@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit f33fc1576757741479452255132d6e3aaf558ffe ]

snd_card_ymfpci_remove() was removed in commit c6e6bb5eab74 ("ALSA:
ymfpci: Allocate resources with device-managed APIs"), but the call to
snd_card_new() was not replaced with snd_devm_card_new().

Since there was no longer a call to snd_card_free, unloading the module
would eventually result in Oops:

[697561.532887] BUG: unable to handle page fault for address: ffffffffc0924480
[697561.532893] #PF: supervisor read access in kernel mode
[697561.532896] #PF: error_code(0x0000) - not-present page
[697561.532899] PGD ae1e15067 P4D ae1e15067 PUD ae1e17067 PMD 11a8f5067 PTE 0
[697561.532905] Oops: 0000 [#1] PREEMPT SMP NOPTI
[697561.532909] CPU: 21 PID: 5080 Comm: wireplumber Tainted: G        W  OE      6.2.7 #1
[697561.532914] Hardware name: System manufacturer System Product Name/TUF GAMING X570-PLUS, BIOS 4408 10/28/2022
[697561.532916] RIP: 0010:try_module_get.part.0+0x1a/0xe0
[697561.532924] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 49 89 fc bf 01 00 00 00 e8 56 3c f8 ff <41> 83 3c 24 02 0f 84 96 00 00 00 41 8b 84 24 30 03 00 00 85 c0 0f
[697561.532927] RSP: 0018:ffffbe9b858c3bd8 EFLAGS: 00010246
[697561.532930] RAX: ffff9815d14f1900 RBX: ffff9815c14e6000 RCX: 0000000000000000
[697561.532933] RDX: 0000000000000000 RSI: ffffffffc055092c RDI: ffffffffb3778c1a
[697561.532935] RBP: ffffbe9b858c3be8 R08: 0000000000000040 R09: ffff981a1a741380
[697561.532937] R10: ffffbe9b858c3c80 R11: 00000009d56533a6 R12: ffffffffc0924480
[697561.532939] R13: ffff9823439d8500 R14: 0000000000000025 R15: ffff9815cd109f80
[697561.532942] FS:  00007f13084f1f80(0000) GS:ffff9824aef40000(0000) knlGS:0000000000000000
[697561.532945] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[697561.532947] CR2: ffffffffc0924480 CR3: 0000000145344000 CR4: 0000000000350ee0
[697561.532949] Call Trace:
[697561.532951]  <TASK>
[697561.532955]  try_module_get+0x13/0x30
[697561.532960]  snd_ctl_open+0x61/0x1c0 [snd]
[697561.532976]  snd_open+0xb4/0x1e0 [snd]
[697561.532989]  chrdev_open+0xc7/0x240
[697561.532995]  ? fsnotify_perm.part.0+0x6e/0x160
[697561.533000]  ? __pfx_chrdev_open+0x10/0x10
[697561.533005]  do_dentry_open+0x169/0x440
[697561.533009]  vfs_open+0x2d/0x40
[697561.533012]  path_openat+0xa9d/0x10d0
[697561.533017]  ? debug_smp_processor_id+0x17/0x20
[697561.533022]  ? trigger_load_balance+0x65/0x370
[697561.533026]  do_filp_open+0xb2/0x160
[697561.533032]  ? _raw_spin_unlock+0x19/0x40
[697561.533036]  ? alloc_fd+0xa9/0x190
[697561.533040]  do_sys_openat2+0x9f/0x160
[697561.533044]  __x64_sys_openat+0x55/0x90
[697561.533048]  do_syscall_64+0x3b/0x90
[697561.533052]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[697561.533056] RIP: 0033:0x7f1308a40db4
[697561.533059] Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 46 68 f8 ff 44 8b 54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 32 44 89 c7 89 44 24 0c e8 78 68 f8 ff 8b 44
[697561.533062] RSP: 002b:00007ffcce664450 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
[697561.533066] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f1308a40db4
[697561.533068] RDX: 0000000000080000 RSI: 00007ffcce664690 RDI: 00000000ffffff9c
[697561.533070] RBP: 00007ffcce664690 R08: 0000000000000000 R09: 0000000000000012
[697561.533072] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000080000
[697561.533074] R13: 00007f13054b069b R14: 0000565209f83200 R15: 0000000000000000
[697561.533078]  </TASK>

Fixes: c6e6bb5eab74 ("ALSA: ymfpci: Allocate resources with device-managed APIs")
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/20230329032422.170024-1-tasos@tasossah.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ymfpci/ymfpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 1e198e4d57b8d..82d4e0fda91be 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -170,7 +170,7 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		return -ENOENT;
 	}
 
-	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
+	err = snd_devm_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   sizeof(*chip), &card);
 	if (err < 0)
 		return err;
-- 
2.39.2



