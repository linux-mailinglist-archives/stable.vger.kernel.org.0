Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C5429B383
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775576AbgJ0Oww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771544AbgJ0Ot7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1984520709;
        Tue, 27 Oct 2020 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810198;
        bh=4fN70qPh73IdxfvPoMCro+1wxHu/zqje1ATOEuUx6hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/BA6wgFqcc6cK2qEYt0dJ+GpzI5QWHhNNy4xczwAhTQmM04KqvdCt0s9C+WCkPsE
         7lqR/1FV6ZfSvqfe8hFNOdQsCrYNR4YArWKMxY5wkDs0Pwymr2ugM1AplIswjxCGLK
         u01gA77ZGeUBNJqJEC5oNqxBLMlezuY3xOSFFAuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.8 056/633] ALSA: hda - Fix the return value if cb func is already registered
Date:   Tue, 27 Oct 2020 14:46:39 +0100
Message-Id: <20201027135525.327141928@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 033e4040d453f1f7111e5957a54f3019eb089cc6 upstream.

If the cb function is already registered, should return the pointer
of the structure hda_jack_callback which contains this cb func, but
instead it returns the NULL.

Now fix it by replacing func_is_already_in_callback_list() with
find_callback_from_list().

Fixes: f4794c6064a8 ("ALSA: hda - Don't register a cb func if it is registered already")
Reported-and-suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20201022030221.22393-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_jack.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -275,16 +275,21 @@ int snd_hda_jack_detect_state_mst(struct
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
@@ -309,7 +314,10 @@ snd_hda_jack_detect_enable_callback_mst(
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


