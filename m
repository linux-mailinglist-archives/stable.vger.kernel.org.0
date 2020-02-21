Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A061675F2
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbgBUIM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732576AbgBUIM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:12:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDA0A24673;
        Fri, 21 Feb 2020 08:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272776;
        bh=+wNQcH+TJ4zlI48ZRTuJb8YhmGGiHfyRhbMPl65NfmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+ol6EAYpLN6amV0CTO5RNxmHrdJ3zIe8XYuE4i+SMILgzUGtK1nxlf2+CiRST/oi
         QUw5XKQs+zRywACcjfp0Csmx2niQCaEQUWsOEVLQyoHU+avuwPB17gdyMkUEoU0uqC
         2pasi0uLY4+OuxBbFEuZgaBdVG8ic4nOAqh4WrNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 271/344] ALSA: hda/hdmi - add retry logic to parse_intel_hdmi()
Date:   Fri, 21 Feb 2020 08:41:10 +0100
Message-Id: <20200221072414.317823120@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 2928fa0a97ebb9549cb877fdc99aed9b95438c3a ]

The initial snd_hda_get_sub_node() can fail on certain
devices (e.g. some Chromebook models using Intel GLK).
The failure rate is very low, but as this is is part of
the probe process, end-user impact is high.

In observed cases, related hardware status registers have
expected values, but the node query still fails. Retrying
the node query does seem to help, so fix the problem by
adding retry logic to the query. This does not impact
non-Intel platforms.

BugLink: https://github.com/thesofproject/linux/issues/1642
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20200120160117.29130-4-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 8ac805a634f4e..307ca1f036762 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2794,9 +2794,12 @@ static int alloc_intel_hdmi(struct hda_codec *codec)
 /* parse and post-process for Intel codecs */
 static int parse_intel_hdmi(struct hda_codec *codec)
 {
-	int err;
+	int err, retries = 3;
+
+	do {
+		err = hdmi_parse_codec(codec);
+	} while (err < 0 && retries--);
 
-	err = hdmi_parse_codec(codec);
 	if (err < 0) {
 		generic_spec_free(codec);
 		return err;
-- 
2.20.1



