Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70137366C26
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbhDUNLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241089AbhDUNKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:10:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23CAC61460;
        Wed, 21 Apr 2021 13:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010602;
        bh=0ZMoyGTMN6cdLV84CGS0daXlsSiChDvc+7QBwEONvJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMazOH0T1RUH78/eA5e0WJusx1mjgCjzU0D8p5NrV0OQHoyGG5ushzNzwm6NJRJhI
         ziAJ9DuYAR464v/c4d6pP/xdD6LfYnWyfERW3fYrYPIBDI5GcYmqPfIjsWIhylzwmZ
         0LTk5CTlyU5gBe0n3kk6uzvt9vaNEYi53ZSUp5Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wenwen Wang <wang6495@umn.edu>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 187/190] Revert "ALSA: control: fix a redundant-copy issue"
Date:   Wed, 21 Apr 2021 15:01:02 +0200
Message-Id: <20210421130105.1226686-188-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 3f12888dfae2a48741c4caa9214885b3aaf350f9.

Commits from @umn.edu addresses have been found to be submitted in "bad
faith" to try to test the kernel community's ability to review "known
malicious" changes.  The result of these submissions can be found in a
paper published at the 42nd IEEE Symposium on Security and Privacy
entitled, "Open Source Insecurity: Stealthily Introducing
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
of Minnesota) and Kangjie Lu (University of Minnesota).

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: Wenwen Wang <wang6495@umn.edu>
Cc: <stable@vger.kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control_compat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index 1d708aab9c98..857acf83ae47 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -381,7 +381,8 @@ static int snd_ctl_elem_add_compat(struct snd_ctl_file *file,
 	if (copy_from_user(&data->id, &data32->id, sizeof(data->id)) ||
 	    copy_from_user(&data->type, &data32->type, 3 * sizeof(u32)))
 		goto error;
-	if (get_user(data->owner, &data32->owner))
+	if (get_user(data->owner, &data32->owner) ||
+	    get_user(data->type, &data32->type))
 		goto error;
 	switch (data->type) {
 	case SNDRV_CTL_ELEM_TYPE_BOOLEAN:
-- 
2.31.1

