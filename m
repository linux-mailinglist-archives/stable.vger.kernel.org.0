Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE2D499041
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352530AbiAXT7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41328 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240135AbiAXTxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:53:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0087FB81218;
        Mon, 24 Jan 2022 19:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D87C36AE3;
        Mon, 24 Jan 2022 19:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054022;
        bh=eoSpb2Jjaa/VzEtSTqkkOb08WYHFLtrDP1lBsjhRaGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urk3XKZOYcJ1EJZM6QHATZZkUyfzw2RiDdiF/lfQYqi2KylcyRRr64rKUek3VG3a1
         GrWCOoxcyMpk9bCypJkPZQFdgw9JXfIn62c1P+lHdmeM5ufnO/UzIG5YHPvUkU9fbR
         SPmahl3yYTqR2YbId9yYyxJigC7FCgVrYDITGxgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/563] staging: greybus: audio: Check null pointer
Date:   Mon, 24 Jan 2022 19:39:35 +0100
Message-Id: <20220124184031.699760005@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 2e81948177d769106754085c3e03534e6cc1f623 ]

As the possible alloc failure of devm_kcalloc(), it could return null
pointer.
Therefore, 'strings' should be checked and return NULL if alloc fails to
prevent the dereference of the NULL pointer.
Also, the caller should also deal with the return value of the
gb_generate_enum_strings() and return -ENOMEM if returns NULL.
Moreover, because the memory allocated with devm_kzalloc() will be
freed automatically when the last reference to the device is dropped,
the 'gbe' in gbaudio_tplg_create_enum_kctl() and
gbaudio_tplg_create_enum_ctl() do not need to free manually.
But the 'control' in gbaudio_tplg_create_widget() and
gbaudio_tplg_process_kcontrols() has a specially error handle to
cleanup.
So it should be better to cleanup 'control' when fails.

Fixes: e65579e335da ("greybus: audio: topology: Enable enumerated control support")
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220104150628.1987906-1-jiasheng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/audio_topology.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/staging/greybus/audio_topology.c b/drivers/staging/greybus/audio_topology.c
index 2bb8e7b60e8d5..e1579f356af5c 100644
--- a/drivers/staging/greybus/audio_topology.c
+++ b/drivers/staging/greybus/audio_topology.c
@@ -147,6 +147,9 @@ static const char **gb_generate_enum_strings(struct gbaudio_module_info *gb,
 
 	items = le32_to_cpu(gbenum->items);
 	strings = devm_kcalloc(gb->dev, items, sizeof(char *), GFP_KERNEL);
+	if (!strings)
+		return NULL;
+
 	data = gbenum->names;
 
 	for (i = 0; i < items; i++) {
@@ -655,6 +658,8 @@ static int gbaudio_tplg_create_enum_kctl(struct gbaudio_module_info *gb,
 	/* since count=1, and reg is dummy */
 	gbe->items = le32_to_cpu(gb_enum->items);
 	gbe->texts = gb_generate_enum_strings(gb, gb_enum);
+	if (!gbe->texts)
+		return -ENOMEM;
 
 	/* debug enum info */
 	dev_dbg(gb->dev, "Max:%d, name_length:%d\n", gbe->items,
@@ -862,6 +867,8 @@ static int gbaudio_tplg_create_enum_ctl(struct gbaudio_module_info *gb,
 	/* since count=1, and reg is dummy */
 	gbe->items = le32_to_cpu(gb_enum->items);
 	gbe->texts = gb_generate_enum_strings(gb, gb_enum);
+	if (!gbe->texts)
+		return -ENOMEM;
 
 	/* debug enum info */
 	dev_dbg(gb->dev, "Max:%d, name_length:%d\n", gbe->items,
@@ -1072,6 +1079,10 @@ static int gbaudio_tplg_create_widget(struct gbaudio_module_info *module,
 			csize += le16_to_cpu(gbenum->names_length);
 			control->texts = (const char * const *)
 				gb_generate_enum_strings(module, gbenum);
+			if (!control->texts) {
+				ret = -ENOMEM;
+				goto error;
+			}
 			control->items = le32_to_cpu(gbenum->items);
 		} else {
 			csize = sizeof(struct gb_audio_control);
@@ -1181,6 +1192,10 @@ static int gbaudio_tplg_process_kcontrols(struct gbaudio_module_info *module,
 			csize += le16_to_cpu(gbenum->names_length);
 			control->texts = (const char * const *)
 				gb_generate_enum_strings(module, gbenum);
+			if (!control->texts) {
+				ret = -ENOMEM;
+				goto error;
+			}
 			control->items = le32_to_cpu(gbenum->items);
 		} else {
 			csize = sizeof(struct gb_audio_control);
-- 
2.34.1



