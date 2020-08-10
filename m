Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D410E240A0C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgHJPiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbgHJP0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:26:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6852322B47;
        Mon, 10 Aug 2020 15:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073169;
        bh=wbJkXYzP4NTlhdtfFxMAEuOaGDEharlTk8bywJATAuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMbW2gR1w/NA6A2sLO1hT38CCe81uFnXRBu0WGk++/E8yNaBYa6Pop6+NoI5JTCkK
         GDy6Hps6egNWzUGT57ncI9y1xOxLCCBBXRlLG2s3xaUXspedQ3rDKQmPqPCYumaHS2
         gISex2QoxMH0Smuuk6P5Tmrn/Itm3ho/my0SeQe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Connor McAdams <conmanx360@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 11/67] ALSA: hda/ca0132 - Fix ZxR Headphone gain control get value.
Date:   Mon, 10 Aug 2020 17:20:58 +0200
Message-Id: <20200810151809.984317011@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor McAdams <conmanx360@gmail.com>

commit a00dc409de455b64e6cb2f6d40cdb8237cdb2e83 upstream.

When the ZxR headphone gain control was added, the ca0132_switch_get
function was not updated, which meant that the changes to the control
state were not saved when entering/exiting alsamixer.

Signed-off-by: Connor McAdams <conmanx360@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200803002928.8638-1-conmanx360@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -5748,6 +5748,11 @@ static int ca0132_switch_get(struct snd_
 		return 0;
 	}
 
+	if (nid == ZXR_HEADPHONE_GAIN) {
+		*valp = spec->zxr_gain_set;
+		return 0;
+	}
+
 	return 0;
 }
 


