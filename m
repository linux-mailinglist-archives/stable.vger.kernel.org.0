Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BC9796BB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390696AbfG2Tyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404132AbfG2Tyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B1CF204EC;
        Mon, 29 Jul 2019 19:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430092;
        bh=JSym5BCHXIZhjJG90piwBXOB0c8hcCgBoTk+AG7pemM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlahhL24bwsv1b6MT7Jg7JnTt3PvVvLBKOyHPuKt4u2a4LNK8ARRRzLCihYsEwBVy
         MD4n4hstBX0ZM8XY0PLQ9xAqAaO3Xfv52842IvwM5qgt51I3Xh/j+VTJ8mU10zkiLB
         /yVS29dAzWLNxRuZ2nJip7V9JbV0toUaqshdwoh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Duncan Overbruck <kernel@duncano.de>
Subject: [PATCH 5.2 193/215] ALSA: pcm: Fix refcount_inc() on zero usage
Date:   Mon, 29 Jul 2019 21:23:09 +0200
Message-Id: <20190729190813.335586133@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0e279dcea0ec897af1c979ebee4ec92b461793f5 upstream.

The recent rewrite of PCM link lock management introduced the refcount
in snd_pcm_group object, managed by the kernel refcount_t API.  This
caused unexpected kernel warnings when the kernel is built with
CONFIG_REFCOUNT_FULL=y.  As the warning line indicates, the problem is
obviously that we start with refcount=0 and do refcount_inc() for
adding each PCM link, while refcount_t API doesn't like refcount_inc()
performed on zero.

For adapting the proper refcount_t usage, this patch changes the logic
slightly:
- The initial refcount is 1, assuming the single list entry
- The refcount is incremented / decremented at each PCM link addition
  and deletion
- ... which allows us concentrating only on the refcount as a release
  condition

Fixes: f57f3df03a8e ("ALSA: pcm: More fine-grained PCM link locking")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204221
Reported-and-tested-by: Duncan Overbruck <kernel@duncano.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_native.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -77,7 +77,7 @@ void snd_pcm_group_init(struct snd_pcm_g
 	spin_lock_init(&group->lock);
 	mutex_init(&group->mutex);
 	INIT_LIST_HEAD(&group->substreams);
-	refcount_set(&group->refs, 0);
+	refcount_set(&group->refs, 1);
 }
 
 /* define group lock helpers */
@@ -1096,8 +1096,7 @@ static void snd_pcm_group_unref(struct s
 
 	if (!group)
 		return;
-	do_free = refcount_dec_and_test(&group->refs) &&
-		list_empty(&group->substreams);
+	do_free = refcount_dec_and_test(&group->refs);
 	snd_pcm_group_unlock(group, substream->pcm->nonatomic);
 	if (do_free)
 		kfree(group);
@@ -2020,6 +2019,7 @@ static int snd_pcm_link(struct snd_pcm_s
 	snd_pcm_group_lock_irq(target_group, nonatomic);
 	snd_pcm_stream_lock(substream1);
 	snd_pcm_group_assign(substream1, target_group);
+	refcount_inc(&target_group->refs);
 	snd_pcm_stream_unlock(substream1);
 	snd_pcm_group_unlock_irq(target_group, nonatomic);
  _end:
@@ -2056,13 +2056,14 @@ static int snd_pcm_unlink(struct snd_pcm
 	snd_pcm_group_lock_irq(group, nonatomic);
 
 	relink_to_local(substream);
+	refcount_dec(&group->refs);
 
 	/* detach the last stream, too */
 	if (list_is_singular(&group->substreams)) {
 		relink_to_local(list_first_entry(&group->substreams,
 						 struct snd_pcm_substream,
 						 link_list));
-		do_free = !refcount_read(&group->refs);
+		do_free = refcount_dec_and_test(&group->refs);
 	}
 
 	snd_pcm_group_unlock_irq(group, nonatomic);


