Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5909E171BD8
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387907AbgB0OGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733131AbgB0OGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:06:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E700C246A0;
        Thu, 27 Feb 2020 14:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812375;
        bh=KQwUHAoHkKcrkxEfYWpKsiCRMt+TCx0PRmOlYP6sgUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUxJ7uge3QCNuVJ2L8CNk8idmmv7Nmn56lL0Z5MhF+h4Vs34GXGXewFKhAkOtEQGo
         YNwCjLHTNLvhZeN93DaiL0bg95kVTBdEwPKt77ut+3Uh6vgDa+xyTbIKrn2dUryiKC
         jeEbH24TLC2Xg138hXnHUyu+8/ECYji6rcOHuQYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+576cc007eb9f2c968200@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 90/97] ALSA: rawmidi: Avoid bit fields for state flags
Date:   Thu, 27 Feb 2020 14:37:38 +0100
Message-Id: <20200227132229.305414528@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit dfa9a5efe8b932a84b3b319250aa3ac60c20f876 upstream.

The rawmidi state flags (opened, append, active_sensing) are stored in
bit fields that can be potentially racy when concurrently accessed
without any locks.  Although the current code should be fine, there is
also no any real benefit by keeping the bitfields for this kind of
short number of members.

This patch changes those bit fields flags to the simple bool fields.
There should be no size increase of the snd_rawmidi_substream by this
change.

Reported-by: syzbot+576cc007eb9f2c968200@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20200214111316.26939-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/rawmidi.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -92,9 +92,9 @@ struct snd_rawmidi_substream {
 	struct list_head list;		/* list of all substream for given stream */
 	int stream;			/* direction */
 	int number;			/* substream number */
-	unsigned int opened: 1,		/* open flag */
-		     append: 1,		/* append flag (merge more streams) */
-		     active_sensing: 1; /* send active sensing when close */
+	bool opened;			/* open flag */
+	bool append;			/* append flag (merge more streams) */
+	bool active_sensing;		/* send active sensing when close */
 	int use_count;			/* use counter (for output) */
 	size_t bytes;
 	struct snd_rawmidi *rmidi;


