Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5335012ED59
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgABW11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729737AbgABW10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:27:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FCF42253D;
        Thu,  2 Jan 2020 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004045;
        bh=iPj0zluIWzyqWRoO57oi2l4TB1Hqdaa8CAffhmRVyYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csbm6LuH9Zh8UIeN2Rv8suH0bQ4UHJU/Yksj1lsxiEMCVC+gPSWAUT9sBmmxIf+59
         eS3cjnP9F0gc8040+kK3xJoIa1KsMMWTs8/SLqx2yQY2dAlGnQmE6pt2U1Bdm8M++q
         dNgWbV4/xbHwqqOWVBN58I2OE2e8a+ULERu7CTi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 006/171] ALSA: hda/ca0132 - Avoid endless loop
Date:   Thu,  2 Jan 2020 23:05:37 +0100
Message-Id: <20200102220547.819086859@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit cb04fc3b6b076f67d228a0b7d096c69ad486c09c upstream.

Introduce a timeout to dspio_clear_response_queue() so that it won't
be caught in an endless loop even if the hardware doesn't respond
properly.

Fixes: a73d511c4867 ("ALSA: hda/ca0132: Add unsol handler for DSP and jack detection")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213085111.22855-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1300,13 +1300,14 @@ struct scp_msg {
 
 static void dspio_clear_response_queue(struct hda_codec *codec)
 {
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	unsigned int dummy = 0;
-	int status = -1;
+	int status;
 
 	/* clear all from the response queue */
 	do {
 		status = dspio_read(codec, &dummy);
-	} while (status == 0);
+	} while (status == 0 && time_before(jiffies, timeout));
 }
 
 static int dspio_get_response_data(struct hda_codec *codec)


