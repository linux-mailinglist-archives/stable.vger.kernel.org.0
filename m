Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8BF2B61DD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731251AbgKQNXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730581AbgKQNXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:23:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89AD924654;
        Tue, 17 Nov 2020 13:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619390;
        bh=CvTtNWL0qFH1kumqeJmUXO2YV8qk6Aua0TDjbXYav3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUB7ehK9rTdd2nDFPh3luO+dWvqes6+cRziEhiwBuv+T2mDyhjqR6j37Y+U4nltV5
         JHL9QKO7Fs5hO5T1vVNWABz9om/XN9DHGWxJBpg36Qn5F4ItJPdc0L3o5OWHUOvnCW
         QqJv8vQ+YWlUU5JsZge60MgQmkv/WpCQYCda+j7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/151] ALSA: hda: prevent undefined shift in snd_hdac_ext_bus_get_link()
Date:   Tue, 17 Nov 2020 14:04:13 +0100
Message-Id: <20201117122122.536631947@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 158e1886b6262c1d1c96a18c85fac5219b8bf804 ]

This is harmless, but the "addr" comes from the user and it could lead
to a negative shift or to shift wrapping if it's too high.

Fixes: 0b00a5615dc4 ("ALSA: hdac_ext: add hdac extended controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20201103101807.GC1127762@mwanda
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/ext/hdac_ext_controller.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/ext/hdac_ext_controller.c b/sound/hda/ext/hdac_ext_controller.c
index 09ff209df4a30..c87187f635733 100644
--- a/sound/hda/ext/hdac_ext_controller.c
+++ b/sound/hda/ext/hdac_ext_controller.c
@@ -148,6 +148,8 @@ struct hdac_ext_link *snd_hdac_ext_bus_get_link(struct hdac_bus *bus,
 		return NULL;
 	if (bus->idx != bus_idx)
 		return NULL;
+	if (addr < 0 || addr > 31)
+		return NULL;
 
 	list_for_each_entry(hlink, &bus->hlink_list, list) {
 		for (i = 0; i < HDA_MAX_CODECS; i++) {
-- 
2.27.0



