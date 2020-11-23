Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF4F2C0863
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbgKWMuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:50:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733010AbgKWMtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DC6020888;
        Mon, 23 Nov 2020 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135775;
        bh=3qWOBcilWx7oefDmsBuGTnYGJGvZcPFjIR8W0cCl+U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGvFKMaC2YaJOO9XQofmS2F1gAxxOyflFulpu4oCea8r6qUZAdqgTkjP7rlAY2s/m
         Z31xFKFeMx67f3Fc3I45eidamBKZecJSAbKM95RCvbEEomtRNtKVdPzzxELZKtyJ8s
         1HAZS9N+j7B2ygGC/WWIhCekfNPZaZMMRa+wwcyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 192/252] ALSA: ctl: fix error path at adding user-defined element set
Date:   Mon, 23 Nov 2020 13:22:22 +0100
Message-Id: <20201123121844.863697633@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 95a793c3bc75cf888e0e641d656e7d080f487d8b upstream.

When processing request to add/replace user-defined element set, check
of given element identifier and decision of numeric identifier is done
in "__snd_ctl_add_replace()" helper function. When the result of check
is wrong, the helper function returns error code. The error code shall
be returned to userspace application.

Current implementation includes bug to return zero to userspace application
regardless of the result. This commit fixes the bug.

Cc: <stable@vger.kernel.org>
Fixes: e1a7bfe38079 ("ALSA: control: Fix race between adding and removing a user element")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20201113092043.16148-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/control.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1527,7 +1527,7 @@ static int snd_ctl_elem_add(struct snd_c
 
  unlock:
 	up_write(&card->controls_rwsem);
-	return 0;
+	return err;
 }
 
 static int snd_ctl_elem_add_user(struct snd_ctl_file *file,


