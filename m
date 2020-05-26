Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E45A1B0A0C
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgDTMoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbgDTMoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:44:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 194A220747;
        Mon, 20 Apr 2020 12:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386652;
        bh=dLv/qwlL/DthhCXAYTiM1eKhBegrkHPVFlsN4z6yEAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTkncDu0zwLRDJkOd4C1io3/rHQ7OCI7OlH8mM+bDQF7xDtlFeXQQOK1UYeJ2paoc
         QCy8+o5TLfG/YX9wQLAq8LdFdGfWmk1o6S8L4NaHkK609T1cq0VbN44u44lZ8UZJNs
         sy89g8OVdgib6zWf3XXMmpLcwJsRK4xZGmsx26wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 42/71] ALSA: hda: Allow setting preallocation again for x86
Date:   Mon, 20 Apr 2020 14:38:56 +0200
Message-Id: <20200420121517.831060893@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit f8e4ae10de43fbb7ce85f79e04eca2988b6b2c40 upstream.

The commit c31427d0d21e ("ALSA: hda: No preallocation on x86
platforms") changed CONFIG_SND_HDA_PREALLOC_SIZE setup and its default
to zero for x86, as the preallocation should work almost all cases.
However, this expectation was too naive; some applications try to
allocate as the max buffer size as possible, and it leads to the
memory exhaustion.  More badly, the commit changed the kconfig no
longer adjustable for x86, so you can't fix it statically (although it
can be still adjusted via procfs).

So, practically seen, it's more recommended to set a reasonable limit
for x86, too.  This patch follows to that experience, and changes the
default to 2048 and allow the kconfig adjustable again.

Fixes: c31427d0d21e ("ALSA: hda: No preallocation on x86 platforms")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207223
Link: https://lore.kernel.org/r/20200413201919.24241-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/hda/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/hda/Kconfig
+++ b/sound/hda/Kconfig
@@ -21,16 +21,17 @@ config SND_HDA_EXT_CORE
        select SND_HDA_CORE
 
 config SND_HDA_PREALLOC_SIZE
-	int "Pre-allocated buffer size for HD-audio driver" if !SND_DMA_SGBUF
+	int "Pre-allocated buffer size for HD-audio driver"
 	range 0 32768
-	default 0 if SND_DMA_SGBUF
+	default 2048 if SND_DMA_SGBUF
 	default 64 if !SND_DMA_SGBUF
 	help
 	  Specifies the default pre-allocated buffer-size in kB for the
 	  HD-audio driver.  A larger buffer (e.g. 2048) is preferred
 	  for systems using PulseAudio.  The default 64 is chosen just
 	  for compatibility reasons.
-	  On x86 systems, the default is zero as we need no preallocation.
+	  On x86 systems, the default is 2048 as a reasonable value for
+	  most of modern systems.
 
 	  Note that the pre-allocation size can be changed dynamically
 	  via a proc file (/proc/asound/card*/pcm*/sub*/prealloc), too.


