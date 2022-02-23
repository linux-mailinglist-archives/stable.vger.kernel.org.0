Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3394C0861
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbiBWCcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbiBWCbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:31:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3147077;
        Tue, 22 Feb 2022 18:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB9DA6153B;
        Wed, 23 Feb 2022 02:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B510C340F4;
        Wed, 23 Feb 2022 02:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583399;
        bh=ZwPN0fPeRrpxsQO+JtmVkDSRuX+HuRtlC+wdai31fio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4PPHG5XagcZJUJMZtZnLeMEnb0/2WUTE+UIC0pohWPpM4qkCnuT5eyVJT7Shqyu9
         FF6WgPNzVGNx5aTkIpe4WhpuEGTN40iuglmvhM8Fxe/qJGySV9kYQfilmJiCLZGi6/
         5LxRQco0C9hS/0VraLJQfh1bNunxSPjjPM7Ft/5msjHI+34vxxk/kbDpdYzwxQr4DY
         MPuqDugXJaIzD9rVpmeGBD3sj4BUXrgrSebeRp63Fc63fEwyhv4+A+SoTckI0sk5uK
         DVkEL84G1GDqlVpi4b7bLKHiUjOJ2tFJerQZhRTqZ246tbj/tpLeUudneC8lzeLq79
         OUE4yCmeYxurA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        nehal-bakulchandra.shah@amd.com, basavaraj.natikar@amd.com,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/28] HID: amd_sfh: Handle amd_sfh work buffer in PM ops
Date:   Tue, 22 Feb 2022 21:29:16 -0500
Message-Id: <20220223022929.241127-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 0cf74235f4403b760a37f77271d2ca3424001ff9 ]

Since in the current amd_sfh design the sensor data is periodically
obtained in the form of poll data, during the suspend/resume cycle,
scheduling a delayed work adds no value.

So, cancel the work and restart back during the suspend/resume cycle
respectively.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 05c007b213f24..6eda5006fb116 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -287,6 +287,8 @@ static int __maybe_unused amd_mp2_pci_resume(struct device *dev)
 		}
 	}
 
+	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
+
 	return 0;
 }
 
@@ -310,6 +312,8 @@ static int __maybe_unused amd_mp2_pci_suspend(struct device *dev)
 		}
 	}
 
+	cancel_delayed_work_sync(&cl_data->work_buffer);
+
 	return 0;
 }
 
-- 
2.34.1

