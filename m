Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6C3469C98
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359724AbhLFPXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40196 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355895AbhLFPVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:21:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C863B61355;
        Mon,  6 Dec 2021 15:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7ACC341C6;
        Mon,  6 Dec 2021 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803897;
        bh=b8H0qKpZWgWGHTCZ2E0e8UnNE7LyynZ9SHcWGNMpBy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxuJLa8iDwScZ41YQ9/sqbN6MkugdBoooyz6KiT0MRcVeEscEIr8I1V6SFrg3stGN
         7I8ZHO3Hs+EbXfqOl5bOvd2b9W9Jnny7/aRsvecQ8gOKlGNJ51K9BSyQk61oSejYYW
         ep1QksrZPkw7kpJkLUFDa1sY1P0izAuPM7Ttuu6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 085/130] ALSA: intel-dsp-config: add quirk for CML devices based on ES8336 codec
Date:   Mon,  6 Dec 2021 15:56:42 +0100
Message-Id: <20211206145602.604809278@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit ae26c08e6c8071ba8febb0c7c0829da96c75248c upstream.

We've added quirks for ESS8336 but missed CML, add quirks for both LP
and H versions.

BugLink: https://github.com/thesofproject/linux/issues/3248
Fixes: 9d36ceab9415 ("ALSA: intel-dsp-config: add quirk for APL/GLK/TGL devices based on ES8336 codec")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20211122232254.23362-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/intel-dsp-config.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -251,6 +251,11 @@ static const struct config_entry config_
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x02c8,
 	},
+	{
+		.flags = FLAG_SOF,
+		.device = 0x02c8,
+		.codec_hid = "ESSX8336",
+	},
 /* Cometlake-H */
 	{
 		.flags = FLAG_SOF,
@@ -275,6 +280,11 @@ static const struct config_entry config_
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x06c8,
 	},
+		{
+		.flags = FLAG_SOF,
+		.device = 0x06c8,
+		.codec_hid = "ESSX8336",
+	},
 #endif
 
 /* Icelake */


