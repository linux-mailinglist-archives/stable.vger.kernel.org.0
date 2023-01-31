Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B8E683119
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjAaPPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjAaPPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:15:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878E458961;
        Tue, 31 Jan 2023 07:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 126ECB81D4D;
        Tue, 31 Jan 2023 15:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D36C433D2;
        Tue, 31 Jan 2023 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177268;
        bh=8d91AQT1e3CnN4jFQL+iFmU6yHLD1qbExdC4WZSdfkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OW+Cfm1nnyJ3r3topnoujRF2OtKlw5BPv2JTkAOu5Kz53rX3LGho5JuY8ZNXlvJvS
         Mn4vnIlXBvXIW1tHPhZDSMHxv3AFOKqyRNAfLMj97VVlb53975YIbyWsiRhQcATRW8
         IM/EUSLs7JEEQoEDswVzFzvHvVEjHbaBqSfry+wjaeG5EsTKskhRiQe3qwFKDTDH72
         kC59KTg3ezgjCxUYUWffoXBUfc1GJN2xFthlam2HdoWzEEM7yQ3RykyBEl0NqGl+F/
         /7sKMAZJnAyt44CVD8i/NYZV9zqQzm8OG9TXzh4U8s1TEDe3rq+X30uof6vqXDdDH3
         T+DCew/vKfAKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koba Ko <koba.ko@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 5/6] platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table
Date:   Tue, 31 Jan 2023 10:00:57 -0500
Message-Id: <20230131150100.1250267-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150100.1250267-1-sashal@kernel.org>
References: <20230131150100.1250267-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koba Ko <koba.ko@canonical.com>

[ Upstream commit 83bcf3e52e9cfc727df33f1055ef0618c91719d0 ]

Some platforms send the speaker-mute key from EC. dell-wmi can't
recognize it.

Add a new keymap for KEY_MUTE in type 0x0010 table.

Signed-off-by: Koba Ko <koba.ko@canonical.com>
Link: https://lore.kernel.org/r/20230117123436.200440-1-koba.ko@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index bbdb3e860892..6ef327a80ccf 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -259,6 +259,9 @@ static const struct key_entry dell_wmi_keymap_type_0010[] = {
 	{ KE_KEY,    0x57, { KEY_BRIGHTNESSDOWN } },
 	{ KE_KEY,    0x58, { KEY_BRIGHTNESSUP } },
 
+	/*Speaker Mute*/
+	{ KE_KEY, 0x109, { KEY_MUTE} },
+
 	/* Mic mute */
 	{ KE_KEY, 0x150, { KEY_MICMUTE } },
 
-- 
2.39.0

