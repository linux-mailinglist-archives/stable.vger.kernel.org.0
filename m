Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765CAB1E8D
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388887AbfIMNLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388155AbfIMNLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:05 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6BF208C0;
        Fri, 13 Sep 2019 13:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380264;
        bh=P7jsQZzraoazkhJaduXNW6gku7OXXwlFf3f1jFYb+9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ec0spOsnFul2XeL6gJq90BdIUPidOEtWmHX+5M4dgy8STaEG3IFvU17rIJKttaIuC
         /oKN3Zf1ewSfzcCGjyx+AqZ1meu7G1MiSv24nsL2WT8p62A6zhgOuZ1/+L7cAJ8JJe
         OMWmMBMHyYMeNGvMjQWJEs0y0ww8kgvg41jk2yPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 001/190] ALSA: hda - Fix potential endless loop at applying quirks
Date:   Fri, 13 Sep 2019 14:04:16 +0100
Message-Id: <20190913130559.784678558@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 333f31436d3db19f4286f8862a00ea1d8d8420a1 upstream.

Since the chained quirks via chained_before flag is applied before the
depth check, it may lead to the endless recursive calls, when the
chain were set up incorrectly.  Fix it by moving the depth check at
the beginning of the loop.

Fixes: 1f57825077dc ("ALSA: hda - Add chained_before flag to the fixup entry")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_auto_parser.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -828,6 +828,8 @@ static void apply_fixup(struct hda_codec
 	while (id >= 0) {
 		const struct hda_fixup *fix = codec->fixup_list + id;
 
+		if (++depth > 10)
+			break;
 		if (fix->chained_before)
 			apply_fixup(codec, fix->chain_id, action, depth + 1);
 
@@ -867,8 +869,6 @@ static void apply_fixup(struct hda_codec
 		}
 		if (!fix->chained || fix->chained_before)
 			break;
-		if (++depth > 10)
-			break;
 		id = fix->chain_id;
 	}
 }


