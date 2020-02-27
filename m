Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECCF17196B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgB0Non (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730249AbgB0Nol (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:44:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED7220578;
        Thu, 27 Feb 2020 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811081;
        bh=KQwUHAoHkKcrkxEfYWpKsiCRMt+TCx0PRmOlYP6sgUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuM6bx50NhEENTAlYAXMoO233ukSqASS9mkth0hS0SeueTi6Yvhgd9OBgup4W7ZUM
         507uW4MK+8joZBMufW8h4Qck4w3x5f/vE/Fvoqh8dDQzYacH3sQNwmf2yq8O2uKxNI
         rbaoXKGpi+s3XXkDQf8VvrpgkRszo+KdNhFKC3k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+576cc007eb9f2c968200@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 110/113] ALSA: rawmidi: Avoid bit fields for state flags
Date:   Thu, 27 Feb 2020 14:37:06 +0100
Message-Id: <20200227132229.406937993@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
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


