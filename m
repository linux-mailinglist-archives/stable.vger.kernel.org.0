Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7210E1B0AB5
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgDTMuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgDTMtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:49:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D5ED20735;
        Mon, 20 Apr 2020 12:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386979;
        bh=qLCmoWsysNXQVBAbiONmF42vjRw01PA0Q6hcW6qAx1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k69zt625LLWbE7uVP+EvcBsbyRy0/BjVeE2Yy7jZ3lCxIPkwjHJLeqaeMi2D8LdLH
         le/zChms9Akz9KR6CkhG14x5cpqoOIIh4QfR7ULPYAnL30LnSZZOPRSGZLJLU5IuJG
         9NHN7CqLU3esN0nfUISn6hG5fqi7xw5yqZF2zBlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 17/40] ALSA: usb-audio: Filter error from connector kctl ops, too
Date:   Mon, 20 Apr 2020 14:39:27 +0200
Message-Id: <20200420121459.353299438@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 48cc42973509afac24e83d6edc23901d102872d1 upstream.

The ignore_ctl_error option should filter the error at kctl accesses,
but there was an overlook: mixer_ctl_connector_get() returns an error
from the request.

This patch covers the forgotten code path and apply filter_error()
properly.  The locking error is still returned since this is a fatal
error that has to be reported even with ignore_ctl_error option.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206873
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200412081331.4742-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1461,7 +1461,7 @@ error:
 		usb_audio_err(chip,
 			"cannot get connectors status: req = %#x, wValue = %#x, wIndex = %#x, type = %d\n",
 			UAC_GET_CUR, validx, idx, cval->val_type);
-		return ret;
+		return filter_error(cval, ret);
 	}
 
 	ucontrol->value.integer.value[0] = val;


