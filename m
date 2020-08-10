Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30611240854
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgHJPUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbgHJPUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 349AB22B4B;
        Mon, 10 Aug 2020 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072805;
        bh=y27Zhu8F9W1JK886ANmln+6mHUPnci9sProeWuTqNfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thaHSn7pEH+CF/jfuiGeZP44L0KIBV4GVZQws96g5XEp0fi0mAYnB/ezKBf06/IvD
         BjA04RHpkjDOC/ts8C1a6YWa+QT/q8lqYmDgZlT3IKyaOAhV/d1GRYDWvJ9xWMeYgC
         0rSZygu8fA047QnPEkXkXCrC7Y/4VPpF5KvWALnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Connor McAdams <conmanx360@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 09/38] ALSA: hda/ca0132 - Fix ZxR Headphone gain control get value.
Date:   Mon, 10 Aug 2020 17:18:59 +0200
Message-Id: <20200810151804.360159192@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
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
@@ -5749,6 +5749,11 @@ static int ca0132_switch_get(struct snd_
 		return 0;
 	}
 
+	if (nid == ZXR_HEADPHONE_GAIN) {
+		*valp = spec->zxr_gain_set;
+		return 0;
+	}
+
 	return 0;
 }
 


