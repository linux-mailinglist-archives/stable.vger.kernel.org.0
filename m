Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DE4295692
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 05:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895275AbgJVDCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 23:02:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45033 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895274AbgJVDCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 23:02:48 -0400
Received: from 1.general.hwang4.uk.vpn ([10.172.195.16] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1kVQsF-0000Iu-MN; Thu, 22 Oct 2020 03:02:44 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de,
        dan.carpenter@oracle.com, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda - Fix the return value if cb func is already registered
Date:   Thu, 22 Oct 2020 11:02:21 +0800
Message-Id: <20201022030221.22393-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the cb function is already registered, should return the pointer
of the structure hda_jack_callback which contains this cb func, but
instead it returns the NULL.

Now fix it by replacing func_is_already_in_callback_list() with
find_callback_from_list().

Fixes: f4794c6064a8 ("ALSA:hda - Don't register a cb func if it is registered already")
Reported-and-suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/hda_jack.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_jack.c b/sound/pci/hda/hda_jack.c
index ded4813f8b54..588059428d8f 100644
--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -275,16 +275,21 @@ int snd_hda_jack_detect_state_mst(struct hda_codec *codec,
 }
 EXPORT_SYMBOL_GPL(snd_hda_jack_detect_state_mst);
 
-static bool func_is_already_in_callback_list(struct hda_jack_tbl *jack,
-					     hda_jack_callback_fn func)
+static struct hda_jack_callback *
+find_callback_from_list(struct hda_jack_tbl *jack,
+			hda_jack_callback_fn func)
 {
 	struct hda_jack_callback *cb;
 
+	if (!func)
+		return NULL;
+
 	for (cb = jack->callback; cb; cb = cb->next) {
 		if (cb->func == func)
-			return true;
+			return cb;
 	}
-	return false;
+
+	return NULL;
 }
 
 /**
@@ -309,7 +314,10 @@ snd_hda_jack_detect_enable_callback_mst(struct hda_codec *codec, hda_nid_t nid,
 	jack = snd_hda_jack_tbl_new(codec, nid, dev_id);
 	if (!jack)
 		return ERR_PTR(-ENOMEM);
-	if (func && !func_is_already_in_callback_list(jack, func)) {
+
+	callback = find_callback_from_list(jack, func);
+
+	if (func && !callback) {
 		callback = kzalloc(sizeof(*callback), GFP_KERNEL);
 		if (!callback)
 			return ERR_PTR(-ENOMEM);
-- 
2.25.1

