Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848F6140012
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390661AbgAPXUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389868AbgAPXUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8E220684;
        Thu, 16 Jan 2020 23:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216831;
        bh=z3iQ8r4YGWtapD/UG4MIECHZu1yq6TYsrjCMYFKWfJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=extVgn8i0BKxXLjntPNgaEUW1TVzGKYc9d55+hSdnqvUu+kadcjl21tv1mJc4gu8i
         jmf9N+38HVZIkXnNvVa/MFkSENE1TelSknPzmAe9bKXRulVa/XA/nQKkaUJKJgKsCF
         ZGW9zARMZniE4OOoN0o7MkFJq46ffUKT9jw2XW2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 010/203] ASoC: soc-core: Set dpcm_playback / dpcm_capture
Date:   Fri, 17 Jan 2020 00:15:27 +0100
Message-Id: <20200116231745.837240568@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Baluta <daniel.baluta@nxp.com>

commit 218fe9b7ec7f32c10a07539365488d80af7b0084 upstream.

When converting a normal link to a DPCM link we need
to set dpcm_playback / dpcm_capture otherwise playback/capture
streams will not be created resulting in errors like this:

[   36.039111]  sai1-wm8960-hifi: ASoC: no backend playback stream

Fixes: a655de808cbde ("ASoC: core: Allow topology to override machine driver FE DAI link config")
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20191204151333.26625-1-daniel.baluta@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1886,6 +1886,8 @@ match:
 
 			/* convert non BE into BE */
 			dai_link->no_pcm = 1;
+			dai_link->dpcm_playback = 1;
+			dai_link->dpcm_capture = 1;
 
 			/* override any BE fixups */
 			dai_link->be_hw_params_fixup =


