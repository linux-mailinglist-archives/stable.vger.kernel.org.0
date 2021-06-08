Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0373A00A3
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhFHSp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235174AbhFHSnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CC126144C;
        Tue,  8 Jun 2021 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177380;
        bh=EFCwjrSDZsawmY/5UjW4h5yrRXmxiWZgaHmVzT/5upE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmypTIncnaDDICX0AjJ9G8KhYN+7abA1JNKkjnJ+G3W33IDPGn0U5cOuQUSGnHnDO
         8C6Tg4nS+AjfBqEvD0kzsTZ9X46MjL2irn2KqTefTfZsCEoQvLHaOAhYCtrmO2JtOl
         rnJY62y57Qq51Db/M8nqqFXAHdsUuThWQC6mpBco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/78] ALSA: usb: update old-style static const declaration
Date:   Tue,  8 Jun 2021 20:26:32 +0200
Message-Id: <20210608175935.384408437@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit ff40e0d41af19e36b43693fcb9241b4a6795bb44 ]

GCC reports the following warning with W=1

sound/usb/mixer_quirks.c: In function ‘snd_microii_controls_create’:
sound/usb/mixer_quirks.c:1694:2: warning: ‘static’ is not at beginning
of declaration [-Wold-style-declaration]
 1694 |  const static usb_mixer_elem_resume_func_t resume_funcs[] = {
      |  ^~~~~

Move static to the beginning of declaration

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200111214736.3002-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 5251818e10d3..d926869c031b 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1697,7 +1697,7 @@ static struct snd_kcontrol_new snd_microii_mixer_spdif[] = {
 static int snd_microii_controls_create(struct usb_mixer_interface *mixer)
 {
 	int err, i;
-	const static usb_mixer_elem_resume_func_t resume_funcs[] = {
+	static const usb_mixer_elem_resume_func_t resume_funcs[] = {
 		snd_microii_spdif_default_update,
 		NULL,
 		snd_microii_spdif_switch_update
-- 
2.30.2



